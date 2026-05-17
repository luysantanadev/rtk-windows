## MODIFIED Requirements

### Requirement: Command rewrite registry coverage
The system SHALL provide rewrite rules for all commonly-used commands across git, cargo, npm/pnpm, docker, kubectl, go, python, ruby, .NET, and system command ecosystems, and SHALL apply those rules consistently when command input is received through supported agent integrations including OpenCode.

#### Scenario: Git commands rewritten
- **WHEN** Claude executes `git status`, `git log`, `git diff`, `git add`, `git commit`, `git push`, `git pull`
- **THEN** each is rewritten to its `rtk git` equivalent

#### Scenario: Cargo commands rewritten
- **WHEN** Claude executes `cargo build`, `cargo test`, `cargo clippy`, `cargo check`
- **THEN** each is rewritten to its `rtk cargo` equivalent

#### Scenario: System commands rewritten
- **WHEN** Claude executes `ls`, `cat`, `tree`, `grep`, `find`, `wc`, `diff`
- **THEN** each is rewritten to its `rtk` equivalent

#### Scenario: OpenCode receives equivalent rewrite coverage
- **WHEN** OpenCode triggers `tool.execute.before` with supported commands from registry-covered ecosystems
- **THEN** the same command families are rewritten to their `rtk` equivalents
- **AND** unsupported commands pass through unchanged
