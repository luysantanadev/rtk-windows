## Runtime / Spawn Inventory (Task 1.2)

Objective: classify Unix/macOS-related execution paths for Windows-only migration.

### Classification Key
- KEEP: required for Windows-native behavior
- REMOVE: Unix-only or cross-platform branch no longer needed in this fork
- ARCHIVE: historical docs/scripts to retain only as migration reference

## Findings

1. src/core/runner.rs
- Finding: central command execution skeleton using Command builder and stream pipeline.
- Classification: KEEP
- Rationale: required by all command modules in Windows runtime.

2. src/core/utils.rs (exit_code_from_output / exit_code_from_status)
- Finding: contains cfg(unix) signal path using ExitStatusExt, with generic fallback.
- Classification: REMOVE (unix branch)
- Rationale: fork compiles only on Windows; Unix signal mapping is unnecessary here.

3. src/core/stream.rs (status_to_exit_code)
- Finding: includes cfg(unix) signal extraction (128 + signal).
- Classification: REMOVE (unix branch)
- Rationale: no Unix target in Windows-only fork.

4. src/core/stream.rs tests (test_exit_code_signal_kill under cfg(unix))
- Finding: Unix-only signal-kill behavior test.
- Classification: REMOVE
- Rationale: not applicable on Windows-only contract.

5. src/cmds/rust/runner.rs (build_shell_command)
- Finding: runtime shell switch cmd /C (Windows) vs sh -c (non-Windows).
- Classification: REMOVE (non-Windows branch), KEEP (cmd /C path)
- Rationale: explicit Windows-only spawn semantics.

6. src/cmds/system/summary.rs (run)
- Finding: runtime shell switch cmd /C (Windows) vs sh -c (non-Windows).
- Classification: REMOVE (non-Windows branch), KEEP (cmd /C path)
- Rationale: explicit Windows-only spawn semantics.

7. Cargo.toml (target.'cfg(unix)'.dependencies libc)
- Finding: Unix-only dependency section.
- Classification: REMOVE
- Rationale: no Unix target in this fork.

8. .github/workflows/ci.yml
- Finding: Ubuntu/macOS runners and Bash-based checks still active.
- Classification: REMOVE/REPLACE (later CI tasks)
- Rationale: will migrate to windows-latest and PowerShell scripts in tasks 4.x.

9. README.md and docs/hook guidance with Linux/macOS active instructions
- Finding: mixed platform messaging with active Linux/macOS flows.
- Classification: ARCHIVE/REWRITE (tasks 5.x)
- Rationale: docs must present Windows-only support and redirect to upstream.

## Remove / Keep / Archive Summary

### REMOVE
- Unix cfg branches in:
  - src/core/utils.rs
  - src/core/stream.rs
  - src/cmds/rust/runner.rs
  - src/cmds/system/summary.rs
- Unix-only test in src/core/stream.rs
- Cargo.toml unix dependency section

### KEEP
- Windows cmd /C spawn behavior
- Command builder-based execution pipeline in src/core/runner.rs
- Existing Windows hook migration + idempotency behavior in src/hooks/init.rs

### ARCHIVE
- Linux/macOS procedural guidance in docs as historical context only (with upstream redirect)
- Legacy shell references where needed for migration notes
