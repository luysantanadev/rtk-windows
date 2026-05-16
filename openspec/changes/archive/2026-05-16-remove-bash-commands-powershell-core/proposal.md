## Why

The repository still contains Bash command usage in scripts and docs, which conflicts with the Windows-first direction and creates friction for contributors on PowerShell-based environments. Aligning all command guidance and automation to PowerShell Core now reduces maintenance overhead and removes shell-specific divergence.

## What Changes

- Replace remaining Bash-specific command examples in maintained documentation with PowerShell Core equivalents.
- Migrate repository-maintained Bash automation scripts to PowerShell Core scripts, preserving behavior and validation coverage.
- Update CI/CD and contributor guidance to remove Bash-only execution paths where PowerShell Core can be used cross-platform.
- Add compatibility notes for pwsh execution in local development and validation workflows.

## Capabilities

### New Capabilities
- `powershell-core-script-runtime`: Establishes PowerShell Core as the canonical command/runtime layer for repository automation and user-facing command examples.

### Modified Capabilities
- `windows-powershell-doc-consistency`: Expands consistency requirements from documentation alignment to full Bash command/script removal in maintained workflows.

## Impact

- Affected code: scripts under `scripts/`, possible helper tooling references, and docs under `README*`, `docs/`, and `hooks/` guidance.
- Affected processes: contributor setup, validation commands, and release/support workflows that currently mention Bash.
- Dependencies: relies on PowerShell Core (`pwsh`) availability in contributor and CI environments.
- Risk: command parity regressions if behavior differs between Bash and PowerShell translations; mitigated by script-level validation and targeted smoke checks.
