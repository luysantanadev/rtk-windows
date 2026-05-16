## ADDED Requirements

### Requirement: Windows-only documentation baseline
Primary documentation MUST state that this fork is Windows-only and uses PowerShell/Windows operational examples.

#### Scenario: User reads README and guides
- **WHEN** a user follows installation or usage instructions in this fork
- **THEN** the guidance SHALL prioritize Windows-native commands and SHALL not present Linux/macOS as actively supported platforms here

### Requirement: Fork vs upstream differentiation
Documentation SHALL include a dedicated section that explains differences between this fork and upstream `rtk-ai/rtk`.

#### Scenario: Linux/macOS user discovers fork docs
- **WHEN** a Linux/macOS user checks support status in this fork
- **THEN** docs SHALL direct the user to upstream for official Linux/macOS support

### Requirement: Breaking release communication
The Windows-only transition release MUST publish explicit breaking-change notes and migration guidance.

#### Scenario: Release publication
- **WHEN** maintainers publish the Windows-only release
- **THEN** `CHANGELOG.md` SHALL include breaking compatibility impact, version decision, and migration notes
