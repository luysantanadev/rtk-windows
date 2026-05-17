## Why

OpenCode integration currently works, but behavior and documentation are not fully aligned with the same reliability, observability, and command-coverage expectations used for other first-class agents. We need a single, explicit contract to prevent drift between plugin behavior, `rtk init` lifecycle, and user-facing guidance.

## What Changes

- Define a dedicated OpenCode integration capability covering installation, update, validation, and uninstall lifecycle behavior.
- Standardize OpenCode command rewrite behavior to match registry expectations for supported command families, including compound command handling and passthrough semantics.
- Require consistent `rtk init --opencode` outcomes (messages, status checks, and global-only constraints) across default and OpenCode-only flows.
- Align OpenCode docs and troubleshooting guidance with actual runtime behavior and validation signals.
- Add/adjust tests to lock plugin installation/update behavior and OpenCode rewrite invariants.

## Capabilities

### New Capabilities
- `opencode-integration-lifecycle`: Defines normative requirements for OpenCode plugin installation, update, removal, verification, and user guidance.

### Modified Capabilities
- `command-rewrite-registry`: Clarifies/extends rewrite guarantees for OpenCode integration so command coverage and compound rewrite behavior remain consistent with registry rules.

## Impact

- Affected code: `src/hooks/init.rs`, `src/hooks/hook_check.rs`, `hooks/opencode/rtk.ts`, and OpenCode-related command routing in `src/main.rs`.
- Affected docs: `hooks/opencode/README.md`, `hooks/README.md`, and user docs that describe OpenCode support and troubleshooting.
- Affected tests: hook init/install/uninstall tests and OpenCode rewrite behavior tests.
- No external service dependencies introduced; changes stay within existing RTK/OpenSpec architecture.
