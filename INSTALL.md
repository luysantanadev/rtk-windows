# rtk-windows Installation Guide - For AI Coding Assistants

## ⚠️ Name Collision Warning

**There are TWO completely different projects named "rtk":**

1. ✅ **Rust Token Killer** (this project) - LLM token optimizer
   - Repos: `https://github.com/luysantanadev/rtk-windows.git`
   - Has `rtk-windows gain` command for token savings stats

2. ❌ **Rust Type Kit** (reachingforthejack/rtk) - DIFFERENT PROJECT
   - Rust codebase query tool and type generator
   - **DO NOT install if you want token optimization**

## Pre-Installation Check (REQUIRED)

**AI assistants should ALWAYS verify if rtk-windows is already installed before attempting installation.**

```powershell
# Check if rtk-windows is installed
rtk-windows --version

# CRITICAL: Verify it's the Token Killer (not Type Kit)
rtk-windows gain    # Should show token savings stats, NOT "command not found"

# Check installation path
Get-Command rtk-windows
```

If `rtk-windows gain` works, you have the correct fork installed. Do not reinstall. Skip to "Project Initialization".

If `rtk-windows gain` fails but `rtk-windows --version` succeeds, you likely installed the wrong project from crates.io. Uninstall and reinstall from this fork.

## Installation (only if rtk-windows not available or wrong rtk-windows installed)

### Step 0: Uninstall Wrong rtk-windows (if needed)

If you accidentally installed Rust Type Kit:

```powershell
cargo uninstall rtk-windows
```

### Windows Binary (recommended)

Download `rtk-windows-x86_64-pc-windows-msvc.zip` from [GitHub releases](https://github.com/luysantanadev/rtk-windows.git/releases), extract `rtk-windows.exe`, and place it in your PATH.

### Alternative: Build from source (Windows)

> **Note**: This fork is Windows-only.

```powershell
# Windows (PowerShell)
cargo install --git https://github.com/luysantanadev/rtk-windows.git
```

```powershell
# Build from local source
cargo install --path .
```

After installation, verify you have the correct binary:
```powershell
rtk-windows gain  # Must show token savings stats (not "command not found")
```

⚠️ **WARNING**: `cargo install rtk` from crates.io might install the wrong package. Always verify with `rtk-windows gain`.

## Project Initialization

### Which mode to choose?

```
  Do you want rtk-windows active across ALL Claude Code projects?
  │
  ├─ YES → rtk-windows init -g              (recommended)
  │         Hook + RTK.md (~10 tokens in context)
  │         Commands auto-rewritten transparently
  │
  ├─ YES, minimal → rtk-windows init -g --hook-only
  │         Hook only, nothing added to CLAUDE.md
  │         Zero tokens in context
  │
  └─ NO, single project → rtk-windows init
            Local CLAUDE.md only (137 lines)
            No hook, no global effect
```

### Recommended: Global Hook-First Setup

**Best for: All projects, automatic rtk-windows usage**

**Prerequisite:** Use PowerShell Core (`pwsh`) for repository scripts and maintenance commands.

```powershell
rtk-windows init -g
# → Installs hook to $env:USERPROFILE\.claude\hooks\rtk-rewrite.json
# → Creates $env:USERPROFILE\.claude\RTK.md (10 lines, meta commands only)
# → Adds @RTK.md reference to $env:USERPROFILE\.claude\CLAUDE.md
# → Prompts: "Patch settings.json? [y/N]"
# → If yes: patches + creates backup ($env:USERPROFILE\.claude\settings.json.bak)

# Automated alternatives:
rtk-windows init -g --auto-patch    # Patch without prompting
rtk-windows init -g --no-patch      # Print manual instructions instead

# Verify installation
rtk-windows init --show  # Check hook is installed and executable
```

**Token savings**: ~99.5% reduction (2000 tokens → 10 tokens in context)

**What is settings.json?**
Claude Code's hook registry. rtk-windows adds a PreToolUse hook that rewrites commands transparently. Without this, Claude won't invoke the hook automatically.

```
   Claude Code          settings.json        rtk-rewrite.json      rtk-windows binary
       │                    │                     │                    │
       │  "git status"      │                     │                    │
       │ ──────────────────►│                     │                    │
       │                    │  PreToolUse trigger  │                    │
       │                    │ ───────────────────►│                    │
       │                    │                     │  rewrite command   │
       │                    │                     │  → rtk-windows git status  │
       │                    │◄────────────────────│                    │
       │                    │  updated command     │                    │
       │                    │                                          │
       │  execute: rtk-windows git status                                      │
       │ ─────────────────────────────────────────────────────────────►│
       │                                                               │  filter
       │  "3 modified, 1 untracked ✓"                                  │
       │◄──────────────────────────────────────────────────────────────│
```

**Backup Safety**:
rtk-windows backs up existing settings.json before changes. Restore if needed:
```powershell
Copy-Item "$HOME/.claude/settings.json.bak" "$HOME/.claude/settings.json" -Force
```

### Alternative: Local Project Setup

**Best for: Single project without hook**

```powershell
Set-Location C:\path\to\your\project
rtk-windows init  # Creates ./CLAUDE.md with full rtk-windows instructions (137 lines)
```

**Token savings**: Instructions loaded only for this project

### Upgrading from Previous Version

#### From old 137-line CLAUDE.md injection (pre-0.22)

```powershell
rtk-windows init -g  # Automatically migrates to hook-first mode
# → Removes old 137-line block
# → Installs hook + RTK.md
# → Adds @RTK.md reference
```

#### From old hook with inline logic (pre-0.24) — ⚠️ Breaking Change

rtk-windows 0.24.0 replaced the inline command-detection hook (~200 lines) with a **thin delegator** that calls `rtk-windows rewrite`. The binary now contains the rewrite logic, so adding new commands no longer requires a hook update.

The old hook still works but won't benefit from new rules added in future releases.

```powershell
# Upgrade hook to thin delegator
rtk-windows init --global

# Verify the new hook is active
rtk-windows init --show
# Should show: ✅ Hook: ... (thin delegator, up to date)
```

## Common User Flows

### First-Time User (Recommended)
```powershell
# 1. Install rtk-windows
cargo install --git https://github.com/luysantanadev/rtk-windows.git
rtk-windows gain  # Verify (must show token stats)

# 2. Setup with prompts
rtk-windows init -g
# → Answer 'y' when prompted to patch settings.json
# → Creates backup automatically

# 3. Restart Claude Code
# 4. Test: git status (should use rtk-windows)
```

### CI/CD or Automation
```powershell
# Non-interactive setup (no prompts)
rtk-windows init -g --auto-patch

# Verify in scripts
rtk-windows init --show | Select-String "Hook:"
```

### Conservative User (Manual Control)
```powershell
# Get manual instructions without patching
rtk-windows init -g --no-patch

# Review printed JSON snippet
# Manually edit $env:USERPROFILE\.claude\settings.json
# Restart Claude Code
```

### Temporary Trial
```powershell
# Install hook
rtk-windows init -g --auto-patch

# Later: remove everything
rtk-windows init -g --uninstall

# Restore backup if needed
Copy-Item "$HOME/.claude/settings.json.bak" "$HOME/.claude/settings.json" -Force
```

## Installation Verification

```powershell
# Basic test
rtk-windows ls .

# Test with git
rtk-windows git status

# Test with pnpm
rtk-windows pnpm list

# Test with Vitest
rtk-windows vitest
```

## Uninstalling

### Complete Removal (Global Installations Only)

```powershell
# Complete removal (global installations only)
rtk-windows init -g --uninstall

# What gets removed:
#   - Hook: $env:USERPROFILE\.claude\hooks\rtk-rewrite.json
#   - Context: $env:USERPROFILE\.claude\RTK.md
#   - Reference: @RTK.md line from $env:USERPROFILE\.claude\CLAUDE.md
#   - Registration: rtk-windows hook entry from settings.json

# Restart Claude Code after uninstall
```

**For Local Projects**: Manually remove rtk-windows block from `./CLAUDE.md`

### Binary Removal

```powershell
# If installed via cargo
cargo uninstall rtk-windows
```

### Restore from Backup (if needed)

```powershell
Copy-Item "$HOME/.claude/settings.json.bak" "$HOME/.claude/settings.json" -Force
```

## Essential Commands

### Files
```powershell
rtk-windows ls .              # Compact tree view
rtk-windows read file.rs      # Optimized reading
rtk-windows grep "pattern" .  # Grouped search results
```

### Git
```powershell
rtk-windows git status        # Compact status
rtk-windows git log -n 10     # Condensed logs
rtk-windows git diff          # Optimized diff
rtk-windows git add .         # → "ok ✓"
rtk-windows git commit -m "msg"  # → "ok ✓ abc1234"
rtk-windows git push          # → "ok ✓ main"
```

### Pnpm (fork only)
```powershell
rtk-windows pnpm list     # Dependency tree (-70% tokens)
rtk-windows pnpm outdated # Available updates (-80-90%)
rtk-windows pnpm install  # Silent installation
```

### Tests
```powershell
rtk-windows cargo test      # Filtered Cargo test output (-90%)
rtk-windows go test         # Filtered Go tests (NDJSON, -90%)
rtk-windows jest            # Filtered Jest output (-99.6%)
rtk-windows vitest          # Filtered Vitest output (-99.6%)
rtk-windows playwright test # Filtered Playwright output (-94%)
rtk-windows pytest          # Filtered Python tests (-90%)
rtk-windows rake test       # Filtered Ruby tests (-90%)
rtk-windows rspec           # Filtered RSpec tests (-60%)
rtk-windows test <cmd>      # Generic test wrapper - failures only (-90%)
```

### Statistics
```powershell
rtk-windows gain              # Token savings
rtk-windows gain --graph      # With ASCII graph
rtk-windows gain --history    # With command history
```

## Validated Token Savings

### Production T3 Stack Project
| Operation | Standard | rtk-windows | Reduction |
|-----------|----------|-----|-----------|
| `vitest` | 102,199 chars | 377 chars | **-99.6%** |
| `git status` | 529 chars | 217 chars | **-59%** |
| `pnpm list` | ~8,000 tokens | ~2,400 | **-70%** |
| `pnpm outdated` | ~12,000 tokens | ~1,200-2,400 | **-80-90%** |

### Typical Claude Code Session (30 min)
- **Without RTK**: ~150,000 tokens
- **With RTK**: ~45,000 tokens
- **Savings**: **70% reduction**

## Troubleshooting

### rtk-windows command not found after installation
```powershell
# Check PATH
$env:Path -split ';' | Select-String '\\.cargo\\bin'

# Add Cargo bin path for current user if needed
[Environment]::SetEnvironmentVariable(
   "Path",
   $env:Path + ";$HOME\\.cargo\\bin",
   "User"
)
```

### rtk-windows command not available (e.g., vitest)
```powershell
# Check branch
cd /path/to/rtk-windows
git branch

# Switch to feat/vitest-support if needed
git checkout feat/vitest-support

# Reinstall
cargo install --path . --force
```

### Compilation error
```powershell
# Update Rust
rustup update stable

# Clean and recompile
cargo clean
cargo build --release
cargo install --path . --force
```

## Support and Contributing

- **GitHub issues**: https://github.com/luysantanadev/rtk-windows.git/issues
- **Pull Requests**: https://github.com/luysantanadev/rtk-windows.git/pulls
- **Troubleshooting**: See [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for common issues

⚠️ **If you installed the wrong rtk-windows (Type Kit)**, see [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md#problem-rtk-gain-command-not-found)

## AI Assistant Checklist

Before each session:

- [ ] Verify rtk-windows is installed: `rtk-windows --version`
- [ ] If not installed → follow "Install from fork"
- [ ] If project not initialized → `rtk-windows init`
- [ ] Use `rtk-windows` for ALL git/pnpm/test/vitest commands
- [ ] Check savings: `rtk-windows gain`

**Golden Rule**: AI coding assistants should ALWAYS use `rtk-windows` as a proxy for shell commands that generate verbose output (git, pnpm, npm, cargo test, vitest, docker, kubectl).

