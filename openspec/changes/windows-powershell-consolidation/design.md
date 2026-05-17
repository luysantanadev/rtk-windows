## Context

RTK-Windows is deployed on Windows with PowerShell Core as the primary shell. Currently, the codebase includes:
- Multiple shell hook scripts (rtk-rewrite.sh) for Unix-based agents (Claude Code, Copilot, Cursor, Cline, Windsurf, Codex)
- Documentation examples showing bash/zsh setup and installation via brew, apt, curl
- Installation scripts with Unix-centric paths and environment patterns
- Troubleshooting guides referencing ~/.bashrc, ~/.zshrc, and other Unix conventions
- Agent integration guides mentioning non-Windows agents and shell environments

The goal is to consolidate RTK as a Windows-only tool with explicit PowerShell Core support, removing all cross-platform complexity and confusion.

## Goals / Non-Goals

**Goals:**
- Remove all Linux/bash/macOS references from documentation, guides, examples, and code comments
- Consolidate hook system to Windows-only agents (Copilot, Cursor, Cline, OpenCode, Hermes)
- Standardize on PowerShell Core (pwsh) for all examples and documentation
- Update installation guidance to Windows-only (cargo install, direct .exe download)
- Convert all environment setup patterns to Windows equivalents (avoid ~/.bashrc, use Windows profile pattern)
- Simplify troubleshooting guides to focus on Windows scenarios only

**Non-Goals:**
- Remove Rust cross-platform code (internal implementation can remain platform-agnostic)
- Modify core RTK filter logic (this change is about communication and documentation, not functionality)
- Migrate existing RTK users from non-Windows systems (treat as end-of-life for those platforms)
- Create new Windows-only Rust features (maintain current feature parity)

## Decisions

**Decision 1: Archive vs. Delete Unix Hook Scripts**
- **Choice**: Archive Unix shell scripts in `hooks/archive/` rather than delete. Rationale: Provides historical reference and enables future reversal if needed, while making directory structure clearly Windows-only.
- **Alternative Considered**: Complete deletion — simpler but loses history.

**Decision 2: Documentation Consolidation Strategy**
- **Choice**: Create single "Windows/PowerShell" getting-started guide; remove separate platform guides from `docs/guide/getting-started/`. Convert all example code blocks to PowerShell.
- **Alternative Considered**: Maintain multi-platform docs with "Windows Recommended" badges — too ambiguous about actual support.

**Decision 3: Installation Path**
- **Choice**: Single installation method: `cargo install --path .` (for developers) or direct binary download from releases (for users). Remove brew, apt, and curl installation instructions.
- **Alternative Considered**: Keep package manager instructions for historical compatibility — conflicts with "Windows-only" goal.

**Decision 4: Environment Configuration Pattern**
- **Choice**: Direct documentation references PowerShell `$PROFILE` pattern (`notepad $PROFILE` to add rtk-windows to PATH). No references to ~/.bashrc or ~/.zshrc.
- **Alternative Considered**: Use environment variables for all agents — less idiomatic for Windows, harder to document per-agent.

**Decision 5: Agent Integration Scope**
- **Choice**: Document only Windows-capable agents: Copilot, Cursor, Cline, OpenCode, Hermes (if PowerShell Core compatible). Remove references to Linux-only agents.
- **Rationale**: Clarifies supported integration scope. RTK hooks for those agents are Windows-only anyway.

## Risks / Trade-offs

| Risk | Mitigation |
|------|-----------|
| **Existing Unix User Confusion** → Users on non-Windows systems may attempt installation and encounter errors | Add prominent platform requirement notice in README ("Windows/PowerShell Core Only") early and consistently |
| **Documentation Debt** → Removing multi-platform examples may create Git history questions | Commit with clear message: "Consolidate to Windows-only per platform scope" — preserve Git history for auditing |
| **Hook Script Availability** → If someone needs old Unix hooks, archived scripts may not be discoverable | Include brief migration note in archived folder explaining purpose and pointing to main Windows hooks |
| **Package Manager Expectations** → Users familiar with `brew install rtk` or `apt install rtk` may be confused | Clearly document "Windows cargo install" as only supported method with prominent GitHub release downloads |
| **Cross-Platform CI/CD** → If RTK is used in CI systems, Unix removal may break those workflows | CI/CD systems should use direct binary download or cargo install anyway; this aligns with actual support |

## Migration Plan

1. **Phase 1 - Audit & Inventory** (0-1 sprint):
   - Scan all files for Linux/bash/macOS keywords
   - Create inventory of affected files by category

2. **Phase 2 - Remove Unix Hooks & Scripts** (1-2 sprints):
   - Archive Unix hook scripts (rtk-rewrite.sh) for all agents
   - Remove shell-specific setup logic from hook docs

3. **Phase 3 - Consolidate Documentation** (2-3 sprints):
   - Rewrite README.md to highlight Windows-only scope
   - Update INSTALL.md with single Windows installation path
   - Simplify getting-started guides to PowerShell Core examples

4. **Phase 4 - Update Agent Integration Guides** (3-4 sprints):
   - Consolidate supported agents list to Windows-only
   - Update hook mechanism documentation
   - Remove references to non-Windows agents

5. **Phase 5 - Validation & Testing** (4-5 sprints):
   - Test installation on clean Windows systems
   - Verify all PowerShell examples work end-to-end
   - Update troubleshooting guide with Windows-only scenarios

**Rollback Strategy**: All changes are additive (archiving) or documentation-only. If needed, restore from Git history and restore Unix hook scripts from archive.

## Open Questions

1. Should rtk-windows binary name change to just `rtk` on Windows, or maintain `rtk-windows` for clarity?
   - Current decision: Keep `rtk-windows` for Windows scoping clarity
   - Needs validation from maintainers

2. Are there existing non-Windows users who should receive transition documentation?
   - Current decision: Not in scope (treat as end-of-life for Unix platforms)
   - Maintainers may want to add transition notice to old releases

3. Should Rust cross-platform code (internal implementation) be modified for Windows-only compilation?
   - Current decision: No — keep Rust code platform-agnostic internally, constrain only user-facing documentation
   - Simplifies maintenance if future cross-platform support is reconsidered
