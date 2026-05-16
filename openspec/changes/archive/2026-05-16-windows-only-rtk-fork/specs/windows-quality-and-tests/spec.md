## ADDED Requirements

### Requirement: Windows-only test strategy
The repository MUST align its active automated tests with the Windows-only support contract.

#### Scenario: Test suite scope
- **WHEN** maintainers run the official quality gate for this fork
- **THEN** Windows-focused tests SHALL be included and Unix-only tests without Windows value SHALL be removed or replaced

### Requirement: Mandatory edge-case coverage
The test suite SHALL cover critical rewrite/execution edge cases previously identified for Windows behavior.

#### Scenario: Edge-case regression verification
- **WHEN** hook/runtime tests execute in CI or local quality gate
- **THEN** tests MUST validate quoting, env-prefix, pipes, redirects, heredoc passthrough, large outputs, stderr-only output, no-stdout behavior, and high exit codes

### Requirement: Windows smoke validation
The repository SHALL provide Windows smoke validation for `rtk init --copilot` and related local flows.

#### Scenario: Local smoke run on Windows
- **WHEN** a maintainer executes the defined Windows smoke checks
- **THEN** hook artifacts, migration behavior, and idempotency SHALL pass without manual patching
