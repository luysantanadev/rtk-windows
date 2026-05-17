## ADDED Requirements

### Requirement: Explicit Windows-only platform scope
RTK-Windows SHALL be documented and positioned as a Windows/PowerShell Core-only tool with no cross-platform support.

#### Scenario: README clearly states Windows-only scope
- **WHEN** a user reads README.md
- **THEN** it includes a prominent "Platform Requirements: Windows 10/11, PowerShell Core (pwsh)" section near the top
- **AND** all cross-platform references are removed

#### Scenario: Installation guide shows Windows-only methods
- **WHEN** a user views INSTALL.md
- **THEN** it documents only Windows installation methods: `cargo install` and direct binary download from releases
- **AND** no references to brew, apt, curl, or Unix package managers exist

#### Scenario: Documentation examples use PowerShell syntax
- **WHEN** a user reads any guide or troubleshooting document
- **THEN** all code examples show PowerShell Core (pwsh) syntax using backticks and $PROFILE patterns
- **AND** no bash, sh, zsh, or Unix shell examples are present

#### Scenario: Supported agents are Windows-compatible only
- **WHEN** RTK documentation lists supported agents
- **THEN** it includes only: Copilot, Cursor, Cline, OpenCode, Hermes
- **AND** removes all references to non-Windows agents

### Requirement: Platform scope communicated in all user-facing content
RTK SHALL remove all Linux/bash/macOS references from guides, README, CLAUDE.md, and documentation.

#### Scenario: No Linux installation references
- **WHEN** searching for "Linux", "ubuntu", "apt", "brew", "macOS", or "zsh" in user-facing documentation
- **THEN** no results are found
- **AND** if historical references exist, they are archived

#### Scenario: No bash/sh/zsh shell references in examples
- **WHEN** viewing any example command or troubleshooting step
- **THEN** no shell syntax references ~/.bashrc, ~/.zshrc, or Unix pipes with `|` are present
- **AND** all examples use PowerShell Core syntax with proper escaping

#### Scenario: Troubleshooting guide is Windows-only
- **WHEN** a user reads docs/guide/resources/troubleshooting.md
- **THEN** all scenarios are Windows-specific (PowerShell errors, PATH configuration in Windows, registry paths, etc.)
- **AND** no macOS or Linux troubleshooting sections exist
