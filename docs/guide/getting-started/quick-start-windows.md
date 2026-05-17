---
title: Quick Start (Windows/PowerShell)
description: Get RTK running in 5 minutes on Windows and see your first token savings
sidebar:
  order: 2
---

# Quick Start (Windows)

This guide walks you through your first RTK commands after installation on Windows.

## Prerequisites

RTK is installed and verified:

```powershell
rtk-windows --version   # rtk-windows x.y.z
rtk-windows gain        # shows token savings dashboard
```

If not, see [Installation](./installation.md).

## Step 1: Initialize for your AI assistant

```powershell
# For VS Code Copilot (global — applies to all projects)
rtk-windows init -g --copilot

# For Cursor
rtk-windows init -g --cursor

# For a single project only (e.g., Cline)
cd C:\your\project; rtk-windows init --cline
```

This installs the hook that automatically rewrites commands. Restart your AI assistant after this step.

### Preview without writing: `--dry-run`

To see exactly what `init` would change before it touches anything, add `--dry-run`:

```powershell
rtk-windows init -g --copilot --dry-run
```

Every would-be file create/update/patch is printed with a `[dry-run] would ...` prefix, then a `[dry-run] Nothing written.` footer. Nothing on disk is modified and no settings.json is patched. Combine with `-v` to also print the full content RTK would write:

```powershell
rtk-windows init -g --copilot --dry-run -v
```

`--dry-run` works for every init flavour (`--agent cursor`, `--copilot`, `--cline`, `--opencode`, `--hermes`, `--uninstall`, ...). It cannot be combined with `--show`.

## Step 2: Use your tools normally

Once the hook is installed, nothing changes in how you work. Your AI assistant runs commands as usual — the hook intercepts them transparently and rewrites them before execution.

For example, when Copilot Chat runs `cargo test`, the hook rewrites it to `rtk-windows cargo test` before it executes. The LLM receives filtered output with only the failures — not 500 lines of passing tests. You never see or type `rtk-windows`.

RTK covers all major Windows ecosystems — Git, Cargo/Rust, JavaScript, Python, Go, Ruby, .NET, Docker/Kubernetes, and more. See [What RTK Optimizes](../resources/what-rtk-covers.md) for the full list.

## Step 3: Check your savings

After a few commands, see how much was saved:

```powershell
rtk-windows gain
```

```
Total commands : 12
Input tokens   : 45,230
Output tokens  : 4,890
Saved          : 40,340  (89.2%)
```

## Step 4: Unsupported commands

Commands RTK doesn't recognize run through passthrough — output is unchanged, usage is tracked:

```powershell
rtk-windows proxy make install
```

## Supported agents on Windows

RTK on Windows supports these AI assistants:

1. **VS Code Copilot Chat** — Full transparent rewrite
2. **GitHub Copilot CLI** — Deny-with-suggestion (retries work)
3. **Cursor** — Full transparent rewrite
4. **Cline / Roo Code** — Prompt-level guidance
5. **OpenCode** — TypeScript plugin  
6. **Hermes** — Python plugin

See [Supported agents](./supported-agents.md) for detailed integration instructions.

## Next steps

- [What RTK Optimizes](../resources/what-rtk-covers.md) — all supported commands and savings by ecosystem
- [Supported agents](./supported-agents.md) — Windows agents only
- [Configuration](./configuration.md) — customize RTK behavior

## Windows-specific notes

- All paths use backslash: `$env:USERPROFILE\bin` instead of `$HOME/bin`
- Environment variables: `$env:VARIABLENAME` instead of `$VARIABLENAME`
- PowerShell Core 7+ recommended for best compatibility
- Works with both Command Prompt and PowerShell
