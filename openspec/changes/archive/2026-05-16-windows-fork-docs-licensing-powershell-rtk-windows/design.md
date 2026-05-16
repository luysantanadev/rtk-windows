## Context

This change standardizes the fork as a Windows-first project at the specification and documentation layers. The repository already moved CI/CD to GitHub Releases-focused publishing, but requirements and docs still include mixed platform assumptions, binary naming ambiguity (`rtk` vs `rtk-windows`), and legacy version lineage language.

Stakeholders include maintainers (release and governance consistency), contributors (clear contributor guidance), and users (accurate install/usage guidance for Windows and PowerShell Core).

Constraints:
- Keep behavior compatible with the existing Windows-only release pipeline.
- Avoid introducing new runtime dependencies; this is mostly documentation/specification and release-contract alignment.
- Preserve OpenSpec traceability by expressing requirement changes through capability deltas.

## Goals / Non-Goals

**Goals:**
- Define normative requirements for Windows + PowerShell Core documentation consistency.
- Define normative requirements for fork identity, including binary naming (`rtk-windows`) and reset version baseline communication.
- Update existing `windows-only-distribution` and `release-process` requirements so they reflect the fork's current release model and naming.
- Produce implementation tasks that sequence spec alignment, docs updates, and version/binary reference updates safely.

**Non-Goals:**
- Re-architect the release workflows beyond what is required for naming/version contract consistency.
- Add Linux/macOS distribution paths or cross-platform packaging.
- Change core command filtering behavior in this design phase.

## Decisions

### Decision 1: Capture documentation consistency as a dedicated capability
- Decision: Add `windows-powershell-doc-consistency` as a new capability instead of scattering requirements into unrelated specs.
- Rationale: Documentation policy becomes testable and auditable with explicit SHALL statements and scenarios.
- Alternatives considered:
  - Add notes only in proposal/tasks: rejected because requirements would remain implicit and easy to regress.
  - Modify only `windows-only-distribution`: rejected because distribution and documentation governance are related but distinct concerns.

### Decision 2: Capture naming/version baseline as a dedicated capability
- Decision: Add `fork-identity-version-lineage` with explicit requirements for binary naming and semantic-version baseline communication.
- Rationale: Fork identity changes are cross-cutting and affect release notes, docs, and install instructions.
- Alternatives considered:
  - Keep in release-process only: rejected because release process is operational and does not cover all user-facing references.

### Decision 3: Use MODIFIED deltas for existing capabilities with full requirement blocks
- Decision: For `windows-only-distribution` and `release-process`, provide full MODIFIED requirement blocks in change-local specs.
- Rationale: OpenSpec archive correctness requires full updated content for modified requirements.
- Alternatives considered:
  - Add only ADDED requirements: rejected because existing normative text would remain conflicting.

### Decision 4: Align release artifacts around `rtk-windows` naming contract
- Decision: Update release-related requirements to enforce artifact and binary naming aligned to `rtk-windows`.
- Rationale: Avoid ambiguity between upstream naming and fork identity.
- Alternatives considered:
  - Keep `rtk` naming internally while documenting `rtk-windows`: rejected due to long-term inconsistency risk.

## Risks / Trade-offs

- [Risk] Documentation drift between language variants (README_fr/es/ja/ko/zh) persists.
  - Mitigation: Include explicit tasks requiring cross-language consistency checks and spot validation.
- [Risk] Existing scripts or examples still reference `rtk`.
  - Mitigation: Add task to perform repository-wide reference audit and update.
- [Risk] Version reset communication is misunderstood by users.
  - Mitigation: Require changelog/release notes statement explaining fork baseline and compatibility expectations.
- [Trade-off] Strict Windows/PowerShell defaults may reduce immediate portability of docs.
  - Mitigation: Keep optional non-Windows notes clearly marked as secondary when unavoidable.

## Migration Plan

1. Approve and archive these spec deltas.
2. Apply implementation tasks: update docs, naming, version references, release notes, and install guidance.
3. Validate consistency via docs grep checks and manual review on key entry points.
4. Rollback strategy: revert documentation and metadata commits if inconsistencies are detected before release tagging.

## Open Questions

- Should command examples preserve an optional Bash section in appendices, or become strictly PowerShell Core only across all docs? Strictly powershell core
- Should binary naming migration include a compatibility alias period (`rtk` -> `rtk-windows`) in docs, or immediate cutover only? immediate cutover only
- Which exact baseline tag/message should be used to communicate the reset from upstream lineage to fork lineage? https://github.com/luysantanadev/rtk-windows.git/releases/tag/dev-0.40.1-rc.223
