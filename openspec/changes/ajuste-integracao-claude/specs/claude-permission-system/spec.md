## MODIFIED Requirements

### Requirement: Permission rule matching with transparent prefixes
The system SHALL apply transparent prefix stripping before evaluating permission rules, so that `docker exec mycontainer git status` matches rules for `git status`.

#### Scenario: Transparent prefix stripped before rule matching
- **WHEN** a command with a configured transparent prefix (e.g., `docker exec mycontainer git status`) is evaluated
- **THEN** the permission rules are matched against the stripped command (`git status`)

#### Scenario: Compound command permission checking
- **WHEN** a compound command (e.g., `git add . && cargo test`) is evaluated
- **THEN** each segment is checked against permission rules independently
- **AND** the overall verdict follows deny > ask > allow precedence

### Requirement: Permission rule pattern matching
The system SHALL support wildcard patterns (`*`, `prefix:*`, glob-style) in permission rules with correct whole-word matching.

#### Scenario: Wildcard pattern matches command
- **WHEN** a permission rule `git:*` is configured
- **THEN** it matches `git status`, `git log`, `git diff` but not `gitlab ci`

#### Scenario: Exact pattern does not substring match
- **WHEN** a permission rule `curl` is configured
- **THEN** it matches `curl` but not `curl-config` or `pcurl`
