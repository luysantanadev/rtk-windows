## MODIFIED Requirements

### Requirement: Command rewrite registry coverage
The system SHALL provide rewrite rules for all commonly-used commands across git, cargo, npm/pnpm, docker, kubectl, go, python, ruby, .NET, and system command ecosystems.

#### Scenario: Git commands rewritten
- **WHEN** Claude executes `git status`, `git log`, `git diff`, `git add`, `git commit`, `git push`, `git pull`
- **THEN** each is rewritten to its `rtk git` equivalent

#### Scenario: Cargo commands rewritten
- **WHEN** Claude executes `cargo build`, `cargo test`, `cargo clippy`, `cargo check`
- **THEN** each is rewritten to its `rtk cargo` equivalent

#### Scenario: System commands rewritten
- **WHEN** Claude executes `ls`, `cat`, `tree`, `grep`, `find`, `wc`, `diff`
- **THEN** each is rewritten to its `rtk` equivalent

### Requirement: Compound command rewriting
The system SHALL rewrite each segment of compound commands connected by `&&`, `||`, `;`, preserving operators and execution order.

#### Scenario: And-chain rewritten
- **WHEN** Claude executes `git add . && cargo test && git push`
- **THEN** it is rewritten to `rtk git add . && rtk cargo test && rtk git push`

#### Scenario: Unsupported segment passed through
- **WHEN** Claude executes `git status && echo "done"`
- **THEN** `git status` is rewritten to `rtk git status` and `echo "done"` passes through unchanged

### Requirement: Environment prefix preservation
The system SHALL preserve environment variable prefixes when rewriting commands.

#### Scenario: Env prefix preserved
- **WHEN** Claude executes `RTK_NO_TOML=1 git status`
- **THEN** it is rewritten to `RTK_NO_TOML=1 rtk git status`
