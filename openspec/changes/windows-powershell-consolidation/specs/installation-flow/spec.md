## ADDED Requirements

### Requirement: Windows-only installation flow
RTK-Windows installation SHALL support only Windows platforms via cargo or direct binary download, with no cross-platform package manager support.

#### Scenario: Cargo installation on Windows
- **WHEN** user runs `cargo install --path .` on Windows with Rust installed
- **THEN** RTK builds successfully and installs `rtk-windows` binary to Cargo bin directory
- **AND** PATH configuration uses PowerShell `$PROFILE` pattern documented

#### Scenario: Direct binary download installation
- **WHEN** user downloads rtk-windows.exe from GitHub releases
- **THEN** installation instructions show adding the directory to PATH via Windows "Edit Environment Variables" or PowerShell `$PROFILE`
- **AND** no bash or shell script-based setup is required

#### Scenario: No non-Windows installation methods
- **WHEN** viewing INSTALL.md documentation
- **THEN** it contains zero references to: homebrew, apt-get, yum, pacman, curl with bash piping, or Unix package managers
- **AND** attempts to use RTK on non-Windows systems fail with a clear error message

### Requirement: PowerShell Core configuration pattern
RTK installation and setup SHALL use PowerShell Core (`$PROFILE`) as the sole environment configuration mechanism.

#### Scenario: User adds rtk-windows to PowerShell PATH
- **WHEN** following setup documentation after installation
- **THEN** instructions show: `notepad $PROFILE` to edit PowerShell profile
- **AND** add binary directory to $env:Path
- **AND** restart PowerShell to apply changes

#### Scenario: Verification in PowerShell Core
- **WHEN** user verifies installation via `rtk-windows --version`
- **THEN** RTK responds with version and platform confirmation
- **AND** all subsequent commands require Windows/PowerShell environment

#### Scenario: Installation failure on non-Windows systems
- **WHEN** user attempts to run RTK on Linux or macOS
- **THEN** a clear error message displays: "RTK is Windows-only. Use PowerShell Core (pwsh) on Windows."
- **AND** no fallback or degraded functionality is attempted
