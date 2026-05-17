# RTK Windows Coding Practices Addendum

**Platform:** Windows 10/11 only | **PowerShell Core 7+** | **No Unix/Linux/macOS support**

This addendum applies to the [RTK Coding Practices v1.0](./CODING_PRACTICES.md) document with Windows-specific constraints.

## Windows-Only Code

RTK Windows is **exclusively for Windows 10/11** with PowerShell Core. All code targeting Unix platforms (`#[cfg(unix)]`, `/bin/sh`, `/bin/bash`) is forbidden.

### Allowed Patterns

```rust
// ✅ Windows-only conditional compilation
#[cfg(target_os = "windows")]
fn windows_specific_code() { ... }

// ✅ PowerShell path usage
let config_path = format!("{}\\rtk\\config.toml", env::var("APPDATA").unwrap());

// ✅ Windows path separators
const PATH_SEPARATOR: char = '\\';
```

### Forbidden Patterns

```rust
// ❌ NO: Unix-specific code
#[cfg(unix)]
fn unix_signal_handling() { ... }

// ❌ NO: POSIX shell paths
"/bin/sh", "/bin/bash", "/usr/bin/", "$HOME"

// ❌ NO: Cross-platform conditionals (choose Windows only)
#[cfg(target_os = "linux")]
#[cfg(target_os = "macos")]

// ❌ NO: symlink or Unix filesystem operations (use Windows API)
std::os::unix::fs::symlink()
```

## PowerShell Integration

All RTK hooks that need shell integration must use **PowerShell Core (pwsh)** or Command Prompt (cmd.exe), never bash/sh/zsh.

### Hook Command Examples

```rust
// ✅ Correct: PowerShell command
let hook_cmd = "pwsh -NoProfile -Command ...";

// ❌ Wrong: bash
let hook_cmd = "bash -c ...";
```

### Path Handling

Always use Windows paths in environment variables and config files:

```rust
// ✅ Correct: Windows paths
let home = env::var("APPDATA").unwrap();           // $env:APPDATA
let local = env::var("LOCALAPPDATA").unwrap();     // $env:LOCALAPPDATA
let user = env::var("USERPROFILE").unwrap();       // $env:USERPROFILE

// ❌ Wrong: Unix paths
let home = env::var("HOME").unwrap();              // Only on WSL, not native Windows
```

### Environment Variables

RTK uses Windows environment variables exclusively:

| Env Var | Purpose | Windows | Unix |
|---------|---------|---------|------|
| `$env:APPDATA` | Config/cache dir | ✅ Yes | ❌ No |
| `$env:LOCALAPPDATA` | Local cache | ✅ Yes | ❌ No |
| `$env:USERPROFILE` | User home | ✅ Yes | ❌ No |
| `$env:TEMP` | Temp directory | ✅ Yes | ❌ No |
| `$HOME` | User home | ⚠️ WSL only | Unix only |

## Testing on Windows

All tests must execute on Windows (native, not WSL):

```rust
#[test]
fn test_windows_path_handling() {
    // Test must pass on Windows 10/11
    let path = format!("{}\\rtk\\data", env::var("APPDATA").unwrap());
    assert!(path.contains("\\"), "Must use backslash on Windows");
}
```

**No platform-specific skipping.** Tests for Windows-only code must always run when compiled on Windows. Use `#[cfg(target_os = "windows")]` if needed, not `#[ignore]`.

## `unsafe` Code

`unsafe` code is **not permitted** except in documented, security-critical sections (e.g., FFI for Windows API calls if needed). All uses must:

1. Have a `// SAFETY:` comment explaining why it's safe
2. Be scoped to Windows only via `#[cfg(target_os = "windows")]`
3. Be reviewed by at least one maintainer

Example (if FFI needed):
```rust
#[cfg(target_os = "windows")]
unsafe {
    // SAFETY: This Windows API call is safe because [explanation]
    windows_sys::Win32::System::Com::CoInitializeEx(...);
}
```

## Documentation Comments

All doc comments must reference Windows paths and PowerShell exclusively:

```rust
/// Returns the RTK configuration file path.
///
/// # Windows
/// Returns: `$env:APPDATA\rtk\config.toml`
///
/// # Examples
///
/// ```no_run
/// use rtk::core::config;
/// let path = config::get_config_path();
/// // On Windows: C:\Users\Username\AppData\Roaming\rtk\config.toml
/// ```
pub fn get_config_path() -> PathBuf { ... }
```

**Never** include Unix/Linux/macOS documentation in RTK Windows code.

## Build Targets

RTK Windows compiles **exclusively** for Windows targets:

```bash
# ✅ Supported build targets
cargo build --target x86_64-pc-windows-msvc
cargo build --target aarch64-pc-windows-msvc       # Windows ARM64

# ❌ Not supported (forbidden in PRs)
cargo build --target x86_64-unknown-linux-gnu
cargo build --target x86_64-apple-darwin
```

## Contributing Windows Code

Before submitting a PR that touches system integration:

1. **Verify Windows path usage:** All file paths must use Windows conventions (`C:\Users\...`, `$env:APPDATA`)
2. **Check PowerShell commands:** All shell command examples must be PowerShell Core (`pwsh` or `powershell`)
3. **Remove Unix conditionals:** Search PR diff for `#[cfg(unix)]`, `target_os = "linux"`, `target_os = "macos"` — these are forbidden
4. **Test on Windows:** Verify code runs on Windows 10/11, not just in CI
5. **Update documentation:** All code comments and examples must reflect Windows-only platform

---

For questions or clarifications on Windows-specific coding practices, please open an issue or discussion in the repository.
