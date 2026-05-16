# External Integrations

## Core Sections (Required)

### 1) Integration Inventory

| System | Type (API/DB/Queue/etc) | Purpose | Auth model | Criticality | Evidence |
|--------|---------------------------|---------|------------|-------------|----------|
| Local SQLite DB | Local DB | Persist command history and token savings analytics | Local filesystem access | High | src/core/tracking.rs, src/core/constants.rs |
| Telemetry endpoint | HTTPS API | Optional anonymous usage ping and erasure requests | Optional compile-time token header + HTTPS | Medium | src/core/telemetry.rs, src/core/telemetry_cmd.rs, docs/TELEMETRY.md |
| External CLI tools (git/cargo/gh/glab/docker/kubectl/etc.) | Subprocess integrations | Execute user commands through RTK wrappers | Host machine tool auth/context | High | src/main.rs, src/cmds/README.md |
| LLM agent hook APIs (Claude/Copilot/Cursor/OpenCode/Hermes/etc.) | Hook/plugin integration | Rewrite raw commands to RTK equivalents | Agent-specific hook/plugin mechanism | High | hooks/README.md, hooks/claude/rtk-rewrite.sh |

### 2) Data Stores

| Store | Role | Access layer | Key risk | Evidence |
|-------|------|--------------|----------|----------|
| history.db (SQLite) | Tracking and analytics source of truth | src/core/tracking.rs + analytics modules | Corruption/locking or path confusion in docs | src/core/constants.rs, src/core/tracking.rs |
| trusted_filters.json | Persisted trust state for project TOML filters | Hook trust subsystem + TOML filter load path | Stale trust state if files change unexpectedly | src/core/constants.rs, src/core/toml_filter.rs |

### 3) Secrets and Credentials Handling

- Credential sources:
  - Compile-time telemetry variables: RTK_TELEMETRY_URL, RTK_TELEMETRY_TOKEN.
  - Runtime env toggles and user config in config.toml.
  - External tool credentials are handled by those external tools, not stored by RTK core.
- Hardcoding checks:
  - Security scanning configured in CI (semgrep + cargo-audit + pattern checks).
- Rotation/lifecycle notes:
  - [TODO] Rotation policy for telemetry token is not defined in repository runtime code.

### 4) Reliability and Failure Behavior

- Retry/backoff behavior:
  - Telemetry is fire-and-forget with timeout; no retry queue by design.
- Timeout policy:
  - Telemetry HTTP send uses explicit timeouts (2s and 5s paths).
- Circuit-breaker/fallback behavior:
  - Hooks and filters are designed to pass through when rewrite/filter fails.

### 5) Observability for Integrations

- Logging around external calls:
  - stderr warnings in hook scripts and Rust command paths.
- Metrics/tracing coverage:
  - Token tracking metrics persisted in SQLite and surfaced via gain/session commands.
- Missing visibility gaps:
  - [TODO] No unified tracing/event correlation ID strategy found for subprocess + hook + telemetry flows.

### 6) Evidence

- src/core/tracking.rs
- src/core/constants.rs
- src/core/telemetry.rs
- src/core/telemetry_cmd.rs
- src/main.rs
- src/cmds/README.md
- hooks/README.md
- hooks/claude/rtk-rewrite.sh
- .github/workflows/ci.yml
- .semgrep.yml
