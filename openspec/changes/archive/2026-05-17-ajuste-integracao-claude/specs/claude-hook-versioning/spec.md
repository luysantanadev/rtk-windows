## ADDED Requirements

### Requirement: Binary hook version tracking
The system SHALL store and verify a version number for the binary `rtk hook claude` hook registration in settings.json.

#### Scenario: Hook version stored in settings.json
- **WHEN** `rtk init` registers the Claude hook
- **THEN** the PreToolUse hook entry includes `"rtk_hook_version": 4`

#### Scenario: Hook version read during status check
- **WHEN** `rtk init --show` or hook status check runs
- **THEN** the system reads `rtk_hook_version` from the hook entry and reports it

### Requirement: Outdated hook detection for binary hooks
The system SHALL detect when the registered binary hook version is older than the current version and warn the user.

#### Scenario: Outdated binary hook warning
- **WHEN** the registered `rtk_hook_version` is less than the current version
- **THEN** the system displays a warning suggesting `rtk init --uninstall && rtk init` to update

#### Scenario: Current binary hook no warning
- **WHEN** the registered `rtk_hook_version` equals the current version
- **THEN** no version warning is displayed
