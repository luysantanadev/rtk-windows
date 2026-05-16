## MODIFIED Requirements

### Requirement: Binary hook integrity verification
The system SHALL verify the integrity of the Claude hook registration by checking that `rtk hook claude` is registered in settings.json with the correct version, replacing the legacy SHA-256 script hash check.

#### Scenario: Binary hook registered correctly
- **WHEN** `integrity::runtime_check()` runs for an operational command
- **THEN** it verifies `rtk hook claude` is present in settings.json with the current version
- **AND** no warning is displayed

#### Scenario: Binary hook not registered
- **WHEN** `integrity::runtime_check()` runs and `rtk hook claude` is not in settings.json
- **THEN** it displays a warning suggesting `rtk init` to register the hook

#### Scenario: Legacy script integrity skipped
- **WHEN** `integrity::runtime_check()` runs and the legacy `rtk-rewrite.sh` does not exist
- **THEN** it skips the legacy SHA-256 hash check without error
