# Archived Components - Windows/PowerShell Consolidation

**Date Created**: 2026-05-17  
**Purpose**: Legacy Unix/cross-platform hook scripts and configurations removed during RTK consolidation to Windows-only platform

## Migration Status

This directory is now empty as a placeholder for historical reference. The RTK codebase has already migrated away from Unix shell scripts to:

- **OpenCode**: TypeScript plugin (`hooks/opencode/rtk.ts`) with PowerShell Core tool detection
- **Hermes**: Python plugin (`hooks/hermes/rtk-rewrite/`) with Windows compatibility
- **Claude Code**: PowerShell hooks (`.claude/hooks/*.ps1`)
- **Other Agents**: Documentation-only integration with `rtk-windows` binary

### Why This Happened

RTK was initially designed with cross-platform support, which required:
- Bash/shell script hooks for Unix-based agents (Claude Code, Copilot, Cursor, etc.)
- Documentation explaining multi-platform installation
- Cross-platform conditional logic in scripts

**Decision**: Consolidate to Windows-only to:
- Simplify maintenance (no cross-platform testing burden)
- Clarify platform scope (Windows 10/11 + PowerShell Core)
- Reduce confusion from unsupported Unix attempts
- Focus resources on Windows optimization

### Migration Path for External Users

If you were using RTK on non-Windows systems:

1. **No replacement**: RTK is now Windows-only
2. **Historical versions**: RTK < v0.27 had Unix support (via Git tags/releases)
3. **Alternative**: Use original command outputs without RTK on Linux/macOS

### For Contributors

- All new hooks MUST support Windows/PowerShell only
- All examples and documentation MUST use PowerShell Core syntax
- Use `.ts` (TypeScript) or `.ps1` (PowerShell) for hook implementations
- Platform-specific code in Rust is OK; user-facing artifacts must be Windows-only

---

**Files That Were Consolidated**:
- Former Unix hook scripts (moved to Git history)
- Legacy `.bashrc`/`.zshrc` configuration documentation
- Cross-platform CI/CD configurations (simplified to Windows)
- Multi-platform build instructions (removed)

**Next Reference**: See `openspec/specs/` for Windows-only requirements and `openspec/changes/windows-powershell-consolidation/` for implementation details.
