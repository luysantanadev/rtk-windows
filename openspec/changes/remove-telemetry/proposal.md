## Why

This project currently includes telemetry features and related documentation, which conflicts with the product direction of collecting no user information. This change is needed now to enforce a strict no-telemetry posture across behavior, code, and docs.

## What Changes

- Remove telemetry collection, storage, and reporting paths from the CLI behavior.
- Remove telemetry-related configuration flags, environment variables, and docs guidance for telemetry setup.
- Update user-facing and maintainer-facing documentation to state that the project does not collect usage data.
- Remove references to telemetry artifacts and workflows from release/process docs where applicable.
- **BREAKING**: Any telemetry command/output/setting currently available will no longer exist.

## Capabilities

### New Capabilities
- `no-telemetry`: Defines mandatory behavior that no user usage data is collected, transmitted, or documented as a supported feature.

### Modified Capabilities
- None.

## Impact

- Affected code: telemetry and analytics integration points under src/core and src/analytics, related command wiring in src/main.rs, and any telemetry references in scripts/docs.
- Affected docs: README files, TELEMETRY docs, usage guides, and contributor/maintainer references that mention telemetry.
- Affected process: release and support messaging must no longer imply collection or telemetry opt-in/out behavior.
