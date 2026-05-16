# Technology Stack

## Core Sections (Required)

### 1) Runtime Summary

| Area | Value | Evidence |
|------|-------|----------|
| Primary language | Rust | Cargo.toml |
| Runtime + version | Native Rust CLI binary, Rust edition 2021, crate version 0.34.3 | Cargo.toml |
| Package manager | Cargo | Cargo.toml |
| Module/build system | Cargo + build.rs concatenating built-in TOML filters | Cargo.toml, build.rs |

### 2) Production Frameworks and Dependencies

| Dependency | Version | Role in system | Evidence |
|------------|---------|----------------|----------|
| clap | 4 | CLI parsing and subcommand routing | Cargo.toml, src/main.rs |
| anyhow | 1.0 | Error propagation with context | Cargo.toml, src/main.rs |
| regex + lazy_static | 1 / 1.4 | Command classification and output filtering patterns | Cargo.toml, src/discover/registry.rs |
| rusqlite (bundled) | 0.31 | Local tracking/analytics storage | Cargo.toml, src/core/tracking.rs |
| serde + serde_json | 1 / 1 | Structured parsing and JSON output | Cargo.toml, src/core/tracking.rs |
| toml | 0.8 | Config and filter DSL parsing | Cargo.toml, src/core/config.rs, src/core/toml_filter.rs |
| quick-xml | 0.37 | XML parsing for .NET related command outputs | Cargo.toml |

### 3) Development Toolchain

| Tool | Purpose | Evidence |
|------|---------|----------|
| cargo fmt | Formatting check in CI and pre-commit gate | .github/workflows/ci.yml, CONTRIBUTING.md |
| cargo clippy | Linting in CI and pre-commit gate | .github/workflows/ci.yml, CONTRIBUTING.md |
| cargo test | Unit/integration test execution in CI | .github/workflows/ci.yml, CONTRIBUTING.md |
| cargo-audit | Dependency vulnerability scanning in CI | .github/workflows/ci.yml |
| semgrep | Static security pattern scanning in CI | .github/workflows/ci.yml, .semgrep.yml |

### 4) Key Commands

```bash
cargo build
cargo build --release
cargo test --all
cargo fmt --all --check && cargo clippy --all-targets && cargo test
```

### 5) Environment and Config

- Config sources: src/core/config.rs, src/core/toml_filter.rs, .rtk/filters.toml
- Required env vars:
  - RTK_NO_TOML (disable TOML filter engine)
  - RTK_TOML_DEBUG (debug TOML filter matching)
  - [TODO] Additional runtime env vars may exist in non-Rust hook/plugin scripts.
- Deployment/runtime constraints:
  - Single native binary target with release optimization and stripping enabled.
  - No monorepo workspace detected in scan output.

### 6) Evidence

- Cargo.toml
- build.rs
- src/main.rs
- src/core/config.rs
- src/core/toml_filter.rs
- .github/workflows/ci.yml
- docs/codebase/.codebase-scan.txt
