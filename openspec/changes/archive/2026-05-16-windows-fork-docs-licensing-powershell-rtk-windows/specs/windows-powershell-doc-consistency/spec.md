## ADDED Requirements

### Requirement: PowerShell Core-first command documentation
All user-facing documentation SHALL present PowerShell Core command examples as the default execution model for this fork.

#### Scenario: Command snippet in root documentation
- **WHEN** a command example is published in README, INSTALL, or guide documents
- **THEN** the default snippet uses PowerShell Core syntax
- **AND** platform assumptions are stated as Windows-first

#### Scenario: Legacy shell snippet detected
- **WHEN** a Linux/macOS shell example is encountered in maintained documentation
- **THEN** it is either replaced by PowerShell Core equivalent
- **AND** clearly marked as non-default if retained for reference

### Requirement: Documentation platform language consistency
Documentation language SHALL consistently identify the project as a Windows-only fork unless explicitly describing upstream or historical context.

#### Scenario: Platform support statement
- **WHEN** support scope is documented
- **THEN** it states Windows-only distribution and execution support for this fork
- **AND** avoids ambiguous multi-platform claims

#### Scenario: Cross-language README alignment
- **WHEN** localized README files are updated
- **THEN** platform support wording remains semantically consistent across locales
- **AND** command examples remain PowerShell Core-first
