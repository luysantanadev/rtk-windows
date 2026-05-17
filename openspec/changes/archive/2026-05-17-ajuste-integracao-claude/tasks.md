## 1. Hook Versioning

- [x] 1.1 Add `rtk_hook_version` field to PreToolUse hook entry in `patch_settings_json_command()`
- [x] 1.2 Add `CURRENT_BINARY_HOOK_VERSION` constant in `src/hooks/constants.rs`
- [x] 1.3 Update `hook_already_present()` to check version field alongside command
- [x] 1.4 Add `binary_hook_version()` function in `src/hooks/hook_check.rs` to read version from settings.json
- [x] 1.5 Update `maybe_warn()` to compare registered version against current and warn if outdated
- [x] 1.6 Add tests for version storage, reading, and outdated detection

## 2. Integrity Checking

- [x] 2.1 Update `runtime_check()` in `src/hooks/integrity.rs` to verify binary hook registration
- [x] 2.2 Add `verify_binary_hook_registered()` function that checks settings.json for `rtk hook claude` with correct version
- [x] 2.3 Update legacy script check to skip gracefully when script doesn't exist (already done, verify)
- [x] 2.4 Add tests for binary hook integrity verification

## 3. RTK Awareness Instructions

- [x] 3.1 Create `hooks/claude/rtk-awareness-v2.md` with comprehensive command coverage
- [x] 3.2 Update `RTK_SLIM` constant in `src/hooks/init.rs` to embed the new v2 instructions
- [x] 3.3 Ensure RTK awareness covers: git, cargo, npm/pnpm, docker, kubectl, go, python, ruby, .NET, system commands
- [x] 3.4 Include token savings expectations per category in the instructions
- [x] 3.5 Document all meta commands (gain, discover, proxy, init, config, verify, trust, untrust)
- [x] 3.6 Test that `rtk init` installs the new instructions correctly

## 4. Installation Lifecycle

- [x] 4.1 Audit all init modes (default, hook-only, claude-md, codex) for artifact consistency
- [x] 4.2 Fix any inconsistencies in artifact installation across modes
- [x] 4.3 Update `uninstall()` to ensure all Claude artifacts are removed consistently
- [x] 4.4 Verify legacy migration (`migrate_old_hook_script`) handles all edge cases
- [x] 4.5 Add tests for installation/uninstallation consistency

## 5. Permission System

- [x] 5.1 Audit `src/hooks/permissions.rs` for transparent prefix handling gaps
- [x] 5.2 Apply transparent prefix stripping before permission rule matching in `process_claude_payload()`
- [x] 5.3 Verify compound command permission checking follows deny > ask > allow precedence
- [x] 5.4 Add tests for permission rules with transparent prefixes
- [x] 5.5 Add tests for compound command permission checking

## 6. Command Rewrite Registry

- [x] 6.1 Audit `src/discover/registry.rs` for missing command rewrite rules
- [x] 6.2 Add rewrite rules for any commonly-used commands without coverage
- [x] 6.3 Verify compound command rewriting handles all operator types (`&&`, `||`, `;`, `|`)
- [x] 6.4 Verify environment prefix preservation in rewritten commands
- [x] 6.5 Add regression tests for edge cases in compound command rewriting

## 7. Audit Logging

- [x] 7.1 Add first-run warning when hook executes without `RTK_HOOK_AUDIT=1` (rate-limited to 1/day)
- [x] 7.2 Update `hooks/README.md` to document audit logging feature
- [x] 7.3 Add tests for audit logging warning behavior

## 8. Build Verification

- [x] 8.1 Run `cargo fmt --all` to format code
- [x] 8.2 Run `cargo clippy --all-targets` and fix all warnings
- [x] 8.3 Run `cargo test --all` and ensure all tests pass
- [x] 8.4 Run smoke tests with `rtk init` and `rtk hook claude` to verify end-to-end flow
