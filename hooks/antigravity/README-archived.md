# ⚠️ Google Antigravity (Archived — Non-Windows)

This integration is **archived** for the Windows/PowerShell consolidation of RTK.

For cross-platform Antigravity support, use the upstream repository:  
https://github.com/luysantanadev/rtk-windows.git

**Why archived:** RTK Windows-only focuses exclusively on Windows 10/11 with PowerShell Core or Command Prompt. Antigravity is a cross-platform AI agent that is not commonly used on Windows development environments.

If you need Antigravity support, please:
1. Use upstream RTK for cross-platform support
2. Request a Windows/PowerShell-specific Antigravity integration by opening an issue

---

**Original documentation** (for reference):

## Specifics

- Prompt-level guidance only (no programmatic hook) -- relies on Antigravity reading custom instructions
- `rules.md` contains the instruction to prefix all shell commands with `rtk`, usage examples, and meta commands
- Installed to `.agents/rules/antigravity-rtk-rules.md` (project-local) by `rtk init --agent antigravity`
