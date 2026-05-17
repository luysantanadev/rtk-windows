# ⚠️ Codex CLI (Archived — Non-Windows)

This integration is **archived** for the Windows/PowerShell consolidation of RTK.

For cross-platform Codex CLI support, use the upstream repository:  
https://github.com/luysantanadev/rtk-windows.git

**Why archived:** RTK Windows-only focuses exclusively on Windows 10/11 with PowerShell Core or Command Prompt. Codex CLI is a cross-platform AI agent that is not commonly used on Windows development environments.

If you need Codex CLI support, please:
1. Use upstream RTK for cross-platform support
2. Request a Windows/PowerShell-specific Codex CLI integration by opening an issue

---

**Original documentation** (for reference):

## Specifics

- Prompt-level guidance via awareness document -- no programmatic hook
- `rtk-awareness.md` is injected into `AGENTS.md` with an `@RTK.md` reference
- Installed to `$CODEX_HOME` when set, otherwise `~/.codex/`, by `rtk init --codex`
