<p align="center">
  <img src="https://avatars.githubusercontent.com/u/258253854?v=4" alt="rtk-windows - Rust Token Killer" width="500">
</p>

<p align="center">
  <strong>High-performance CLI proxy that reduces LLM token consumption by 60-90%</strong>
</p>

<p align="center">
  <a href="https://github.com/luysantanadev/rtk-windows.git/actions"><img src="https://github.com/luysantanadev/rtk-windows.git/workflows/Security%20Check/badge.svg" alt="CI"></a>
  <a href="https://github.com/luysantanadev/rtk-windows.git/releases"><img src="https://img.shields.io/github/v/release/luysantanadev/rtk-windows" alt="Release"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
</p>

<p align="center">
  <a href="https://www.rtk-ai.app">Website</a> &bull;
  <a href="#installation">Install</a> &bull;
  <a href="https://www.rtk-ai.app/guide/troubleshooting">Troubleshooting</a> &bull;
  <a href="docs/contributing/ARCHITECTURE.md">Architecture</a>
</p>

<p align="center">
  <a href="README.md">English</a> &bull;
  <a href="README_fr.md">Francais</a> &bull;
  <a href="README_zh.md">中文</a> &bull;
  <a href="README_ja.md">日本語</a> &bull;
  <a href="README_ko.md">한국어</a> &bull;
  <a href="README_es.md">Espanol</a>
</p>

---

rtk-windows filters and compresses command outputs before they reach your LLM context. Single Rust binary, 100+ supported commands, <10ms overhead.

> **Windows-only notice:** This repository supports Windows 10/11 with PowerShell Core or Command Prompt exclusively.

## Token Savings (30-min Claude Code Session)

| Operation | Frequency | Standard | rtk-windows | Savings |
|-----------|-----------|----------|-----|---------|
| `ls` / `tree` | 10x | 2,000 | 400 | -80% |
| `cat` / `read` | 20x | 40,000 | 12,000 | -70% |
| `grep` / `rg` | 8x | 16,000 | 3,200 | -80% |
| `git status` | 10x | 3,000 | 600 | -80% |
| `git diff` | 5x | 10,000 | 2,500 | -75% |
| `git log` | 5x | 2,500 | 500 | -80% |
| `git add/commit/push` | 8x | 1,600 | 120 | -92% |
| `cargo test` / `npm test` | 5x | 25,000 | 2,500 | -90% |
| `ruff check` | 3x | 3,000 | 600 | -80% |
| `pytest` | 4x | 8,000 | 800 | -90% |
| `go test` | 3x | 6,000 | 600 | -90% |
| `docker ps` | 3x | 900 | 180 | -80% |
| **Total** | | **~118,000** | **~23,900** | **-80%** |

> Estimates based on medium-sized TypeScript/Rust projects. Actual savings vary by project size.

## Installation

**Windows only** (PowerShell Core or Command Prompt)

### Windows Binary (Recommended)

Download `rtk-windows-x86_64-pc-windows-msvc.zip` from [releases](https://github.com/luysantanadev/rtk-windows.git/releases), extract `rtk-windows.exe`, and place it in your PATH.

```powershell
# Example user-scoped install directory
New-Item -ItemType Directory -Force "$env:USERPROFILE\bin" | Out-Null
Copy-Item .\rtk-windows.exe "$env:USERPROFILE\bin\rtk-windows.exe" -Force
```

Add to PATH if needed:

```powershell
[Environment]::SetEnvironmentVariable(
  "Path",
  $env:Path + ";$env:USERPROFILE\bin",
  "User"
)
```

### Via Cargo

```powershell
cargo install --git https://github.com/luysantanadev/rtk-windows.git
```

### Verify Installation

```powershell
rtk-windows --version   # Should show "rtk-windows 0.28.x"
rtk-windows gain        # Should show token savings stats
```

> **Name collision warning**: Another project named "rtk" (Rust Type Kit) exists on crates.io. If installation fails, use `cargo install --git` above instead.

## Quick Start

```powershell
# 1. Install for your AI tool (Windows agents)
rtk-windows init                    # VS Code Copilot Chat (default)
rtk-windows init --agent cursor     # Cursor
rtk-windows init --agent cline      # Cline / Roo Code
rtk-windows init --agent opencode   # OpenCode
rtk-windows init --agent hermes     # Hermes

# 2. Restart your AI tool, then test
git status  # Automatically rewritten to rtk-windows git status
```

Hook-based agents (Copilot, Cursor, Cline) rewrite PowerShell/cmd terminal commands (e.g., `git status` -> `rtk-windows git status`) before execution. Plugin-based agents (OpenCode, Hermes) use their plugin API to rewrite commands before execution.

**Note:** The hook only runs on terminal commands. Claude Code built-in tools like `Read`, `Grep`, and `Glob` do not pass through the hook, so they are not auto-rewritten. Call `rtk-windows read`, `rtk-windows grep`, or `rtk-windows find` directly for those workflows.

## How It Works

```
  Without rtk:                                    With rtk:

  Claude  --git status-->  shell  -->  git         Claude  --git status-->  rtk-windows  -->  git
    ^                                   |            ^                      |          |
    |        ~2,000 tokens (raw)        |            |   ~200 tokens        | filter   |
    +-----------------------------------+            +------- (filtered) ---+----------+
```

Four strategies applied per command type:

1. **Smart Filtering** - Removes noise (comments, whitespace, boilerplate)
2. **Grouping** - Aggregates similar items (files by directory, errors by type)
3. **Truncation** - Keeps relevant context, cuts redundancy
4. **Deduplication** - Collapses repeated log lines with counts

## Commands

### Files
```powershell
rtk-windows ls .                        # Token-optimized directory tree
rtk-windows read file.rs                # Smart file reading
rtk-windows read file.rs -l aggressive  # Signatures only (strips bodies)
rtk-windows smart file.rs               # 2-line heuristic code summary
rtk-windows find "*.rs" .               # Compact find results
rtk-windows grep "pattern" .            # Grouped search results
rtk-windows diff file1 file2            # Condensed diff
```

### Git
```powershell
rtk-windows git status                  # Compact status
rtk-windows git log -n 10               # One-line commits
rtk-windows git diff                    # Condensed diff
rtk-windows git add                     # -> "ok"
rtk-windows git commit -m "msg"         # -> "ok abc1234"
rtk-windows git push                    # -> "ok main"
rtk-windows git pull                    # -> "ok 3 files +10 -2"
```

### GitHub CLI
```powershell
rtk-windows gh pr list                  # Compact PR listing
rtk-windows gh pr view 42               # PR details + checks
rtk-windows gh issue list               # Compact issue listing
rtk-windows gh run list                 # Workflow run status
```

### Test Runners
```powershell
rtk-windows jest                        # Jest compact (failures only)
rtk-windows vitest                      # Vitest compact (failures only)
rtk-windows playwright test             # E2E results (failures only)
rtk-windows pytest                      # Python tests (-90%)
rtk-windows go test                     # Go tests (NDJSON, -90%)
rtk-windows cargo test                  # Cargo tests (-90%)
rtk-windows rake test                   # Ruby minitest (-90%)
rtk-windows rspec                       # RSpec tests (JSON, -60%+)
rtk-windows err <cmd>                   # Filter errors only from any command
rtk-windows test <cmd>                  # Generic test wrapper - failures only (-90%)
```

### Build & Lint
```powershell
rtk-windows lint                        # ESLint grouped by rule/file
rtk-windows lint biome                  # Supports other linters
rtk-windows tsc                         # TypeScript errors grouped by file
rtk-windows next build                  # Next.js build compact
rtk-windows prettier --check .          # Files needing formatting
rtk-windows cargo build                 # Cargo build (-80%)
rtk-windows cargo clippy                # Cargo clippy (-80%)
rtk-windows ruff check                  # Python linting (JSON, -80%)
rtk-windows golangci-lint run           # Go linting (JSON, -85%)
rtk-windows rubocop                     # Ruby linting (JSON, -60%+)
```

### Package Managers
```powershell
rtk-windows pnpm list                   # Compact dependency tree
rtk-windows pip list                    # Python packages (auto-detect uv)
rtk-windows pip outdated                # Outdated packages
rtk-windows bundle install              # Ruby gems (strip Using lines)
rtk-windows prisma generate             # Schema generation (no ASCII art)
```

### AWS
```powershell
rtk-windows aws sts get-caller-identity # One-line identity
rtk-windows aws ec2 describe-instances  # Compact instance list
rtk-windows aws lambda list-functions   # Name/runtime/memory (strips secrets)
rtk-windows aws logs get-log-events     # Timestamped messages only
rtk-windows aws cloudformation describe-stack-events  # Failures first
rtk-windows aws dynamodb scan           # Unwraps type annotations
rtk-windows aws iam list-roles          # Strips policy documents
rtk-windows aws s3 ls                   # Truncated with tee recovery
```

### Containers
```powershell
rtk-windows docker ps                   # Compact container list
rtk-windows docker images               # Compact image list
rtk-windows docker logs <container>     # Deduplicated logs
rtk-windows docker compose ps           # Compose services
rtk-windows kubectl pods                # Compact pod list
rtk-windows kubectl logs <pod>          # Deduplicated logs
rtk-windows kubectl services            # Compact service list
```

### Data & Analytics
```powershell
rtk-windows json config.json            # Structure without values
rtk-windows deps                        # Dependencies summary
rtk-windows env -f AWS                  # Filtered env vars
rtk-windows log app.log                 # Deduplicated logs
rtk-windows curl <url>                  # Truncate + save full output
rtk-windows wget <url>                  # Download, strip progress bars
rtk-windows summary <long command>      # Heuristic summary
rtk-windows proxy <command>             # Raw passthrough + tracking
```

### Token Savings Analytics
```powershell
rtk-windows gain                        # Summary stats
rtk-windows gain --graph                # ASCII graph (last 30 days)
rtk-windows gain --history              # Recent command history
rtk-windows gain --daily                # Day-by-day breakdown
rtk-windows gain --all --format json    # JSON export for dashboards

rtk-windows discover                    # Find missed savings opportunities
rtk-windows discover --all --since 7    # All projects, last 7 days

rtk-windows session                     # Show rtk-windows adoption across recent sessions
```

## Global Flags

```powershell
-u, --ultra-compact    # ASCII icons, inline format (extra token savings)
-v, --verbose          # Increase verbosity (-v, -vv, -vvv)
```

## Examples

**Directory listing:**
```
# ls -la (45 lines, ~800 tokens)        # rtk-windows ls (12 lines, ~150 tokens)
drwxr-xr-x  15 user staff 480 ...       my-project/
-rw-r--r--   1 user staff 1234 ...       +-- src/ (8 files)
...                                      |   +-- main.rs
                                         +-- Cargo.toml
```

**Git operations:**
```
# git push (15 lines, ~200 tokens)       # rtk-windows git push (1 line, ~10 tokens)
Enumerating objects: 5, done.             ok main
Counting objects: 100% (5/5), done.
Delta compression using up to 8 threads
...
```

**Test output:**
```
# cargo test (200+ lines on failure)     # rtk-windows test cargo test (~20 lines)
running 15 tests                          FAILED: 2/15 tests
test utils::test_parse ... ok               test_edge_case: assertion failed
test utils::test_format ... ok              test_overflow: panic at utils.rs:18
...
```

## Auto-Rewrite Hook

The most effective way to use rtk. The hook transparently intercepts terminal commands and rewrites them to rtk-windows equivalents before execution.

**Result**: 100% rtk-windows adoption across all conversations and subagents, zero token overhead.

**Scope note:** this applies to terminal tool calls. Claude Code built-in tools such as `Read`, `Grep`, and `Glob` bypass the hook, so use explicit `rtk-windows` commands when you want rtk-windows filtering there.

### Setup

```powershell
rtk-windows init -g                 # Install hook + RTK.md (recommended)
rtk-windows init -g --opencode      # OpenCode plugin (instead of Claude Code)
rtk-windows init -g --auto-patch    # Non-interactive (CI/CD)
rtk-windows init -g --hook-only     # Hook only, no RTK.md
rtk-windows init --show             # Verify installation
```

After install, **restart Claude Code**.

## Windows

rtk-windows in this fork is Windows-native. Use PowerShell/cmd with native hook commands:

```powershell
# 1. Download and extract rtk-windows-x86_64-pc-windows-msvc.zip from releases
# 2. Add rtk-windows.exe to your PATH
# 3. Initialize
rtk-windows init -g
# 4. Use commands (hook can auto-rewrite in supported agents)
rtk-windows cargo test
rtk-windows git status
```

**Important**: Do not double-click `rtk-windows.exe` — it is a CLI tool that prints usage and exits immediately. Always run it from a terminal (Command Prompt, PowerShell, or Windows Terminal).

| Feature | Native Windows |
|---------|----------------|
| Filters (cargo, git, etc.) | Full |
| Auto-rewrite hook | Full (agent-dependent) |
| `rtk-windows init -g` | Hook mode |
| `rtk-windows gain` / analytics | Full |

## Supported AI Tools

rtk-windows supports 13 AI coding tools. Each integration rewrites shell commands to `rtk-windows` equivalents for 60-90% token savings where the agent supports command interception.

| Tool | Install | Method |
|------|---------|--------|
| **Claude Code** | `rtk-windows init -g` | PreToolUse hook |
| **GitHub Copilot (VS Code)** | `rtk-windows init -g --copilot` | PreToolUse hook — transparent rewrite |
| **GitHub Copilot CLI** | `rtk-windows init -g --copilot` | PreToolUse deny-with-suggestion (CLI limitation) |
| **Cursor** | `rtk-windows init -g --agent cursor` | preToolUse hook (hooks.json) |
| **Gemini CLI** | `rtk-windows init -g --gemini` | BeforeTool hook |
| **Codex** | `rtk-windows init -g --codex` | AGENTS.md + RTK.md instructions |
| **Windsurf** | `rtk-windows init --agent windsurf` | .windsurfrules (project-scoped) |
| **Cline / Roo Code** | `rtk-windows init --agent cline` | .clinerules (project-scoped) |
| **OpenCode** | `rtk-windows init -g --opencode` | Plugin TS (tool.execute.before) |
| **OpenClaw** | `openclaw plugins install ./openclaw` | Plugin TS (before_tool_call) |
| **Hermes** | `rtk-windows init --agent hermes` | Python plugin adapter (terminal command mutation via `rtk-windows rewrite`) |
| **Mistral Vibe** | Planned ([#800](https://github.com/luysantanadev/rtk-windows.git/issues/800)) | Blocked on upstream |
| **Kilo Code** | `rtk-windows init --agent kilocode` | .kilocode/rules/rtk-rules.md (project-scoped) |
| **Google Antigravity** | `rtk-windows init --agent antigravity` | .agents/rules/antigravity-rtk-rules.md (project-scoped) |

For per-agent setup details, override controls, and graceful degradation, see the [Supported Agents guide](https://www.rtk-ai.app/guide/getting-started/supported-agents). The Hermes plugin source and tests live in `hooks/hermes/`; installed Hermes runtime files still live under `~/.hermes/plugins/rtk-rewrite/`.

## Configuration

`%USERPROFILE%/.config/rtk/config.toml`:

```toml
[hooks]
exclude_commands = ["curl", "playwright"]  # skip rewrite for these

[tee]
enabled = true          # save raw output on failure (default: true)
mode = "failures"       # "failures", "always", or "never"
```

When a command fails, rtk-windows saves the full unfiltered output so the LLM can read it without re-executing:

```
FAILED: 2/15 tests
[full output: ~/.local/share/rtk/tee/1707753600_cargo_test.log]
```

For the full config reference (all sections, env vars, per-project filters), see the [Configuration guide](https://www.rtk-ai.app/guide/getting-started/configuration).

### Uninstall

```powershell
rtk-windows init -g --uninstall     # Remove hook, RTK.md, settings.json entry
cargo uninstall rtk-windows          # Remove binary
```

## Documentation

- **[rtk-ai.app/guide](https://www.rtk-ai.app/guide)** — full user guide (installation, supported agents, what gets optimized, analytics, configuration, troubleshooting)
- **[INSTALL.md](INSTALL.md)** — detailed installation reference
- **[ARCHITECTURE.md](docs/contributing/ARCHITECTURE.md)** — system design and technical decisions
- **[CONTRIBUTING.md](CONTRIBUTING.md)** — contribution guide
- **[SECURITY.md](SECURITY.md)** — security policy

## Privacy

rtk-windows does not collect or transmit user usage data to remote services.

## Star History

<a href="https://www.star-history.com/?repos=rtk-ai%2Frtk&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=luysantanadev/rtk-windows&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=luysantanadev/rtk-windows&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=luysantanadev/rtk-windows&type=date&legend=top-left" />
 </picture>
</a>

## StarMapper

<a href="https://starmapper.bruniaux.com/luysantanadev/rtk-windows">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://starmapper.bruniaux.com/api/map-image/luysantanadev/rtk-windows?theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://starmapper.bruniaux.com/api/map-image/luysantanadev/rtk-windows?theme=light" />
    <img alt="StarMapper" src="https://starmapper.bruniaux.com/api/map-image/luysantanadev/rtk-windows" />
  </picture>
</a>

## Core team

- **Patrick Szymkowiak** — Founder
  [GitHub](https://github.com/pszymkowiak) · [LinkedIn](https://www.linkedin.com/in/patrick-szymkowiak/)
- **Florian Bruniaux** — Core contributor
  [GitHub](https://github.com/FlorianBruniaux) · [LinkedIn](https://www.linkedin.com/in/florian-bruniaux-43408b83/)
- **Adrien Eppling** — Core contributor
  [GitHub](https://github.com/aeppling) · [LinkedIn](https://www.linkedin.com/in/adrien-eppling/)

## Contributing

Contributions welcome! Please open an issue or PR on [GitHub](https://github.com/luysantanadev/rtk-windows.git).

Join the community on [Discord]().

## License

MIT License - see [LICENSE](LICENSE) for details.

## Disclaimer

See [DISCLAIMER.md](DISCLAIMER.md).


