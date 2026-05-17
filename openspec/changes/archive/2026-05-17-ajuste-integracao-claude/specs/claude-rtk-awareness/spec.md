## ADDED Requirements

### Requirement: Comprehensive RTK awareness instructions for Claude
The system SHALL provide Claude Code with comprehensive instructions about RTK's supported commands, token savings expectations, and common workflows via the embedded `rtk-awareness-v2.md` file.

#### Scenario: RTK awareness covers all command categories
- **WHEN** Claude Code reads the RTK instructions
- **THEN** it sees coverage for git, cargo, npm/pnpm, docker, kubectl, go, python, ruby, .NET, and system commands

#### Scenario: RTK awareness includes token savings expectations
- **WHEN** Claude Code reads the RTK instructions
- **THEN** it sees typical token savings percentages per command category

### Requirement: RTK awareness includes meta commands
The system SHALL document all RTK meta commands (`gain`, `discover`, `proxy`, `init`, `config`, `verify`, `trust`, `untrust`) in the awareness instructions.

#### Scenario: Meta commands documented
- **WHEN** Claude Code reads the RTK instructions
- **THEN** it sees descriptions and usage examples for all meta commands
