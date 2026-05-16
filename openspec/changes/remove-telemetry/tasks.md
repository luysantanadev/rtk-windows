## 1. Telemetry Code Removal

- [x] 1.1 Remove `src/core/telemetry.rs` file entirely
- [x] 1.2 Remove `src/core/telemetry_cmd.rs` file entirely
- [x] 1.3 Remove telemetry module declarations from `src/core/mod.rs`
- [x] 1.4 Remove `TelemetrySubcommand` variant and routing from `src/main.rs`
- [x] 1.5 Remove `save_telemetry_consent()` function from `src/hooks/init.rs`

## 2. Configuration Cleanup

- [x] 2.1 Remove `telemetry` field from `Config` struct in `src/core/config.rs`
- [x] 2.2 Remove telemetry-related config parsing and defaults
- [x] 2.3 Verify existing config files with `[telemetry]` sections do not cause errors

## 3. Dependency Cleanup

- [x] 3.1 Audit `ureq` usage — remove from Cargo.toml if only used by telemetry
- [x] 3.2 Audit `sha2` usage — kept (used by hook integrity, not telemetry)
- [x] 3.3 Audit `getrandom` usage — remove from Cargo.toml if only used by telemetry
- [x] 3.4 Remove any other telemetry-only dependencies

## 4. Documentation Updates

- [x] 4.1 Remove `docs/TELEMETRY.md` file
- [x] 4.2 Update README.md to remove telemetry references
- [x] 4.3 Update CLAUDE.md to remove telemetry references
- [x] 4.4 Update any other documentation files referencing telemetry

## 5. Build Verification

- [x] 5.1 Run `cargo fmt --all` to format code
- [x] 5.2 Run `cargo clippy --all-targets` and fix all warnings
- [x] 5.3 Run `cargo test --all` and ensure all tests pass
- [x] 5.4 Verify `rtk gain` still works (local tracking unaffected)
- [x] 5.5 Verify `rtk telemetry` command is no longer available
