# Cline / Roo Code (Windows/PowerShell)

> Part of [`hooks/`](../README.md) — see also [`src/hooks/`](../../src/hooks/README.md) for installation code

## Overview

RTK integration for Cline and Roo Code on Windows uses prompt-level guidance (no programmatic hook).

- Relies on Cline reading custom instructions from `.clinerules`
- Instructions guide Cline to prefix commands with `rtk-windows` instead of running them raw
- Installation creates `.clinerules` file in your project root

## Installation (Windows)

**Per-project:**
```powershell
rtk-windows init --cline
```

Creates `.clinerules` file (project-local) with RTK usage guidance.

This integration is **per-project** — you need to run this in each workspace where you use Cline.

## Behavior (Windows)

| Capability | Status | Notes |
|------------|--------|-------|
| Guidance type | Prompt-level | No programmatic hook |
| Scope | Per-project | `.clinerules` is local to workspace |
| Rewrite type | Suggestion-based | Cline chooses whether to follow guidance |
| Supported commands | All RTK filters | Cline can use any `rtk-windows` command |

Cline will see instructions to prefer `rtk-windows <cmd>` over raw commands. The model typically follows this guidance, resulting in token savings.

## Using with Cline (Windows)

After running `rtk-windows init --cline`, Cline will see guidance like:

```
When executing shell commands or running tools, prefer using `rtk-windows` prefix
for any supported commands to save tokens:

rtk-windows cargo test
rtk-windows git status
rtk-windows pnpm install
```

Cline will prioritize using RTK-prefixed commands for better token efficiency.

## Troubleshooting

**Cline not using RTK commands:**

Verify `.clinerules` exists in your project:
```powershell
Get-Content .clinerules    # check if RTK instructions are present
```

Reinstall if missing:
```powershell
rtk-windows init --cline
```

**Commands not being optimized:**

Cline may choose not to follow all guidance. This is normal — the model makes independent decisions. You can also manually prefix commands with `rtk-windows` to ensure optimization.

## Configuration

To customize RTK guidance per-project, edit `.clinerules` directly and add your own usage preferences alongside RTK instructions.
