## Why

RTK-Windows is a Windows-first CLI tool optimized for PowerShell Core environments. The codebase currently carries legacy references to Linux/bash/macOS workflows that create confusion about supported platforms and complicate documentation, installation guidance, and example code. Consolidating RTK as Windows/PowerShell-only will clarify platform scope, simplify maintenance, and align all integrations and documentation with the actual supported environment.

## What Changes

- Remove all Linux/bash/sh references from documentation, guides, and troubleshooting
- Remove macOS-specific installation steps and environment variable guidance (~/.bashrc, ~/.zshrc, etc.)
- Remove shell script hooks (`rtk-rewrite.sh`) for Unix agents (Claude Code, Copilot, Cursor, etc.)
- Convert all example commands to PowerShell Core (pwsh) syntax
- Convert installation instructions to Windows-only with cargo or direct binary download
- Update README, INSTALL, and guides to reflect Windows/PowerShell-only scope
- Remove Unix-style paths and environment patterns, convert to Windows equivalents
- Consolidate agent integration documentation to Windows-only agents (Copilot, Cursor, Cline, OpenCode, etc.)

## Capabilities

### New Capabilities
- `windows-only-platform-scope`: RTK is explicitly Windows/PowerShell-only with no cross-platform support

### Modified Capabilities
- `installation-flow`: Installation guidance changes from multi-platform (cargo, brew, apt) to Windows-only (cargo, direct exe download)
- `agent-integration-hooks`: Hook system simplified to Windows-only agents; removes Unix hook scripts and configuration

## Impact

Affected code and documentation:
- README.md, INSTALL.md, and all getting-started guides
- Installation scripts (remove bash/sh scripts, consolidate to PowerShell)
- Hook system: remove/archive Unix shell script hooks
- Example commands: convert from bash to PowerShell throughout docs
- Troubleshooting guides: remove Linux/macOS sections
- Agent integration docs: remove references to non-Windows agents

This is a breaking change that clarifies RTK scope but simplifies platform complexity.
