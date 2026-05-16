## Context

The repository has progressed toward a Windows-first distribution model, but maintenance still includes mixed shell semantics (Bash and PowerShell) in scripts and documentation. This creates inconsistent contributor experience, duplicated maintenance paths, and higher risk of command drift over time.

The change introduces a single canonical shell/runtime for maintained automation and user-facing command examples: PowerShell Core (`pwsh`). Existing behavior must remain functionally equivalent after migration.

## Goals / Non-Goals

**Goals:**
- Standardize maintained script automation on PowerShell Core.
- Remove Bash command usage from maintained documentation where equivalent PowerShell Core commands exist.
- Preserve operational behavior through command-parity translation and smoke validation.
- Keep workflow execution explicit and deterministic for contributors and CI.

**Non-Goals:**
- Rewriting third-party upstream examples outside this repository's maintained docs.
- Introducing new feature behavior unrelated to shell/runtime standardization.
- Supporting parallel Bash and PowerShell maintenance paths for the same maintained automation.

## Decisions

1. Canonical runtime decision: use `pwsh` as default execution runtime for maintained automation.
- Rationale: aligns with Windows-only strategy while remaining usable cross-platform where PowerShell Core is installed.
- Alternative considered: keep dual Bash + PowerShell scripts; rejected due to duplicated maintenance and drift risk.

2. Migration strategy decision: convert scripts by behavior parity, not literal syntax translation.
- Rationale: robust PowerShell implementations should use cmdlets/object pipelines where appropriate while preserving observable outcomes.
- Alternative considered: mechanical line-by-line translation; rejected due to fragile quoting/exit-code differences.

3. Documentation policy decision: PowerShell snippets become authoritative; Bash snippets are removed from maintained docs unless explicitly historical.
- Rationale: one default path minimizes ambiguity and onboarding friction.
- Alternative considered: keep side-by-side snippets; rejected because it reintroduces divergence and review overhead.

4. Validation decision: run targeted script and workflow checks after conversion before considering migration complete.
- Rationale: shell migration risks include path, quoting, and exit-code behavior differences.
- Alternative considered: rely only on static review; rejected due to high regression risk for command execution semantics.

## Risks / Trade-offs

- [Risk] Bash-to-pwsh translation changes command semantics (quoting, globbing, error handling) -> Mitigation: validate each migrated script with representative inputs and explicit failure-path checks.
- [Risk] Contributors without PowerShell Core cannot run updated automation -> Mitigation: document `pwsh` prerequisite clearly in setup and usage docs.
- [Risk] Incomplete migration leaves residual Bash references -> Mitigation: perform repository-wide search for `.sh`, `bash`, and shell shebang references in maintained paths.
- [Trade-off] Removing Bash examples reduces familiarity for Linux/macOS-native users -> Mitigation: keep concise note that this fork standardizes on PowerShell Core and is Windows-first.
