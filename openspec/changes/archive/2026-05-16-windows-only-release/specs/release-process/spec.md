## ADDED Requirements

### Requirement: Release trigger on develop branch
The release process SHALL monitor the develop branch and automatically create pre-release artifacts when code is pushed.

#### Scenario: Developer pushes to develop
- **WHEN** a commit is pushed to develop branch
- **THEN** cd.yml pre-release job triggers automatically
- **AND** conventional commits are analyzed to compute version bump

#### Scenario: Pre-release version computed
- **WHEN** commits are analyzed since last stable tag
- **THEN** the pre-release version is computed based on conventional commits (feat/fix/breaking)
- **AND** tag format is `dev-X.Y.Z-rc.{run_id}`

### Requirement: Release trigger on master branch
The release process SHALL monitor the master branch and use release-please action to determine if a stable release is needed.

#### Scenario: Developer pushes to master
- **WHEN** a commit is pushed to master branch
- **THEN** cd.yml release-please job analyzes conventional commits
- **AND** if a release is needed, release-please creates a GitHub Release

#### Scenario: Release-please computes stable version
- **WHEN** release-please action runs
- **THEN** it analyzes commits since last release tag
- **AND** generates a stable tag in format `vX.Y.Z`

### Requirement: Windows-only build execution
The release process SHALL build RTK exclusively for Windows x86_64-msvc target.

#### Scenario: Pre-release Windows build
- **WHEN** pre-release tag is created (dev-X.Y.Z-rc.N)
- **THEN** release.yml is called with prerelease=true
- **AND** only Windows target is built (no macOS or Linux)
- **AND** artifacts are marked as pre-release on GitHub

#### Scenario: Stable release Windows build
- **WHEN** stable tag is created (vX.Y.Z)
- **THEN** release.yml is called with prerelease=false
- **AND** only Windows target is built (no macOS or Linux)
- **AND** artifacts are marked as stable release on GitHub

### Requirement: GitHub Release creation
The release process SHALL create GitHub Release entries for both pre-release and stable builds.

#### Scenario: Pre-release on GitHub
- **WHEN** pre-release Windows build completes successfully
- **THEN** a GitHub Release is created with pre-release badge
- **AND** release notes are auto-generated from commit messages
- **AND** rtk-x86_64-pc-windows-msvc.zip artifact is attached

#### Scenario: Stable release on GitHub
- **WHEN** stable Windows build completes successfully
- **THEN** a GitHub Release is created as stable (not pre-release)
- **AND** release notes include changelog from release-please
- **AND** rtk-x86_64-pc-windows-msvc.zip artifact is attached
- **AND** latest tag is updated to point to this release

### Requirement: No DEB/RPM/macOS/Linux artifacts
The release process SHALL NOT generate distribution packages for non-Windows platforms.

#### Scenario: Package managers skipped
- **WHEN** release.yml runs for Windows-only build
- **THEN** build-deb job is not executed
- **AND** build-rpm job is not executed
- **AND** no Linux package manager updates occur

#### Scenario: Multi-platform CI skipped
- **WHEN** release.yml completes
- **THEN** no artifacts for macOS x86_64, macOS ARM, Linux musl, or Linux aarch64 are generated
