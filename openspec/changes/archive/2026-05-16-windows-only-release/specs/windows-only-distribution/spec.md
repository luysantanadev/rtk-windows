## ADDED Requirements

### Requirement: Windows binary release
The release pipeline SHALL compile RTK for Windows x86_64-msvc target and publish a .zip archive containing rtk.exe to GitHub Releases.

#### Scenario: Successful Windows build
- **WHEN** release.yml build job runs for x86_64-pc-windows-msvc
- **THEN** cargo builds RTK in release mode with telemetry environment variables set
- **AND** the resulting rtk.exe is packaged into a .zip archive
- **AND** archive is uploaded as a GitHub Releases artifact

#### Scenario: Windows build fails
- **WHEN** cargo build fails on Windows target
- **THEN** the entire release.yml workflow fails and blocks publication
- **AND** no artifacts are created

### Requirement: Single-target release matrix
The release.yml workflow SHALL contain only one build target: x86_64-pc-windows-msvc on windows-latest runner.

#### Scenario: Matrix only contains Windows
- **WHEN** release.yml is executed
- **THEN** the build job matrix contains exactly one configuration entry for Windows
- **AND** no macOS or Linux targets are present

#### Scenario: No cross-compilation tools required
- **WHEN** release.yml build job runs
- **THEN** no cross-compilation tools (musl-tools, gcc-aarch64-linux-gnu, cargo-generate-rpm) are installed
- **AND** only native Windows compiler (MSVC) is used

### Requirement: Simplified artifact handling
The release pipeline SHALL skip DEB and RPM packaging and upload only Windows binary to GitHub Releases.

#### Scenario: No DEB package created
- **WHEN** release.yml completes
- **THEN** no build-deb job is executed
- **AND** no .deb file is uploaded to artifacts

#### Scenario: No RPM package created
- **WHEN** release.yml completes
- **THEN** no build-rpm job is executed
- **AND** no .rpm file is uploaded to artifacts

### Requirement: Reduced pipeline execution time
The release pipeline execution time for Windows-only builds SHALL be less than 10 minutes total.

#### Scenario: Build completes within SLA
- **WHEN** release.yml build job starts
- **THEN** the job completes within 10 minutes
- **AND** includes compilation, packaging, and artifact upload

#### Scenario: No overhead from removed jobs
- **WHEN** comparing pipeline runtime before and after this change
- **THEN** execution time is reduced by approximately 80% (from ~40 min to ~5 min)
