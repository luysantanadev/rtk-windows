## ADDED Requirements

### Requirement: Consistent Claude artifact installation
The system SHALL install a consistent set of Claude artifacts across all init modes (default, hook-only, claude-md).

#### Scenario: Default mode installs all artifacts
- **WHEN** `rtk init` runs in default mode (global)
- **THEN** it installs: settings.json hook, RTK.md, CLAUDE.md reference, and filters template

#### Scenario: Hook-only mode installs only hook
- **WHEN** `rtk init --hook-only --global` runs
- **THEN** it installs only the settings.json hook without RTK.md or CLAUDE.md changes

### Requirement: Consistent Claude artifact uninstallation
The system SHALL remove all Claude artifacts during uninstall, including legacy script migration cleanup.

#### Scenario: Uninstall removes all artifacts
- **WHEN** `rtk init --uninstall --global` runs
- **THEN** it removes: settings.json hook entry, RTK.md, CLAUDE.md reference, legacy script, and integrity hash

#### Scenario: Uninstall preserves user content
- **WHEN** `rtk init --uninstall --global` runs
- **THEN** it preserves non-RTK content in CLAUDE.md and settings.json

### Requirement: Legacy hook migration
The system SHALL automatically migrate from the legacy `rtk-rewrite.sh` script to the binary `rtk hook claude` hook during `rtk init`.

#### Scenario: Legacy script detected and migrated
- **WHEN** `rtk init` finds `~/.claude/hooks/rtk-rewrite.sh`
- **THEN** it removes the script, cleans old settings.json entries, and registers the binary hook
