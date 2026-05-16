### Requirement: PowerShell Core is the canonical automation runtime
The repository SHALL define PowerShell Core (`pwsh`) as the canonical runtime for maintained automation scripts and command execution guidance.

#### Scenario: Maintained automation script exists
- **WHEN** a repository-maintained automation script is added or updated
- **THEN** the script is implemented as a PowerShell Core script
- **AND** execution instructions use `pwsh` as the default runtime

### Requirement: Bash-maintained automation is removed or replaced
Maintained Bash automation paths SHALL be removed or replaced with functionally equivalent PowerShell Core implementations.

#### Scenario: Existing Bash script is discovered
- **WHEN** a maintained `.sh` script has an equivalent repository automation purpose
- **THEN** it is replaced by a PowerShell Core implementation with equivalent outcome
- **AND** references to the old Bash script in maintained docs are updated

### Requirement: Runtime prerequisite is explicitly documented
Contributor-facing setup and usage documentation SHALL state that PowerShell Core is required for maintained automation workflows.

#### Scenario: Setup guidance is published
- **WHEN** installation or contributor setup documentation references script execution
- **THEN** it states the `pwsh` prerequisite
- **AND** provides PowerShell Core execution examples
