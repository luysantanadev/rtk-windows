# External Integrations

## Core Sections (Required)

### 1) Integration Inventory

| System | Type (API/DB/Queue/etc) | Purpose | Auth model | Criticality | Evidence |
|--------|---------------------------|---------|------------|-------------|----------|
| Local SQLite DB | Local DB | Persist command history and token savings analytics | Local filesystem access | High | src/core/tracking.rs, src/core/constants.rs |
| External CLI tools (git/cargo/gh/glab/docker/kubectl/etc.) | Subprocess integrations | Execute user commands through RTK wrappers | Host machine tool auth/context | High | src/main.rs, src/cmds/README.md |
| LLM agent hook APIs (Claude/Copilot/Cursor/OpenCode/Hermes/etc.) | Hook/plugin integration | Rewrite raw commands to RTK equivalents | Agent-specific hook/plugin mechanism | High | hooks/README.md, hooks/claude/rtk-rewrite.sh |

### 2) Data Stores

| Store | Role | Access layer | Key risk | Evidence |
|-------|------|--------------|----------|----------|
| history.db (SQLite) | Tracking and analytics source of truth | src/core/tracking.rs + analytics modules | Corruption/locking or path confusion in docs | src/core/constants.rs, src/core/tracking.rs |
| trusted_filters.json | Persisted trust state for project TOML filters | Hook trust subsystem + TOML filter load path | Stale trust state if files change unexpectedly | src/core/constants.rs, src/core/toml_filter.rs |

### 3) Secrets and Credentials Handling

- Credential sources:
  - Runtime env toggles and user config in config.toml.
  - External tool credentials are handled by those external tools, not stored by RTK core.
- Hardcoding checks:
  - Security scanning configured in CI (semgrep + cargo-audit + pattern checks).

### 4) Reliability and Failure Behavior

- Retry/backoff behavior:
  - None; commands pass through directly.
- Timeout policy:
  - Subprocess execution inherits system defaults.
- Circuit-breaker/fallback behavior:
  - Hooks and filters are designed to pass through when rewrite/filter fails.

### 5) Observability for Integrations

- Logging around external calls:
  - stderr warnings in hook scripts and Rust command paths.
- Metrics/tracing coverage:
  - Token tracking metrics persisted in SQLite and surfaced via gain/session commands.
- Missing visibility gaps:
  - [TODO] No unified tracing/event correlation ID strategy found for subprocess + hook flows.

### 6) Evidence

- src/core/tracking.rs
- src/core/constants.rs
- src/main.rs
- src/cmds/README.md
- hooks/README.md
- hooks/claude/rtk-rewrite.sh
- .github/workflows/ci.yml
- .semgrep.yml
