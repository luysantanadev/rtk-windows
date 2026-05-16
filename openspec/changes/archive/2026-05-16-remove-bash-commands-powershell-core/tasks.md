## 1. Inventory and Migration Planning

- [x] 1.1 Identify maintained Bash scripts and Bash command references in documentation (`.sh`, `bash`, shebangs) across repository-maintained paths
- [x] 1.2 Map each Bash script to a PowerShell Core target (`.ps1`) and define command-parity acceptance criteria for each migration
- [x] 1.3 Confirm the list of documentation locations requiring PowerShell Core-first command updates

## 2. Script Migration to PowerShell Core

- [x] 2.1 Convert maintained Bash automation scripts to PowerShell Core implementations, preserving functional behavior and failure semantics
- [x] 2.2 Update script entry points, invocation examples, and internal references to use `pwsh`
- [x] 2.3 Remove or deprecate replaced Bash scripts once equivalent PowerShell Core scripts are validated

## 3. Documentation and Workflow Alignment

- [x] 3.1 Update README/INSTALL/docs/hooks guidance to remove Bash-first command examples and present PowerShell Core defaults
- [x] 3.2 Add explicit `pwsh` prerequisite notes to contributor setup and script execution documentation
- [x] 3.3 Ensure wording remains aligned with Windows-first positioning across maintained documentation

## 4. Validation and Completion

- [x] 4.1 Execute smoke checks for migrated scripts to verify parity for success and failure paths
- [x] 4.2 Run repository validation commands (format/lint/tests where applicable) to ensure migration introduces no regressions
- [x] 4.3 Perform final repository scan to verify no remaining maintained Bash command/script defaults remain
