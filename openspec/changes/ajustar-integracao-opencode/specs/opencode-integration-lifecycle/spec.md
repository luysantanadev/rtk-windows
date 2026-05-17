## ADDED Requirements

### Requirement: OpenCode plugin lifecycle is idempotent and deterministic
The system SHALL install, update, and remove the OpenCode plugin deterministically through `rtk init` flows, with idempotent behavior across repeated executions.

#### Scenario: OpenCode plugin is installed in OpenCode-only mode
- **WHEN** the user runs `rtk init -g --opencode`
- **THEN** the system writes `~/.config/opencode/plugins/rtk.ts` if missing or outdated
- **AND** the output indicates OpenCode plugin installation and restart guidance

#### Scenario: Re-running installation does not duplicate artifacts
- **WHEN** the user runs `rtk init -g --opencode` multiple times with unchanged embedded plugin content
- **THEN** the system leaves the installed plugin unchanged
- **AND** no duplicate OpenCode artifacts are created

#### Scenario: Uninstall removes OpenCode plugin artifact
- **WHEN** the user runs `rtk init --uninstall --global`
- **THEN** the system removes `~/.config/opencode/plugins/rtk.ts` when present
- **AND** reports OpenCode plugin removal in uninstall feedback

### Requirement: OpenCode installation constraints are enforced
The system SHALL enforce OpenCode integration constraints consistently across `rtk init` entry modes.

#### Scenario: OpenCode requires global mode
- **WHEN** the user runs `rtk init --opencode` without `--global`
- **THEN** the command fails with guidance that OpenCode plugin installation is global-only

#### Scenario: OpenCode and Codex mode conflict is rejected
- **WHEN** the user runs `rtk init` with both `--opencode` and `--codex`
- **THEN** the command fails fast with a clear incompatibility message

### Requirement: OpenCode integration is visible in verification output
The system SHALL expose OpenCode plugin presence in verification/status outputs so users can validate integration health.

#### Scenario: Verification reports installed OpenCode plugin
- **WHEN** OpenCode plugin file exists at the expected path
- **THEN** `rtk init --show` (or equivalent status output) indicates OpenCode plugin installed

#### Scenario: Verification reports missing OpenCode plugin
- **WHEN** OpenCode plugin file does not exist
- **THEN** status output indicates OpenCode plugin not found (or config dir not found)
