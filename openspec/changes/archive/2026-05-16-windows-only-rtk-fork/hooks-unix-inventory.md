## Hooks Unix Inventory (Task 2.1)

Objective: classify shell-only Unix hook components against the Windows-only contract.

### Decision Summary

#### REMOVE
- hooks/claude/rtk-rewrite.sh
- hooks/cursor/rtk-rewrite.sh
- hooks/claude/test-rtk-rewrite.sh
- hooks/copilot/test-rtk-rewrite.sh
- src/hooks references that still require legacy shell hook file names where Rust-native equivalents exist

#### ARCHIVE (historical reference only)
- .claude/hooks/rtk-rewrite.sh
- .claude/hooks/rtk-suggest.sh
- .claude/hooks/bash/pre-commit-format.sh
- legacy shell-centric docs/examples in hooks/**/README.md

#### KEEP
- .github/hooks/rtk-rewrite.json (Copilot hook config)
- src/hooks/hook_cmd.rs native handlers for copilot/claude/cursor/gemini
- src/hooks/init.rs migration flow for legacy rtk-rewrite.sh -> Rust-native hooks

## Detailed Findings

1. hooks/claude/rtk-rewrite.sh
- Type: shell-only implementation
- Decision: REMOVE
- Reason: Windows-only fork uses Rust-native hook commands.

2. hooks/cursor/rtk-rewrite.sh
- Type: shell-only implementation
- Decision: REMOVE
- Reason: superseded by `rtk hook cursor` native path.

3. hooks/claude/test-rtk-rewrite.sh and hooks/copilot/test-rtk-rewrite.sh
- Type: shell-only test harnesses
- Decision: REMOVE
- Reason: replaced by Rust-native test suites in src/hooks.

4. src/hooks/constants.rs `REWRITE_HOOK_FILE` and related legacy names
- Type: compatibility reference for migration/integrity/check flows
- Decision: KEEP (temporary), then prune where no longer needed after migration coverage is validated.
- Reason: still required for safe migration from legacy installs.

5. src/hooks/integrity.rs legacy script integrity checks
- Type: legacy compatibility behavior
- Decision: KEEP for now; narrow scope to migration compatibility and mark as legacy path.
- Reason: avoids breaking users transitioning from old shell artifacts.

6. .claude/hooks/*
- Type: local development helper scripts
- Decision: ARCHIVE
- Reason: not part of official Windows-only runtime path.

## Migration Safety Notes

- Do not remove legacy `rtk-rewrite.sh` migration logic from `rtk init --copilot` until native idempotency tests remain green.
- Preserve backward-compatible detection of legacy artifacts while removing active shell execution paths.
