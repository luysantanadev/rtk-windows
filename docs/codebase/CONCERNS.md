# Codebase Concerns

## Core Sections (Required)

### 1) Top Risks (Prioritized)

| Severity | Concern | Evidence | Impact | Suggested action |
|----------|---------|----------|--------|------------------|
| high | High churn in core routing/rewrite files (main.rs, registry.rs) | docs/codebase/.codebase-scan.txt (HIGH-CHURN FILES) | Regressions in command routing can impact most workflows | Split/decouple routing and strengthen targeted tests for changed paths |
| high | Very large critical files in hot paths (init.rs, registry.rs, main.rs) | docs/codebase/.codebase-scan.txt (Top 10 largest files) | Harder reviewability, hidden side effects, onboarding burden | Incremental modular extraction with behavior-preserving tests |
| medium | Documentation inconsistency for tracking DB filename/path | src/core/constants.rs vs src/core/tracking.rs comments vs docs/TELEMETRY.md | Ops confusion during troubleshooting/backups/privacy operations | Normalize docs and comments to a single canonical DB path/name |
| medium | Filter quality debt explicitly acknowledged below 60% target in pipe tests | docs/codebase/.codebase-scan.txt TODO entries in src/cmds/system/pipe_cmd.rs | Lower savings ROI and possible trust erosion in optimization claims | Prioritize pipe filter grouping improvements and add regression fixtures |

### 2) Technical Debt

| Debt item | Why it exists | Where | Risk if ignored | Suggested fix |
|-----------|---------------|-------|-----------------|---------------|
| Centralized mega-router | Organic command growth over many ecosystems | src/main.rs | Merge conflicts, accidental command registration bugs | Extract CLI schema/routing modules by domain |
| Rewrite registry complexity | Need to support many shell syntaxes/operators | src/discover/registry.rs | Edge-case rewrite regressions across agents | Add focused parser/rewrite test matrix per operator class |
| Inconsistent test strategy docs vs code | Docs reference snapshot tooling that is not obvious in current src search | CONTRIBUTING.md, docs/contributing/CODING_PRACTICES.md | Contributor confusion and uneven test expectations | Align docs with implemented tests or reintroduce evidenced snapshot coverage |

### 3) Security Concerns

| Risk | OWASP category (if applicable) | Evidence | Current mitigation | Gap |
|------|--------------------------------|----------|--------------------|-----|
| Command rewrite abuse if hooks mis-handle failures | A01/A05 | hooks/claude/rtk-rewrite.sh, src/hooks/rewrite_cmd.rs | Non-blocking pass-through and explicit exit code protocol | [TODO] Cross-agent consistency review for all hook implementations |
| Supply-chain/dependency vulnerability exposure | A03 | .github/workflows/ci.yml | cargo-audit + semgrep + CI gating | [TODO] Evidence of regular cargo-deny enforcement in CI not found in scanned workflow |
| Trust of project-level TOML filters | A08 | src/core/toml_filter.rs | Trust gate with status checks and warnings | User education/discoverability of trust workflow may vary across agents |

### 4) Performance and Scaling Concerns

| Concern | Evidence | Current symptom | Scaling risk | Suggested improvement |
|---------|----------|-----------------|-------------|-----------------------|
| Startup and parse overhead sensitivity | README claims <10ms; large main/router files in scan metrics | Potential startup regressions as commands grow | Reduced adoption if perceived latency increases | Keep benchmarking in CI and add startup regression threshold checks |
| Large regex/rule set in rewrite path | src/discover/registry.rs, src/discover/rules.rs | Classification complexity grows with rule count | Slower rewrite path or edge-case misses | Segment rules by category and measure matching hot paths |
| Tracking DB concurrency/load over time | src/core/tracking.rs (WAL + busy_timeout) | Local DB contention possible with many sessions | Analytics inaccuracies or lock contention | Periodic maintenance/vacuum guidance and optional pruning controls |

### 5) Fragile/High-Churn Areas

| Area | Why fragile | Churn signal | Safe change strategy |
|------|-------------|-------------|----------------------|
| src/main.rs | Central command enum + routing for most functionality | 92 changes in 90-day scan | Make small isolated changes with command-level tests and CI matrix run |
| src/discover/registry.rs | Parser/rewrite logic affects all hook integrations | 56 changes in 90-day scan | Add failing regression tests before rule/lexer edits |
| src/hooks/init.rs | Installation/integration logic across agents | 28 changes in 90-day scan | Validate per-agent install/uninstall scripts in smoke/integration tests |

### 6) [ASK USER] Questions

1. [ASK USER] Should the project standardize on history.db or tracking.db as the canonical tracking database name in all docs/comments?
2. [ASK USER] Do you want snapshot testing with insta to be mandatory in current code, or should contributor docs be updated to reflect the current non-snapshot-heavy implementation?
3. [ASK USER] Is the intended long-term architecture to keep a single-router src/main.rs, or should we plan a phased split into dedicated CLI schema and routing modules?

### 7) Evidence

- docs/codebase/.codebase-scan.txt
- src/main.rs
- src/discover/registry.rs
- src/discover/rules.rs
- src/core/toml_filter.rs
- src/core/tracking.rs
- src/core/constants.rs
- hooks/claude/rtk-rewrite.sh
- src/hooks/rewrite_cmd.rs
- .github/workflows/ci.yml
- CONTRIBUTING.md
- docs/contributing/CODING_PRACTICES.md
