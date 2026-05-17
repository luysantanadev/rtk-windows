## MODIFIED Requirements

### Requirement: No remote telemetry data collection
The application SHALL NOT transmit user usage data to remote telemetry or analytics endpoints.

#### Scenario: Application startup
- **WHEN** the application starts
- **THEN** no telemetry or analytics collectors are initialized
- **AND** no device identifiers are generated
- **AND** no remote telemetry scheduler is started

#### Scenario: Command execution
- **WHEN** a command is executed through RTK
- **THEN** no command usage data is transmitted to remote telemetry endpoints
- **AND** local tracking for `rtk gain` remains functional

### Requirement: No telemetry configuration
The application SHALL NOT include telemetry-related configuration options, environment variables, or CLI flags.

#### Scenario: Configuration parsing
- **WHEN** configuration files are loaded
- **THEN** telemetry-related sections are ignored without affecting command execution
- **AND** no telemetry behavior is enabled by configuration

#### Scenario: Environment variables and flags
- **WHEN** telemetry-related environment variables or flags are provided
- **THEN** they have no effect on application behavior
- **AND** no telemetry code paths are activated

## ADDED Requirements

### Requirement: Documentation is telemetry-free
The project documentation SHALL NOT instruct, mention, or imply that telemetry/data collection is supported.

#### Scenario: Documentation review
- **WHEN** official documentation is reviewed (README, docs, contributing/maintainer guides)
- **THEN** no telemetry setup, opt-in/opt-out, endpoint, token, or consent instructions are present

### Requirement: No telemetry-facing CLI surface
The application SHALL NOT expose telemetry-related commands or help text.

#### Scenario: Help output inspection
- **WHEN** a user inspects CLI help output
- **THEN** no telemetry command, flag, or environment variable is listed
