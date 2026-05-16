## ADDED Requirements

### Requirement: Copilot Windows-native hook baseline
The fork MUST keep `rtk hook copilot` as the canonical hook mechanism for Copilot on Windows.

#### Scenario: Copilot hook installation path
- **WHEN** `rtk init --copilot` is executed in a project
- **THEN** the system SHALL install/update `.github/hooks/rtk-rewrite.json` and `.github/copilot-instructions.md` using Windows-compatible behavior

### Requirement: Legacy hook migration and idempotency
`rtk init --copilot` SHALL migrate legacy `rtk-rewrite.sh` hook artifacts and MUST remain idempotent across repeated runs.

#### Scenario: Legacy artifact present
- **WHEN** `.github/hooks/rtk-rewrite.sh` exists before init
- **THEN** the command SHALL remove/migrate the legacy artifact and SHALL keep the Rust-native hook configuration active

#### Scenario: Repeated initialization
- **WHEN** `rtk init --copilot` is run multiple times in the same workspace
- **THEN** artifacts SHALL converge to a single stable configuration with no duplicate entries

### Requirement: Shell-only Unix hook paths cleanup
Hook implementations dedicated only to Unix shell flows SHALL be removed or archived when not part of the Windows-only contract.

#### Scenario: Hook inventory review
- **WHEN** maintainers audit hook integrations in this fork
- **THEN** shell-only Unix paths not needed for Windows operation SHALL be either removed or explicitly archived with migration notes
