# Coding Conventions

## Core Sections (Required)

### 1) Naming Rules

| Item | Rule | Example | Evidence |
|------|------|---------|----------|
| Files | Rust files generally use snake_case; command wrappers often use *_cmd.rs | src/core/toml_filter.rs, src/cmds/git/glab_cmd.rs | docs/codebase/.codebase-scan.txt |
| Functions/methods | snake_case naming for functions | run_cli, run_filtered, classify_command | src/main.rs, src/core/runner.rs, src/discover/registry.rs |
| Types/interfaces | PascalCase for enums/structs | Cli, Commands, RunOptions, Classification | src/main.rs, src/core/runner.rs, src/discover/registry.rs |
| Constants/env vars | SHOUTY_SNAKE_CASE for constants and env var names | HISTORY_DB, RTK_NO_TOML | src/core/constants.rs, src/main.rs |

### 2) Formatting and Linting

- Formatter: rustfmt via cargo fmt.
- Linter: clippy + rust compiler lints.
- Most relevant enforced rules:
  - unsafe_code = deny
  - warnings = deny
  - CI includes clippy gate and explicit security lint checks for unwrap/panic/expect patterns.
- Run commands:
  - cargo fmt --all --check
  - cargo clippy --all-targets
  - cargo test --all

### 3) Import and Module Conventions

- Import grouping/order: src/main.rs re-exports/uses modules grouped by ecosystem.
- Alias vs relative import policy: crate:: paths and module-relative imports are used; no Rust path alias mapping found.
- Public exports/barrel policy: top-level mod declarations in src/main.rs and module-specific README boundaries document ownership.

### 4) Error and Logging Conventions

- Error strategy by layer:
  - Application code uses anyhow::Result and context-rich propagation.
  - Runner utilities return exit codes and avoid suppressing subprocess failures.
  - Hook scripts default to non-blocking behavior on errors (pass-through).
- Logging style and required context fields:
  - Primarily stderr informational/warning output (eprintln! in Rust and shell echo to stderr in hooks).
  - [TODO] No centralized structured logging schema found for all modules.
- Sensitive-data redaction rules:
  - [TODO] Repository-wide redaction policy is not centralized in one config file.

### 5) Testing Conventions

- Test file naming/location rule: tests are typically inline in module files using #[cfg(test)], with fixtures in tests/fixtures.
- Mocking strategy norm: fixture-based input simulation (real command output fixtures).
- Coverage expectation: docs require tests for each change and >=60% token-savings assertions for filters; numeric global coverage threshold is [TODO].

### 6) Evidence

- Cargo.toml
- .github/workflows/ci.yml
- CONTRIBUTING.md
- docs/contributing/CODING_PRACTICES.md
- src/main.rs
- src/core/runner.rs
- src/discover/registry.rs
- src/core/constants.rs
