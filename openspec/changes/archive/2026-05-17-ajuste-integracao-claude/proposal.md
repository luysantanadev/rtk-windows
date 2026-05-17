## Why

The Claude Code integration in RTK has evolved from a shell-script-based hook (`rtk-rewrite.sh`) to a native binary command (`rtk hook claude`), but several gaps remain: no version tracking for binary hooks, legacy integrity checks that don't apply to the new hook, minimal RTK awareness instructions that leave Claude unaware of supported commands, and installation flows that can leave stale artifacts. A comprehensive review and adjustment will improve reliability, security, and the developer experience.

## What Changes

- **Hook versioning**: Add version tracking for the binary `rtk hook claude` hook so outdated hook warnings work correctly
- **Integrity checking**: Update integrity verification to cover the new binary hook registration state, not just the legacy script
- **RTK awareness instructions**: Expand `rtk-awareness.md` from 10 lines to cover all supported commands, token savings expectations, and common workflows
- **Installation cleanup**: Ensure `rtk init` and `rtk init --uninstall` handle all Claude artifacts consistently (settings.json, RTK.md, CLAUDE.md references, legacy script migration)
- **Permission system audit**: Review and improve the deny/ask/allow permission rule loading, pattern matching, and compound command handling
- **Command rewriting improvements**: Audit the rewrite registry for missing commands, incorrect patterns, and edge cases in compound command handling
- **Audit logging**: Make hook audit logging more discoverable and consider enabling it by default in development mode
- **Error handling**: Improve error messages when the Claude hook fails to parse JSON or encounters unexpected payloads

## Capabilities

### New Capabilities
- `claude-hook-versioning`: Version tracking and detection for the binary Claude hook, replacing legacy script-only version checks
- `claude-rtk-awareness`: Comprehensive RTK instructions embedded in CLAUDE.md covering all supported commands and workflows
- `claude-installation-lifecycle`: Complete init/uninstall/migration flow for Claude hooks with consistent artifact management

### Modified Capabilities
- `claude-hook-integrity`: Update integrity verification to cover binary hook registration state
- `claude-permission-system`: Improve permission rule loading, pattern matching, and compound command handling
- `command-rewrite-registry`: Expand and improve command rewrite rules for better coverage and edge case handling

## Impact

- Affected code: `src/hooks/init.rs`, `src/hooks/hook_cmd.rs`, `src/hooks/hook_check.rs`, `src/hooks/integrity.rs`, `src/hooks/permissions.rs`, `src/discover/registry.rs`, `hooks/claude/rtk-awareness.md`
- Affected docs: `hooks/claude/README.md`, contributor docs referencing hook installation
- Breaking: Users with stale legacy hook entries in settings.json may see cleaner removal on uninstall; RTK.md content changes will update on next `rtk init`
