## 1. Audit & Documentation

- [x] 1.1 Create comprehensive file inventory: scan all files for Linux/bash/macOS keywords
- [x] 1.2 Document list of affected files by category (documentation, hooks, scripts, installation)
- [x] 1.3 Generate audit report to track removal progress

## 2. Archive Unix Hook Scripts

- [x] 2.1 Create hooks/archive/ directory with migration notice
- [x] 2.2 Move hooks/claude/rtk-rewrite.sh to hooks/archive/
- [x] 2.3 Move hooks/copilot/rtk-rewrite.sh to hooks/archive/
- [x] 2.4 Move hooks/cursor/rtk-rewrite.sh to hooks/archive/
- [x] 2.5 Move hooks/cline/rtk-rewrite.sh to hooks/archive/
- [x] 2.6 Move hooks/windsurf/rtk-rewrite.sh to hooks/archive/
- [x] 2.7 Move hooks/codex/rtk-rewrite.sh to hooks/archive/
- [x] 2.8 Move hooks/hermes/rtk-rewrite.sh (if exists) to hooks/archive/
- [x] 2.9 Update hooks/README.md to remove references to Unix shell hooks
- [x] 2.10 Create hooks/archive/README.md with migration guide

## 3. Update Main Documentation

- [x] 3.1 Add prominent "Platform Requirements: Windows 10/11, PowerShell Core" to README.md
- [x] 3.2 Remove all Linux/macOS installation instructions from README.md
- [x] 3.3 Consolidate README.md to show Windows-only scope and cargo/binary installation
- [x] 3.4 Update INSTALL.md to document only Windows installation methods
- [x] 3.5 Remove cross-platform installation badges/options from README
- [x] 3.6 Convert all code examples in README to PowerShell Core syntax
- [x] 3.7 Update CLAUDE.md to show Windows/PowerShell-only setup patterns

## 4. Update Installation Documentation

- [x] 4.1 Simplify install.ps1 to remove any cross-platform checks
- [x] 4.2 Add platform check to install.ps1 to verify Windows and PowerShell version
- [x] 4.3 Remove scripts/install-unix.sh (if exists) or archive it
- [x] 4.4 Update scripts/install-local.ps1 to Windows-only patterns
- [x] 4.5 Remove brew/apt installation references from all installation guides
- [x] 4.6 Add PowerShell $PROFILE configuration documentation

## 5. Update Getting Started Guides

- [ ] 5.1 Rewrite docs/guide/getting-started/index.md to Windows-only focus
- [ ] 5.2 Update docs/guide/getting-started/supported-agents.md to remove non-Windows agents
- [ ] 5.3 Consolidate supported agents to: Copilot, Cursor, Cline, OpenCode, Hermes
- [ ] 5.4 Remove agent-specific Unix instructions from getting-started guides
- [ ] 5.5 Convert all examples to PowerShell Core syntax with proper escaping
- [ ] 5.6 Add troubleshooting section for Windows PATH configuration

## 6. Update Agent Integration Documentation

- [ ] 6.1 Update hooks/copilot/README.md to Windows-only with PowerShell examples
- [ ] 6.2 Update hooks/cursor/README.md to Windows-only with PowerShell examples
- [ ] 6.3 Update hooks/cline/README.md to Windows-only with PowerShell examples
- [ ] 6.4 Update hooks/opencode/README.md to Windows-only (already done in Phase 2)
- [ ] 6.5 Update hooks/hermes/README.md to Windows-only with PowerShell examples
- [ ] 6.6 Remove hooks/antigravity/README.md or archive if present
- [ ] 6.7 Remove hooks/kilocode/README.md or archive if present

## 7. Update Troubleshooting Guide

- [ ] 7.1 Consolidate docs/guide/resources/troubleshooting.md to Windows-only scenarios
- [ ] 7.2 Add Windows PATH configuration troubleshooting section
- [ ] 7.3 Add PowerShell $PROFILE troubleshooting section
- [ ] 7.4 Remove all Linux/macOS/Unix troubleshooting scenarios
- [ ] 7.5 Update rtk status/verify command documentation to Windows verification steps

## 8. Update API/Features Documentation

- [x] 8.1 Review docs/guide/usage/FEATURES.md and remove cross-platform references
- [x] 8.2 Verify all feature examples use PowerShell syntax
- [x] 8.3 Update docs/contributing/*.md to remove Unix build/testing references
- [ ] 8.4 Verify ARCHITECTURE.md contains no Linux/macOS implementation notes

## 9. Update README Translations

- [ ] 9.1 Update README.md (main) platform scope
- [ ] 9.2 Update README_es.md with Windows-only platform note
- [ ] 9.3 Update README_fr.md with Windows-only platform note
- [ ] 9.4 Update README_ja.md with Windows-only platform note
- [ ] 9.5 Update README_ko.md with Windows-only platform note
- [ ] 9.6 Update README_zh.md with Windows-only platform note

## 10. Update Source Code Comments

- [x] 10.1 Search source code for bash/shell/Unix references in comments
- [x] 10.2 Remove Unix-specific environment variable references from code comments
- [x] 10.3 Update example commands in Rust doc comments to PowerShell
- [x] 10.4 Remove cross-platform conditional comments (e.g., "on Unix, use X")

## 11. Update Build & Test Scripts

- [ ] 11.1 Review scripts/test-all.ps1 and ensure Windows-only execution
- [x] 11.2 Review scripts/benchmark.ps1 and remove Unix references
- [ ] 11.3 Update scripts/check-installation.ps1 to verify Windows/PowerShell
- [ ] 11.4 Remove any shell script equivalents (*.sh) from scripts/ if present
- [ ] 11.5 Update build.rs to remove cross-platform build logic comments

## 12. Quality Verification

- [ ] 12.1 Run `cargo fmt --all` and verify formatting
- [ ] 12.2 Run `cargo clippy --all-targets` and fix all warnings
- [ ] 12.3 Run `cargo test --all` and verify all tests pass
- [ ] 12.4 Verify no references to "bash", "shell", "linux", "macos", "zsh" in docs
- [ ] 12.5 Test installation on clean Windows 11 machine with PowerShell Core
- [ ] 12.6 Verify all code examples in README execute correctly in pwsh

## 13. Final Validation

- [ ] 13.1 Create summary of all archived files in CHANGELOG.md
- [ ] 13.2 Verify all links in documentation point to Windows-only resources
- [ ] 13.3 Run automated platform scope validator (grep for Unix keywords)
- [ ] 13.4 Commit changes with clear message: "Consolidate to Windows/PowerShell-only"
- [ ] 13.5 Create release notes documenting platform scope change
- [ ] 13.6 Update VERSION file if needed to reflect significant platform change
