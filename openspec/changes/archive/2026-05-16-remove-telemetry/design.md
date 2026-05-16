## Context

The project currently includes a telemetry system (`src/core/telemetry.rs`, `src/core/telemetry_cmd.rs`) that sends anonymous usage metrics to a remote server. This conflicts with the product direction of collecting no user information. The proposal calls for complete removal of all telemetry collection, transmission, and documentation.

**What is telemetry (to remove):**
- `src/core/telemetry.rs` — Remote ping system sending usage stats to `RTK_TELEMETRY_URL`
- `src/core/telemetry_cmd.rs` — CLI subcommand (`rtk telemetry status/enable/disable/forget`)
- `docs/TELEMETRY.md` — Telemetry documentation
- Config section `telemetry` in `Config` struct (consent, enabled, consent_date)
- Dependencies: `ureq` (HTTP client for pings), `sha2` (device hash), `getrandom` (salt generation)
- `RTK_TELEMETRY_URL`, `RTK_TELEMETRY_TOKEN`, `RTK_TELEMETRY_DISABLED` env var handling
- `hooks::init::save_telemetry_consent()` function

**What is NOT telemetry (to keep):**
- `src/core/tracking.rs` — Local SQLite tracking for `rtk gain` command (no remote transmission)
- `src/analytics/` — Local analytics modules for cost reporting (no remote transmission)
- `parse_failures` table — Local error tracking only

## Goals / Non-Goals

**Goals:**
- Remove all code paths that transmit data to remote servers
- Remove all telemetry CLI subcommands and configuration
- Update documentation to state no usage data is collected
- Remove telemetry-specific dependencies where no longer needed
- Maintain local tracking (`rtk gain`) and analytics functionality

**Non-Goals:**
- Removing local token savings tracking (`rtk gain`)
- Removing parse failure tracking (local only)
- Removing analytics modules (`src/analytics/`)
- Changing any filter behavior or command output

## Decisions

1. **Complete removal vs. feature flag**: Remove all telemetry code entirely rather than gating behind a flag.
   - Rationale: Product direction is "no telemetry" — dead code is simpler than disabled code.
   - Alternative: Keep code behind `RTK_TELEMETRY_DISABLED=1` default; rejected as it maintains attack surface and maintenance burden.

2. **Dependency cleanup**: Remove `ureq`, `sha2`, `getrandom` if only used by telemetry.
   - Rationale: Reduces binary size and supply chain risk.
   - Verification needed: Check if these crates are used elsewhere before removing.

3. **Config migration**: Remove `telemetry` field from `Config` struct. Existing config files with telemetry sections will simply have those sections ignored (no migration needed — TOML parsers ignore unknown keys).

4. **`rtk telemetry` command removal**: The subcommand will be removed from the CLI. Users who had telemetry enabled will have it silently stop working (no data sent since endpoint is removed).

## Risks / Trade-offs

- [Risk] Users who relied on telemetry for compliance auditing lose that capability → Mitigation: Document that no telemetry exists; local tracking (`rtk gain`) remains available.
- [Risk] `ureq` may be used by other modules (e.g., `curl` command filter) → Mitigation: Audit all usages before removing from Cargo.toml.
- [Risk] Config files with `[telemetry]` sections may cause confusion → Mitigation: No action needed; TOML ignores unknown sections. Document in changelog.
- [Trade-off] Losing telemetry means no aggregate usage data for filter prioritization → Mitigation: This is the intended product direction.
