## Why

The fork has shifted to a Windows-only distribution model, but documentation, release messaging, command examples, and naming still contain mixed Linux/macOS references and pre-fork versioning assumptions. This creates onboarding friction and inconsistency for contributors and users.

## What Changes

- Normalize project documentation and references to the Windows-first fork identity, including naming and distribution positioning.
- Replace Linux/macOS-oriented command references in docs with PowerShell Core equivalents where applicable.
- Align licensing and legal references to the current fork scope and ownership wording used in this repository.
- Reset and clarify project version lineage for the fork and document the new versioning baseline.
- Rename distributed binary references from `rtk` to `rtk-windows` and align installation/usage docs.
- Update release and process documentation to match the forked lifecycle and current CI/CD flow.

## Capabilities

### New Capabilities
- `windows-powershell-doc-consistency`: Ensure user-facing documentation defaults to PowerShell Core command examples and Windows execution assumptions.
- `fork-identity-version-lineage`: Define explicit fork identity rules for naming (`rtk-windows`) and version baseline reset communication.

### Modified Capabilities
- `windows-only-distribution`: Expand and tighten requirements to require Windows-first docs, command examples, and binary naming consistency.
- `release-process`: Update release requirements to reflect forked version reset semantics and release artifact naming.

## Impact

- Affected areas: top-level README variants, installation and usage docs, contributing/release docs, changelog/release messaging, and references under `docs/`, `openspec/specs/`, and related maintenance files.
- Affected systems: release documentation pipeline and any scripts/docs that reference binary name or semver baseline.
- Dependencies: no new runtime dependency expected; documentation and specification alignment only at this phase.
