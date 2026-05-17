## ADDED Requirements

### Requirement: Windows-only hook implementations
RTK agent integration hooks SHALL support only Windows-compatible agents with no cross-platform shell scripts.

#### Scenario: Supported Windows agents are documented
- **WHEN** viewing agent integration documentation in docs/guide/getting-started/supported-agents.md
- **THEN** only Windows-compatible agents are listed: Copilot, Cursor, Cline, OpenCode, Hermes
- **AND** each agent has Windows-specific hook implementation (TypeScript plugin, PowerShell script, or binary integration)
- **AND** no Unix shell scripts are referenced

#### Scenario: Unix shell scripts are archived
- **WHEN** searching for rtk-rewrite.sh or other Unix hook scripts in active codebase
- **THEN** no active .sh hook scripts exist in hooks/ directory
- **AND** archived versions exist in hooks/archive/ with migration documentation
- **AND** Git history preserves the original implementations for reference

#### Scenario: OpenCode hook is Windows/PowerShell only
- **WHEN** installing RTK with `rtk-windows init -g --opencode`
- **THEN** the OpenCode plugin (rtk.ts) is deployed with: health check for `rtk-windows --version`, tool detection for powershell/pwsh/powershell-core, and rewrite delegation to `rtk-windows rewrite`
- **AND** no references to bash or shell detection exist

#### Scenario: All agent documentation shows PowerShell setup
- **WHEN** reading integration guides for any supported agent
- **THEN** all code examples and setup commands use PowerShell Core syntax
- **AND** no references to ~/.bashrc, ~/.zshrc, or shell-specific configuration exist
- **AND** PATH configuration uses Windows GUI or PowerShell $PROFILE

### Requirement: No cross-platform hook detection
RTK hook registration SHALL remove all Unix-centric detection logic and use only Windows patterns.

#### Scenario: Hook verification uses Windows patterns only
- **WHEN** hook integrity checks run via `rtk verify`
- **THEN** checks validate Windows-specific paths (registry, PowerShell profile, Windows environment variables)
- **AND** no checks for Unix shell configuration files are performed
- **AND** error messages reference only Windows troubleshooting steps

#### Scenario: Hook installation constraints are Windows-focused
- **WHEN** running `rtk init` with various flags
- **THEN** constraint validation is specific to Windows scenarios (e.g., -g flag for PowerShell global profile, no Unix-specific conflict checks)
- **AND** no cross-platform capability negotiation occurs

#### Scenario: Documentation references only Windows agents
- **WHEN** troubleshooting hook issues in docs/guide/resources/troubleshooting.md
- **THEN** all scenarios reference only Copilot, Cursor, Cline, OpenCode, and Hermes
- **AND** no scenarios for Claude Code on macOS, Copilot on Linux, or other Unix agent combinations exist
