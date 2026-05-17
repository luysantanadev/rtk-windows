## 1. OpenCode Lifecycle Contract Alignment

- [x] 1.1 Audit `rtk init` OpenCode paths in `src/hooks/init.rs` against the new lifecycle requirements and list behavior gaps.
- [x] 1.2 Align install/update/remove flows to be idempotent and deterministic for `~/.config/opencode/plugins/rtk.ts`.
- [x] 1.3 Ensure OpenCode constraints are enforced consistently (`--global` required, `--opencode` + `--codex` conflict).
- [x] 1.4 Align `rtk init --show` (or equivalent) OpenCode status output with spec-required installed/missing states.

Audit findings addressed:
- OpenCode uninstall test did not exercise production helper path (fixed with `remove_opencode_plugin_at` + assertions).
- Constraints existed but lacked explicit tests for `--opencode` without `-g` and `--codex` conflict.
- OpenCode docs had inconsistent command examples (`--global` vs `-g`) and missing explicit global-only troubleshooting note.

## 2. Rewrite Behavior Parity for OpenCode

- [x] 2.1 Review `hooks/opencode/rtk.ts` rewrite behavior against command-rewrite-registry requirements.
- [x] 2.2 Implement or adjust OpenCode rewrite logic so registry-covered command families receive equivalent `rtk` rewriting.
- [x] 2.3 Verify compound command and passthrough semantics remain consistent for OpenCode command input.

## 3. Tests and Regression Safety

- [x] 3.1 Add/update unit tests in hook lifecycle modules for OpenCode install, idempotent re-run, uninstall, and constraint validation.
- [x] 3.2 Add/update tests for OpenCode rewrite parity and unsupported-command passthrough behavior.
- [x] 3.3 Run quality gates (`cargo fmt --all`, `cargo clippy --all-targets`, `cargo test --all`) and fix regressions.

## 4. Documentation and UX Consistency

- [x] 4.1 Update OpenCode integration docs (`hooks/opencode/README.md`, `hooks/README.md`, relevant guide pages) to match implemented behavior.
- [x] 4.2 Align troubleshooting guidance with status output and global-only constraint messaging.
- [x] 4.3 Validate command examples for OpenCode (`rtk init -g --opencode`) and remove contradictory instructions.
