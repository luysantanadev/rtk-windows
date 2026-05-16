## ADDED Requirements

### Requirement: Official Windows-only platform contract
The fork MUST define Windows native (PowerShell/cmd) as its only supported runtime platform.

#### Scenario: User checks supported platforms
- **WHEN** a user reads the repository support statement
- **THEN** the fork SHALL state Windows-only support and SHALL mark Linux/macOS as unsupported in this fork

### Requirement: Removal of Unix/macOS runtime branches
The runtime layer SHALL remove Unix/macOS execution branches that are no longer required for Windows-only operation.

#### Scenario: Runtime execution path selection
- **WHEN** command execution paths are resolved in runtime modules
- **THEN** only Windows-relevant execution branches SHALL remain active in this fork

### Requirement: Windows-native spawn semantics
Process spawning MUST preserve correct Windows behavior for quoting, environment prefix handling, pipes, redirects, heredoc passthrough, and exit code propagation.

#### Scenario: Complex command rewrite and execution
- **WHEN** a command includes quoting, env-prefix, pipe, redirect, or heredoc-like content
- **THEN** runtime execution SHALL preserve semantics without introducing Unix-shell assumptions
