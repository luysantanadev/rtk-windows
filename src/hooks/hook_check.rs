//! Detects whether RTK hooks are installed and warns if they are outdated.

use super::constants::{
    CLAUDE_DIR, CLAUDE_HOOK_COMMAND, CURRENT_BINARY_HOOK_VERSION, HOOKS_SUBDIR, PRE_TOOL_USE_KEY,
    REWRITE_HOOK_FILE, SETTINGS_JSON,
};
use crate::core::constants::RTK_DATA_DIR;
use std::path::PathBuf;

const CURRENT_HOOK_VERSION: u8 = 3;
const WARN_INTERVAL_SECS: u64 = 24 * 3600;

/// Hook status for diagnostics and `rtk gain`.
#[derive(Debug, PartialEq, Clone)]
pub enum HookStatus {
    /// Hook is installed and up to date.
    Ok,
    /// Hook exists but is outdated or unreadable.
    Outdated,
    /// No hook file found (but Claude Code is installed).
    Missing,
}

/// Return the current hook status without printing anything.
/// Returns `Ok` if no Claude Code is detected (not applicable).
pub fn status() -> HookStatus {
    // Don't warn users who don't have Claude Code installed
    let home = match dirs::home_dir() {
        Some(h) => h,
        None => return HookStatus::Ok,
    };
    let claude_dir = home.join(CLAUDE_DIR);
    if !claude_dir.exists() {
        return HookStatus::Ok;
    }

    // Check for new binary command in settings.json first
    if let Some(registered_version) = binary_hook_version(&claude_dir) {
        if registered_version >= CURRENT_BINARY_HOOK_VERSION {
            // Binary hook registered with current or newer version
            // If old script still exists alongside new command, report Outdated
            let old_hook = claude_dir.join(HOOKS_SUBDIR).join(REWRITE_HOOK_FILE);
            if old_hook.exists() {
                return HookStatus::Outdated;
            }
            return HookStatus::Ok;
        } else {
            // Binary hook registered but with outdated version
            return HookStatus::Outdated;
        }
    }

    // Fall back to legacy script file check
    let Some(hook_path) = hook_installed_path() else {
        return HookStatus::Missing;
    };
    let Ok(content) = std::fs::read_to_string(&hook_path) else {
        return HookStatus::Outdated; // exists but unreadable — treat as needs-update
    };
    if parse_hook_version(&content) >= CURRENT_HOOK_VERSION {
        HookStatus::Ok
    } else {
        HookStatus::Outdated
    }
}

/// Check if the native binary command is registered in settings.json.
/// Delegates to `binary_hook_version` — returns true if any version is registered.
#[allow(dead_code)]
fn binary_hook_registered(claude_dir: &std::path::Path) -> bool {
    binary_hook_version(claude_dir).is_some()
}

/// Read the registered binary hook version from settings.json.
/// Returns `None` if the hook is not registered or the version field is missing.
pub fn binary_hook_version(claude_dir: &std::path::Path) -> Option<u8> {
    let settings_path = claude_dir.join(SETTINGS_JSON);
    let content = std::fs::read_to_string(&settings_path).ok()?;
    if content.trim().is_empty() {
        return None;
    }
    let root: serde_json::Value = serde_json::from_str(&content).ok()?;
    let pre_tool_use = root
        .get("hooks")
        .and_then(|h| h.get(PRE_TOOL_USE_KEY))
        .and_then(|p| p.as_array())?;
    // Find the entry with CLAUDE_HOOK_COMMAND and read its version
    pre_tool_use
        .iter()
        .filter_map(|entry| {
            let has_hook = entry
                .get("hooks")
                .and_then(|h| h.as_array())
                .map(|hooks| {
                    hooks.iter().any(|hook| {
                        hook.get("command")
                            .and_then(|c| c.as_str())
                            .is_some_and(|cmd| cmd == CLAUDE_HOOK_COMMAND)
                    })
                })
                .unwrap_or(false);
            if has_hook {
                entry.get("rtk_hook_version").and_then(|v| v.as_u64())
            } else {
                None
            }
        })
        .next()
        .map(|v| v as u8)
}

/// Check if the installed hook is missing or outdated, warn once per day.
pub fn maybe_warn() {
    // Don't block startup — fail silently on any error
    let _ = check_and_warn();
}

/// Single source of truth: delegates to `status()` then rate-limits the warning.
fn check_and_warn() -> Option<()> {
    let warning = match status() {
        HookStatus::Ok => return Some(()),
        HookStatus::Missing => {
            "[rtk] /!\\ No hook installed — run `rtk init -g` for automatic token savings"
        }
        HookStatus::Outdated => "[rtk] /!\\ Hook outdated — run `rtk init -g` to update",
    };

    // Rate limit: warn once per day
    let marker = warn_marker_path()?;
    if let Ok(meta) = std::fs::metadata(&marker) {
        if let Ok(modified) = meta.modified() {
            if modified.elapsed().map(|e| e.as_secs()).unwrap_or(u64::MAX) < WARN_INTERVAL_SECS {
                return Some(());
            }
        }
    }

    eprintln!("{}", warning);

    // Touch marker after warning is printed
    let _ = std::fs::create_dir_all(marker.parent()?);
    let _ = std::fs::write(&marker, b"");

    Some(())
}

/// Check if the registered binary hook version is outdated.
/// Returns `true` if the hook is registered but with an older version.
pub fn is_binary_hook_outdated(claude_dir: &std::path::Path) -> bool {
    match binary_hook_version(claude_dir) {
        Some(registered) => registered < CURRENT_BINARY_HOOK_VERSION,
        None => false, // Not registered — not outdated, just missing
    }
}

pub fn parse_hook_version(content: &str) -> u8 {
    // Version tag must be in the first 5 lines (shebang + header convention)
    for line in content.lines().take(5) {
        if let Some(rest) = line.strip_prefix("# rtk-hook-version:") {
            if let Ok(v) = rest.trim().parse::<u8>() {
                return v;
            }
        }
    }
    0 // No version tag = version 0 (outdated)
}

fn hook_installed_path() -> Option<PathBuf> {
    let home = dirs::home_dir()?;
    let path = home
        .join(CLAUDE_DIR)
        .join(HOOKS_SUBDIR)
        .join(REWRITE_HOOK_FILE);
    if path.exists() {
        Some(path)
    } else {
        None
    }
}

fn warn_marker_path() -> Option<PathBuf> {
    let data_dir = dirs::data_local_dir()?.join(RTK_DATA_DIR);
    Some(data_dir.join(".hook_warn_last"))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::hooks::constants::{
        CODEX_DIR, CONFIG_DIR, CURSOR_DIR, GEMINI_DIR, GEMINI_HOOK_FILE, HERMES_DIR,
        HERMES_PLUGINS_SUBDIR, HERMES_PLUGIN_MANIFEST_FILE, HERMES_PLUGIN_NAME,
        OPENCODE_PLUGIN_FILE, OPENCODE_SUBDIR, PLUGIN_SUBDIR,
    };

    fn other_integration_installed(home: &std::path::Path) -> bool {
        let paths = [
            home.join(CONFIG_DIR)
                .join(OPENCODE_SUBDIR)
                .join(PLUGIN_SUBDIR)
                .join(OPENCODE_PLUGIN_FILE),
            home.join(CURSOR_DIR)
                .join(HOOKS_SUBDIR)
                .join(REWRITE_HOOK_FILE),
            home.join(CODEX_DIR).join("AGENTS.md"),
            home.join(GEMINI_DIR)
                .join(HOOKS_SUBDIR)
                .join(GEMINI_HOOK_FILE),
            home.join(HERMES_DIR)
                .join(HERMES_PLUGINS_SUBDIR)
                .join(HERMES_PLUGIN_NAME)
                .join(HERMES_PLUGIN_MANIFEST_FILE),
        ];
        paths.iter().any(|p| p.exists())
    }

    #[test]
    fn test_parse_hook_version_present() {
        let content = "#!/usr/bin/env bash\n# rtk-hook-version: 2\n# some comment\n";
        assert_eq!(parse_hook_version(content), 2);
    }

    #[test]
    fn test_parse_hook_version_missing() {
        let content = "#!/usr/bin/env bash\n# old hook without version\n";
        assert_eq!(parse_hook_version(content), 0);
    }

    #[test]
    fn test_parse_hook_version_future() {
        let content = "#!/usr/bin/env bash\n# rtk-hook-version: 5\n";
        assert_eq!(parse_hook_version(content), 5);
    }

    #[test]
    fn test_parse_hook_version_no_tag() {
        assert_eq!(parse_hook_version("no version here"), 0);
        assert_eq!(parse_hook_version(""), 0);
    }

    #[test]
    fn test_hook_status_enum() {
        assert_ne!(HookStatus::Ok, HookStatus::Missing);
        assert_ne!(HookStatus::Outdated, HookStatus::Missing);
        assert_eq!(HookStatus::Ok, HookStatus::Ok);
        // Clone works
        let s = HookStatus::Missing;
        assert_eq!(s.clone(), HookStatus::Missing);
    }

    #[test]
    fn test_other_integration_none() {
        let tmp = tempfile::tempdir().expect("tempdir");
        assert!(!other_integration_installed(tmp.path()));
    }

    #[test]
    fn test_other_integration_opencode() {
        let tmp = tempfile::tempdir().expect("tempdir");
        let path = tmp
            .path()
            .join(CONFIG_DIR)
            .join(OPENCODE_SUBDIR)
            .join(PLUGIN_SUBDIR)
            .join(OPENCODE_PLUGIN_FILE);
        std::fs::create_dir_all(path.parent().unwrap()).unwrap();
        std::fs::write(&path, b"plugin").unwrap();
        assert!(other_integration_installed(tmp.path()));
    }

    #[test]
    fn test_other_integration_cursor() {
        let tmp = tempfile::tempdir().expect("tempdir");
        let path = tmp
            .path()
            .join(CURSOR_DIR)
            .join(HOOKS_SUBDIR)
            .join(REWRITE_HOOK_FILE);
        std::fs::create_dir_all(path.parent().unwrap()).unwrap();
        std::fs::write(&path, b"hook").unwrap();
        assert!(other_integration_installed(tmp.path()));
    }

    #[test]
    fn test_other_integration_codex() {
        let tmp = tempfile::tempdir().expect("tempdir");
        let path = tmp.path().join(CODEX_DIR).join("AGENTS.md");
        std::fs::create_dir_all(path.parent().unwrap()).unwrap();
        std::fs::write(&path, b"agents").unwrap();
        assert!(other_integration_installed(tmp.path()));
    }

    #[test]
    fn test_other_integration_gemini() {
        let tmp = tempfile::tempdir().expect("tempdir");
        let path = tmp
            .path()
            .join(GEMINI_DIR)
            .join(HOOKS_SUBDIR)
            .join(GEMINI_HOOK_FILE);
        std::fs::create_dir_all(path.parent().unwrap()).unwrap();
        std::fs::write(&path, b"hook").unwrap();
        assert!(other_integration_installed(tmp.path()));
    }

    #[test]
    fn test_other_integration_hermes() {
        let tmp = tempfile::tempdir().expect("tempdir");
        let path = tmp
            .path()
            .join(HERMES_DIR)
            .join(HERMES_PLUGINS_SUBDIR)
            .join(HERMES_PLUGIN_NAME)
            .join(HERMES_PLUGIN_MANIFEST_FILE);
        std::fs::create_dir_all(path.parent().unwrap()).unwrap();
        std::fs::write(&path, b"plugin").unwrap();
        assert!(other_integration_installed(tmp.path()));
    }

    #[test]
    fn test_other_integration_empty_dirs_not_enough() {
        let tmp = tempfile::tempdir().expect("tempdir");
        std::fs::create_dir_all(tmp.path().join(CURSOR_DIR).join(HOOKS_SUBDIR)).unwrap();
        std::fs::create_dir_all(tmp.path().join(CODEX_DIR)).unwrap();
        std::fs::create_dir_all(tmp.path().join(GEMINI_DIR)).unwrap();
        std::fs::create_dir_all(
            tmp.path()
                .join(HERMES_DIR)
                .join(HERMES_PLUGINS_SUBDIR)
                .join(HERMES_PLUGIN_NAME),
        )
        .unwrap();
        assert!(!other_integration_installed(tmp.path()));
    }

    #[test]
    fn test_status_returns_valid_variant() {
        // Skip on machines without Claude Code
        let home = match dirs::home_dir() {
            Some(h) => h,
            None => return,
        };
        let claude_dir = home.join(".claude");
        if !claude_dir.exists() {
            assert_eq!(status(), HookStatus::Ok);
            return;
        }
        // With .claude dir present, status must be one of the valid variants
        let s = status();
        assert!(
            s == HookStatus::Ok || s == HookStatus::Outdated || s == HookStatus::Missing,
            "Expected valid HookStatus variant, got {:?}",
            s
        );
    }

    #[test]
    fn test_binary_hook_version_reads_from_settings() {
        let tmp = tempfile::tempdir().expect("tempdir");
        let settings = tmp.path().join(SETTINGS_JSON);
        let content = serde_json::json!({
            "hooks": {
                "PreToolUse": [{
                    "matcher": "Bash",
                    "hooks": [{"type": "command", "command": "rtk hook claude"}],
                    "rtk_hook_version": 4
                }]
            }
        });
        std::fs::write(&settings, content.to_string()).unwrap();
        let version = binary_hook_version(tmp.path());
        assert_eq!(version, Some(4));
    }

    #[test]
    fn test_binary_hook_version_missing_field() {
        let tmp = tempfile::tempdir().expect("tempdir");
        let settings = tmp.path().join(SETTINGS_JSON);
        let content = serde_json::json!({
            "hooks": {
                "PreToolUse": [{
                    "matcher": "Bash",
                    "hooks": [{"type": "command", "command": "rtk hook claude"}]
                }]
            }
        });
        std::fs::write(&settings, content.to_string()).unwrap();
        let version = binary_hook_version(tmp.path());
        assert_eq!(version, None);
    }

    #[test]
    fn test_binary_hook_version_not_registered() {
        let tmp = tempfile::tempdir().expect("tempdir");
        let version = binary_hook_version(tmp.path());
        assert_eq!(version, None);
    }

    #[test]
    fn test_is_binary_hook_outdated_current_version() {
        let tmp = tempfile::tempdir().expect("tempdir");
        let settings = tmp.path().join(SETTINGS_JSON);
        let content = serde_json::json!({
            "hooks": {
                "PreToolUse": [{
                    "matcher": "Bash",
                    "hooks": [{"type": "command", "command": "rtk hook claude"}],
                    "rtk_hook_version": CURRENT_BINARY_HOOK_VERSION
                }]
            }
        });
        std::fs::write(&settings, content.to_string()).unwrap();
        assert!(!is_binary_hook_outdated(tmp.path()));
    }

    #[test]
    fn test_is_binary_hook_outdated_old_version() {
        let tmp = tempfile::tempdir().expect("tempdir");
        let settings = tmp.path().join(SETTINGS_JSON);
        let content = serde_json::json!({
            "hooks": {
                "PreToolUse": [{
                    "matcher": "Bash",
                    "hooks": [{"type": "command", "command": "rtk hook claude"}],
                    "rtk_hook_version": 1
                }]
            }
        });
        std::fs::write(&settings, content.to_string()).unwrap();
        assert!(is_binary_hook_outdated(tmp.path()));
    }

    #[test]
    fn test_is_binary_hook_outdated_not_registered() {
        let tmp = tempfile::tempdir().expect("tempdir");
        assert!(!is_binary_hook_outdated(tmp.path()));
    }
}
