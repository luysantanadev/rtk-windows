## Purpose
Define fork identity requirements for binary naming and version-lineage communication.
## Requirements
### Requirement: Fork binary identity
The fork SHALL identify its distributed executable, Copilot-generated command guidance, and release-facing binary references as `rtk-windows`.

#### Scenario: Release artifact naming
- **WHEN** a release artifact is generated or documented
- **THEN** the binary name in archive contents and references is `rtk-windows.exe`
- **AND** release notes reference `rtk-windows` as the canonical binary identity

#### Scenario: Installation and usage guidance
- **WHEN** installation or usage documentation references the binary
- **THEN** command examples and text use `rtk-windows`
- **AND** legacy `rtk` references are either removed or explicitly marked as historical/upstream context

#### Scenario: Copilot instruction output
- **WHEN** Copilot-facing instruction files or templates generate command examples for the project
- **THEN** the generated guidance uses `rtk-windows` for executable invocations
- **AND** the output does not present `rtk` as the default binary name

### Requirement: Fork version baseline communication
The fork SHALL document and communicate a reset version baseline independent from upstream lineage.

#### Scenario: Version baseline declaration
- **WHEN** version policy is described in docs or release notes
- **THEN** the baseline reset point is explicitly stated
- **AND** the current fork version is identified as authoritative for future releases

#### Scenario: Local install version verification
- **WHEN** users run version verification after local install
- **THEN** documentation explains expected fork version output semantics
- **AND** avoids implying upstream semantic continuity

