## MODIFIED Requirements

### Requirement: Windows binary release
The release pipeline SHALL compile RTK for Windows x86_64-msvc target and publish a .zip archive containing `rtk-windows.exe` to GitHub Releases.

#### Scenario: Successful Windows build
- **WHEN** release.yml build job runs for x86_64-pc-windows-msvc
- **THEN** cargo builds RTK in release mode with telemetry environment variables set
- **AND** the resulting `rtk-windows.exe` is packaged into a .zip archive
- **AND** archive is uploaded as a GitHub Releases artifact

#### Scenario: Windows build fails
- **WHEN** cargo build fails on Windows target
- **THEN** the entire release.yml workflow fails and blocks publication
- **AND** no artifacts are created

### Requirement: Simplified artifact handling
The release pipeline SHALL skip DEB and RPM packaging and upload only the Windows binary archive named for `rtk-windows` to GitHub Releases.

#### Scenario: No DEB package created
- **WHEN** release.yml completes
- **THEN** no build-deb job is executed
- **AND** no .deb file is uploaded to artifacts

#### Scenario: No RPM package created
- **WHEN** release.yml completes
- **THEN** no build-rpm job is executed
- **AND** no .rpm file is uploaded to artifacts
