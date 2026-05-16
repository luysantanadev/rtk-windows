# Architecture

## Core Sections (Required)

### 1) Architectural Style

- Primary style: Command-router + modular filter pipeline (CLI proxy architecture).
- Why this classification:
  - src/main.rs defines a large clap subcommand graph and dispatches into ecosystem modules.
  - src/cmds/README.md documents per-command execution/filter modules.
  - src/core/runner.rs and src/core/stream.rs implement reusable execution/filter wrappers.
- Primary constraints:
  - Never block: filter failures should fall back to raw command behavior.
  - Preserve command exit codes.
  - Low overhead target (docs describe sub-10ms startup goal).

### 2) System Flow

```text
Agent command/hook event -> rewrite/classify -> rtk CLI parse+route -> command execution+filter -> tracking -> user/agent output
```

Evidence-backed flow steps:

1. Hook artifacts delegate rewrite decisions to rtk rewrite (hooks/README.md, hooks/claude/rtk-rewrite.sh).
2. Rewrite engine classifies commands and applies rule-based mapping (src/discover/registry.rs, src/discover/rules.rs).
3. src/main.rs parses CLI arguments with clap and routes subcommands.
4. Filter modules execute external commands and transform output (src/cmds/README.md, src/core/runner.rs).
5. Tracking records token metrics and queryable aggregates in SQLite (src/core/tracking.rs).
6. Fallback path applies TOML filters or passthrough when no Rust command match exists (src/main.rs, src/core/toml_filter.rs).

### 3) Layer/Module Responsibilities

| Layer or module | Owns | Must not own | Evidence |
|-----------------|------|--------------|----------|
| src/main.rs | CLI schema, global flags, top-level routing, fallback trigger | Command-specific parsing internals for every tool | src/main.rs |
| src/cmds/* | Tool-specific command execution and output compression | Global configuration serialization and trust policy internals | src/cmds/README.md |
| src/core/* | Shared execution, config, tracking, filter DSL engine | Tool-specific formatting rules for each ecosystem | src/core/runner.rs, src/core/config.rs, src/core/toml_filter.rs |
| src/discover/* | Rewrite rule matching, command classification, tokenization | Running command subprocess filters | src/discover/registry.rs, src/discover/rules.rs |
| src/hooks/* + hooks/* | Hook install/runtime checks (Rust) and per-agent deployed delegates | Core filter algorithms | src/hooks/rewrite_cmd.rs, hooks/README.md |

### 4) Reused Patterns

| Pattern | Where found | Why it exists |
|---------|-------------|---------------|
| Registry/rules table pattern | src/discover/rules.rs consumed by src/discover/registry.rs | Centralized rewrite mapping for many command syntaxes |
| Strategy-like filter modes | src/core/runner.rs + src/core/stream.rs (CaptureOnly/Streaming/Passthrough) | Reuse execution skeleton across heterogeneous commands |
| Fallback/passthrough safety pattern | src/core/runner.rs, src/core/toml_filter.rs, docs/contributing/TECHNICAL.md | Ensure commands still run when filtering fails or no match exists |
| Layered source precedence | src/core/toml_filter.rs (project/user/builtin filter lookup) | Allow local customization while keeping built-in defaults |

### 5) Known Architectural Risks

- Large central router/churn concentration in src/main.rs increases coupling and regression risk for command registration changes.
- High-complexity rewrite registry in src/discover/registry.rs is a critical path for all hook-based integrations.
- Documentation inconsistency exists for tracking DB filename (history.db vs tracking.db), which can mislead operators.

### 6) Evidence

- src/main.rs
- src/core/runner.rs
- src/core/toml_filter.rs
- src/core/tracking.rs
- src/discover/registry.rs
- src/discover/rules.rs
- hooks/README.md
- docs/contributing/TECHNICAL.md
- docs/codebase/.codebase-scan.txt
