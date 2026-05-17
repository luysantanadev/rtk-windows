# Windows-PowerShell Consolidation Audit Report

**Date**: 2026-05-17  
**Scope**: Remove all Linux/bash/macOS references, consolidate to Windows/PowerShell-only  
**Total Affected Files**: 150+

## Summary by Category

### 1. Unix Hook Scripts (Archive) — 6 files
- `hooks/claude/rtk-rewrite.sh`
- `hooks/copilot/rtk-rewrite.sh`
- `hooks/cursor/rtk-rewrite.sh`
- `hooks/cline/rtk-rewrite.sh`
- `hooks/windsurf/rtk-rewrite.sh`
- `hooks/codex/rtk-rewrite.sh`
- `hooks/hermes/rtk-rewrite/` (Python plugin)

### 2. Core Documentation (Update) — 15 files
- `README.md` (primary) — bash examples, Linux install steps
- `README_*.md` (5 translations) — cross-platform references
- `CLAUDE.md` — bash code blocks, Linux examples
- `INSTALL.md` — multi-platform installation guide
- `CHANGELOG.md` — historical Unix references
- `CONTRIBUTING.md` — cross-platform build instructions
- `SECURITY.md` — cross-platform security patterns
- `.github/copilot-instructions.md` — bash section, macOS examples

### 3. Installation Scripts (Update/Archive) — 7 files
- `install.ps1` — cross-platform checks
- `scripts/install-local.ps1` — Unix patterns
- `scripts/test-all.ps1` — bash assumptions
- `scripts/test-install.ps1` — Unix tests
- `scripts/test-aristote.ps1` — Unix patterns
- `scripts/test-ruby.ps1` — Unix patterns
- `scripts/check-installation.ps1` — cross-platform checks

### 4. Hook Integration Docs (Update) — 15 files
- `hooks/README.md` — Unix hook architecture
- `hooks/claude/README.md` — bash/zsh references
- `hooks/copilot/README.md` — macOS examples
- `hooks/cursor/README.md` — Unix setup
- `hooks/cline/README.md` — bash references
- `hooks/windsurf/README.md` — Unix patterns
- `hooks/codex/README.md` — Linux examples
- `hooks/hermes/README.md` — Python hook docs
- `hooks/antigravity/README.md` — agent docs
- `hooks/kilocode/README.md` — agent docs
- `hooks/*/rules.md` (5 files) — cross-platform rules

### 5. Getting Started Guides (Update) — 10 files
- `docs/guide/getting-started/index.md` — multi-platform guide
- `docs/guide/getting-started/supported-agents.md` — all agents including non-Windows
- `docs/guide/resources/troubleshooting.md` — Linux/macOS sections
- `docs/guide/resources/telemetry.md` — cross-platform patterns
- `docs/codebase/STRUCTURE.md` — Unix file structure notes
- `docs/codebase/STACK.md` — cross-platform dependencies
- `docs/codebase/ARCHITECTURE.md` — Unix design notes
- `docs/codebase/CONVENTIONS.md` — bash/zsh conventions
- `docs/codebase/INTEGRATIONS.md` — agent platform support

### 6. Usage & Contributing Docs (Update) — 8 files
- `docs/usage/FEATURES.md` — cross-platform examples
- `docs/usage/AUDIT_GUIDE.md` — Unix scenarios
- `docs/contributing/*.md` — build/test instructions
- `.github/PULL_REQUEST_TEMPLATE.md` — cross-platform guidance
- `.github/docs-pipeline-contract.md` — bash code samples

### 7. Rust Source Code (Update) — 20+ files
- `src/hooks/*.rs` — comments, examples
- `src/discover/README.md` — build notes
- `src/parser/README.md` — testing patterns
- `src/learn/README.md` — Unix patterns
- `src/filters/README.md` — cross-platform filters

### 8. OpenSpec & Configuration (Update) — 15 files
- `openspec/specs/*.md` — multi-platform spec files
- `.claude/skills/*.md` — bash examples
- `.cursor/skills/*.md` — bash examples
- `.codex/skills/*.md` — bash examples
- `.gemini/skills/*.md` — bash examples
- `.github/prompts/*.md` — bash in examples
- `.github/skills/*.md` — bash patterns
- Various SKILL.md files with cross-platform code samples

### 9. Miscellaneous (Update/Archive) — 10+ files
- `openclaw/README.md` — cross-platform setup
- `roadmap.md` — multi-platform plans
- `DISCLAIMER.md` — platform notes
- `.github/workflows/CICD.md` — macOS CI/CD
- `.github/hooks/rtk-rewrite.json` — cross-platform hook config
- `scripts/cloud-init.yaml` — Linux cloud config
- `.claude/hooks/bash/` directory — Unix hook examples

## Implementation Phases

### Phase 1: Archive Unix Hooks (2-3 hours)
- Create `hooks/archive/` with README
- Move 6+ .sh files to archive
- Create migration guide

### Phase 2: Update Main Documentation (3-4 hours)
- README.md and translations
- INSTALL.md, CLAUDE.md, SECURITY.md
- Install scripts consolidation

### Phase 3: Update Integration Guides (2-3 hours)
- Hook README files for all agents
- Consolidate supported agents list
- Update rules and setup patterns

### Phase 4: Update Getting Started & Guides (2-3 hours)
- Rewrite guide index files
- Update troubleshooting (Windows-only scenarios)
- Update codebase structure docs

### Phase 5: Source Code & Config (2-3 hours)
- Update Rust doc comments
- Remove cross-platform comments
- Consolidate OpenSpec/skills

### Phase 6: Quality Verification (1-2 hours)
- Run fmt, clippy, tests
- Validate no Unix keywords remain
- Test on Windows 11 with PowerShell Core

**Total Estimated Effort**: 12-18 hours across 6 phases

## Files Ready for Immediate Action

**High Priority** (affect user experience):
1. `README.md` — primary user guide
2. `INSTALL.md` — installation path
3. `hooks/README.md` — hook architecture
4. `docs/guide/getting-started/supported-agents.md` — agent list

**Medium Priority** (documentation consistency):
1. Hook integration READMEs (copilot, cursor, cline, etc.)
2. Installation scripts (install.ps1, test scripts)
3. Troubleshooting guides

**Low Priority** (internal):
1. Source code comments
2. OpenSpec files
3. Miscellaneous docs

---
**Next**: Begin Phase 2 by archiving Unix hook scripts.
