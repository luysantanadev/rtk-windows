## Context

The Claude Code integration is RTK's primary hook system. It intercepts Bash commands from Claude Code via a `PreToolUse` hook, rewrites them to their RTK equivalents (e.g., `git status` → `rtk git status`), and returns the rewritten command. The integration has evolved from a shell script (`rtk-rewrite.sh`) to a native Rust binary (`rtk hook claude`), but the transition left several gaps:

- **Version tracking**: `hook_check.rs` tracks `CURRENT_HOOK_VERSION: u8 = 3` for the legacy script, but the binary hook has no version. The `binary_hook_registered()` check only verifies presence.
- **Integrity checking**: `integrity.rs` only verifies the legacy script's SHA-256 hash. The binary hook bypasses this entirely.
- **RTK awareness**: `rtk-awareness.md` is 10 lines covering only meta commands. Claude has no guidance on which commands are supported or expected token savings.
- **Installation consistency**: `rtk init` and `rtk init --uninstall` handle artifacts differently across modes (default, hook-only, claude-md, codex).
- **Permission system**: Pattern matching for deny/ask/allow rules has edge cases with compound commands and transparent prefixes.
- **Rewrite registry**: Some commands lack rewrite rules; compound command handling has known edge cases.

## Goals / Non-Goals

**Goals:**
- Add version tracking for the binary Claude hook so outdated hook warnings work correctly
- Update integrity verification to cover binary hook registration state
- Expand RTK awareness instructions to cover all supported commands and workflows
- Ensure installation/uninstallation handles all Claude artifacts consistently
- Audit and improve permission rule loading and pattern matching
- Audit and improve command rewrite registry coverage
- Make hook audit logging more discoverable

**Non-Goals:**
- Rewriting the hook architecture (keep PreToolUse + binary command approach)
- Adding support for other AI agents (focus on Claude only)
- Changing the rewrite engine's core algorithm (improve rules, not the engine)
- Breaking existing installations (migration must be backward-compatible)

## Decisions

1. **Hook versioning decision**: Store hook version in `settings.json` alongside the hook entry, not in a separate file.
   - Rationale: Version travels with the hook entry; no new file paths to manage.
   - Alternative: Store in `~/.claude/hooks/version.json`; rejected because it adds a new file and sync complexity.
   - Implementation: Add `"rtk_hook_version": 4` to the PreToolUse hook entry JSON.

2. **Integrity checking decision**: Replace SHA-256 script hash with binary path verification + version check.
   - Rationale: Binary hooks can't be tampered with at the file level (they're the RTK binary itself). Integrity means "correct version registered."
   - Alternative: Keep legacy hash check; rejected because it's meaningless for binary hooks.
   - Implementation: `runtime_check()` verifies `rtk hook claude` is in settings.json with correct version.

3. **RTK awareness expansion decision**: Create a new `rtk-awareness-v2.md` with comprehensive command coverage, replacing the embedded 10-line version.
   - Rationale: Claude needs to know which commands have RTK equivalents to use them confidently.
   - Alternative: Generate instructions dynamically; rejected because static files are simpler and faster.
   - Implementation: Embed from `hooks/claude/rtk-awareness-v2.md` (~50 lines covering all command categories).

4. **Permission system decision**: Keep current deny > ask > allow precedence but improve pattern matching for transparent prefixes.
   - Rationale: Current precedence is correct; the issue is pattern matching doesn't account for stripped prefixes.
   - Alternative: Change precedence; rejected because deny-first is the secure default.
   - Implementation: Apply transparent prefix stripping before permission rule matching.

5. **Audit logging decision**: Keep opt-in via `RTK_HOOK_AUDIT=1` but add a warning when the hook runs without audit enabled.
   - Rationale: Audit logging adds overhead; opt-in is correct for production. Warning helps developers discover it.
   - Alternative: Enable by default; rejected due to performance impact on every command.
   - Implementation: Add `eprintln!` warning on first hook execution without audit enabled (rate-limited to 1/day).

## Risks / Trade-offs

- [Risk] Version field in settings.json may conflict with user edits → Mitigation: Use a namespaced key (`rtk_hook_version`) unlikely to collide with user settings.
- [Risk] Expanded RTK awareness instructions increase CLAUDE.md size → Mitration: Keep under 50 lines; use compact format.
- [Risk] Permission rule changes may break existing allow/deny configurations → Mitigation: Add backward-compatible pattern matching; test with existing configs.
- [Risk] Rewrite registry changes may introduce regressions → Mitigation: Run full rewrite test suite; add regression tests for edge cases.
- [Trade-off] Binary hook integrity check is weaker than SHA-256 script hash → Acceptable because binary is the RTK executable itself (signed build), not a user-editable script.
