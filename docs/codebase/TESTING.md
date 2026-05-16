# Testing Patterns

## Core Sections (Required)

### 1) Test Stack and Commands

- Primary test framework: Rust built-in test harness (cargo test).
- Assertion/mocking tools:
  - Standard assert!/assert_eq! in module tests.
  - Fixture-driven tests via include_str! from tests/fixtures.
  - [TODO] Snapshot tooling is documented as insta in CONTRIBUTING docs, but current source search did not find assert_snapshot!/insta usage in src/*.rs.
- Commands:

```bash
cargo test --all
cargo test <module_or_test_name>
cargo test --ignored
bash scripts/test-all.sh
```

### 2) Test Layout

- Test file placement pattern:
  - Most tests are inline inside source modules under #[cfg(test)].
  - Fixture files live in tests/fixtures/ (including ecosystem subfolders).
  - Additional smoke/integration scripts exist under scripts/ and hooks/*/test-*.sh.
- Naming convention:
  - Rust test names use snake_case with test_ prefix.
  - Fixture names end with _raw and format extension (example: glab_issue_list_raw.json).
- Setup files and where they run:
  - CI runs fmt, clippy, tests, semgrep, cargo-audit, benchmark jobs.

### 3) Test Scope Matrix

| Scope | Covered? | Typical target | Notes |
|-------|----------|----------------|-------|
| Unit | yes | Command filter formatting/parsing and helper logic | Inline #[cfg(test)] modules across src/cmds and core |
| Integration | partial | Runtime command behavior and installed binary flows | Documented via cargo test --ignored and shell scripts |
| E2E | partial | Hook-level rewrite behavior per agent | Shell/Python hook tests under hooks/*/tests and scripts |

### 4) Mocking and Isolation Strategy

- Main mocking approach: deterministic fixture files captured from real command outputs.
- Isolation guarantees: tests mostly operate on in-memory strings/fixtures and local process execution.
- Common failure mode in tests:
  - Environment/tool availability differences (for smoke scripts that rely on installed binaries and external CLIs).

### 5) Coverage and Quality Signals

- Coverage tool + threshold: [TODO] No repository-level coverage tool or threshold config found.
- Current reported coverage: [TODO] Not published in scanned CI outputs/files.
- Known gaps/flaky areas:
  - Some smoke tests intentionally tolerate non-zero outputs (example: cargo test in scripts/test-all.sh) due pre-existing failures in target commands.
  - Snapshot testing is documented, but direct code evidence in src/ for insta usage was not found in this pass.

### 6) Evidence

- CONTRIBUTING.md
- docs/contributing/TECHNICAL.md
- scripts/test-all.sh
- scripts/check-test-presence.sh
- .github/workflows/ci.yml
- src/cmds/go/golangci_cmd.rs
- src/cmds/git/glab_cmd.rs
- src/cmds/jvm/gradlew_cmd.rs
- tests/fixtures/
