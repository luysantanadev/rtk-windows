## MODIFIED Requirements

### Requirement: PowerShell Core-first command documentation
All user-facing documentation SHALL present PowerShell Core command examples as the default execution model for this fork, and SHALL avoid Bash-first command guidance in maintained materials.

#### Scenario: Command snippet in root documentation
- **WHEN** a command example is published in README, INSTALL, or guide documents
- **THEN** the default snippet uses PowerShell Core syntax
- **AND** platform assumptions are stated as Windows-first

#### Scenario: Legacy shell snippet detected
- **WHEN** a Linux/macOS shell example is encountered in maintained documentation
- **THEN** it is replaced by an equivalent PowerShell Core command
- **AND** retained references, if any, are clearly marked as non-default historical context

#### Scenario: Maintained workflow command guidance
- **WHEN** maintained workflow documentation describes repository automation commands
- **THEN** command examples use PowerShell Core invocations
- **AND** Bash command variants are not presented as supported defaults