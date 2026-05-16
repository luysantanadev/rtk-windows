# Codebase Structure

## Core Sections (Required)

### 1) Top-Level Map

| Path | Purpose | Evidence |
|------|---------|----------|
| src/ | Main Rust implementation (CLI entry, command filters, core, hooks, analytics) | src/main.rs, docs/codebase/.codebase-scan.txt |
| src/cmds/ | Command execution/filter modules organized by ecosystem | src/cmds/README.md |
| src/core/ | Shared infrastructure (config, tracking, toml filter engine, stream/runner helpers) | src/core/config.rs, src/core/tracking.rs, src/core/toml_filter.rs |
| src/discover/ | Rewrite registry and command classification for hook interception | src/discover/registry.rs, src/discover/rules.rs |
| src/hooks/ | Hook install/runtime logic in Rust | src/main.rs, src/hooks/rewrite_cmd.rs |
| hooks/ | Agent-specific deployed hook artifacts and plugins | hooks/README.md |
| tests/fixtures/ | Real command output fixtures used by module tests | docs/contributing/TECHNICAL.md, tests/fixtures/* |
| scripts/ | Utility scripts for smoke tests, benchmarks, installation checks | scripts/test-all.ps1, scripts/benchmark.ps1 |
| docs/ | User/contributor documentation and architecture guides | docs/contributing/TECHNICAL.md, docs/contributing/ARCHITECTURE.md |
| .github/workflows/ | CI/CD pipelines and security/test gates | .github/workflows/ci.yml |

### 2) Entry Points

- Main runtime entry: src/main.rs
- Secondary entry points:
  - build.rs (build-time TOML filter embedding)
  - openclaw/index.ts (OpenClaw plugin package entry)
  - hooks/opencode/rtk.ts and hooks/hermes/rtk-rewrite/__init__.py (agent plugin entries)
- How entry is selected:
  - Cargo binary routing via clap subcommands in src/main.rs.
  - Plugin entrypoints selected by host agent/plugin metadata files.

### 3) Module Boundaries

| Boundary | What belongs here | What must not be here |
|----------|-------------------|------------------------|
| src/cmds/ | External command execution and output filtering per ecosystem | TOML registry internals, hook installation logic |
| src/core/ | Cross-cutting infra shared by command modules | Command-specific formatting/parsing logic |
| src/discover/ | Rewrite rules, lexer/tokenization, classification/reporting | Executing external command filters |
| src/hooks/ | Hook setup/check/permissions/integrity | Per-agent deployed artifact contents |
| hooks/ | Deployed integration artifacts for agents | Core Rust routing/filter logic |

### 4) Naming and Organization Rules

- File naming pattern:
  - Rust modules are mostly snake_case (example: src/core/toml_filter.rs).
  - Many command modules use *_cmd.rs suffix (example: src/cmds/git/glab_cmd.rs).
  - TOML filters use kebab-case command-style names (example: src/filters/terraform-plan.toml documented in src/filters/README.md).
- Directory organization pattern: Domain/ecosystem-first (git, js, python, go, dotnet, cloud, system, ruby).
- Import/path conventions: Relative crate module usage via mod declarations and use statements in src/main.rs; no workspace alias system found for Rust modules.

### 5) Evidence

- src/main.rs
- src/cmds/README.md
- src/core/config.rs
- src/core/toml_filter.rs
- src/discover/registry.rs
- hooks/README.md
- build.rs
- docs/codebase/.codebase-scan.txt
