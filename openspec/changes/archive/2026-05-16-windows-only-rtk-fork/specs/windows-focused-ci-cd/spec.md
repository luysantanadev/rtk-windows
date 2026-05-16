## ADDED Requirements

### Requirement: Windows-focused CI execution
The fork CI MUST run official validation on `windows-latest` as the primary execution environment.

#### Scenario: CI workflow run
- **WHEN** pull requests or mainline builds are triggered
- **THEN** the pipeline SHALL execute build, lint, and tests on `windows-latest`

### Requirement: PowerShell-first validation scripts
Validation and helper scripts used by CI SHALL be PowerShell-compatible and maintained as the default path for this fork.

#### Scenario: CI script invocation
- **WHEN** CI invokes project validation scripts
- **THEN** PowerShell entrypoints SHALL be available and SHALL complete the quality gate workflow

### Requirement: Removal of Linux/macOS CI jobs
Linux/macOS-specific CI jobs SHALL be removed from this fork's official pipeline definition.

#### Scenario: Pipeline definition review
- **WHEN** maintainers inspect the active workflow configuration
- **THEN** only Windows-supported jobs SHALL remain mandatory for merge and release gates
