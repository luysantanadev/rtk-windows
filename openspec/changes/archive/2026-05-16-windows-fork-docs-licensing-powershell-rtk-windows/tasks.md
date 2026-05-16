## 1. Specification and scope alignment

- [x] 1.1 Validate all new/modified capability deltas against repository reality (`release-process`, `windows-only-distribution`, and new capabilities)
- [x] 1.2 Confirm canonical naming and version policy statements to be reused across docs (`rtk-windows`, fork baseline reset)

## 2. Documentation normalization (Windows + PowerShell Core)

- [x] 2.1 Audit root and docs content for Linux/macOS shell examples and map each to PowerShell Core equivalents
- [x] 2.2 Update README variants and install/usage guides to make PowerShell Core snippets default
- [x] 2.3 Update maintainer/contributor docs to remove non-Windows-first operational assumptions
- [x] 2.4 Run consistency pass to ensure Windows-only wording is semantically aligned across localized READMEs and guides

## 3. Licensing and legal/reference consistency

- [x] 3.1 Review LICENSE, SECURITY, DISCLAIMER, and related legal/reference documents for fork identity wording consistency
- [x] 3.2 Update ownership/fork references where needed to avoid upstream/fork ambiguity

## 4. Binary identity and version lineage reset

- [x] 4.1 Update user-facing docs and release references from `rtk` binary naming to `rtk-windows`
- [x] 4.2 Update Cargo/package metadata and version references to reflect fork baseline reset (current fork baseline 0.1.0)
- [x] 4.3 Add explicit release/changelog communication for reset lineage and expected version output semantics

## 5. Release/process documentation alignment

- [x] 5.1 Align CI/CD and release docs with current workflows (GitHub Releases-only, no GitHub App/Homebrew/Discord dependencies)
- [x] 5.2 Ensure artifact naming in docs/spec references matches `rtk-windows` release contract

## 6. Validation and sign-off

- [x] 6.1 Run repository-wide grep checks for stale Linux/macOS command examples and stale `rtk` binary references
- [x] 6.2 Run formatting/lint checks for touched docs and metadata files
- [x] 6.3 Prepare final change summary with file-level evidence and apply readiness confirmation
