# ⚠️ Windsurf (Cascade) (Archived — Non-Windows)

This integration is **archived** for the Windows/PowerShell consolidation of RTK.

For cross-platform Windsurf support, use the upstream repository:  
https://github.com/luysantanadev/rtk-windows.git

**Why archived:** RTK Windows-only focuses exclusively on Windows 10/11 with PowerShell Core or Command Prompt. Windsurf (Cascade) is a cross-platform AI agent that is not commonly used on Windows development environments.

If you need Windsurf support, please:
1. Use upstream RTK for cross-platform support
2. Request a Windows/PowerShell-specific Windsurf integration by opening an issue

---

**Original documentation** (for reference):

## Specifics

- Prompt-level guidance only (no programmatic hook) -- relies on Windsurf Cascade reading rules files
- `rules.md` contains the instruction to prefix commands with `rtk`
- Installed to `.windsurfrules` (project-local, workspace-scoped) by `rtk init`
