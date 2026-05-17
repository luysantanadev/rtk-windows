# Cursor IDE (Windows/PowerShell)

> Part of [`hooks/`](../README.md) — see also [`src/hooks/`](../../src/hooks/README.md) for installation code

## Overview

RTK provides full transparent rewrite support for Cursor IDE on Windows.

- Uses `rtk-windows hook cursor` Rust binary (native Windows, no dependencies)
- Transparent command rewriting via PreToolUse event
- Returns updated command before Cursor sees it

## Installation (Windows)

**Global (recommended — applies to all Cursor projects):**
```powershell
rtk-windows init -g --cursor
```

**Project-scoped (single workspace):**
```powershell
rtk-windows init --cursor
```

Cursor hook registers in `.cursor/settings.json` or `$env:APPDATA\Cursor\settings.json`.

Restart Cursor after installation.

## Behavior (Windows)

| Capability | Status | Notes |
|------------|--------|-------|
| Transparent rewrite | ✅ Full support | Commands rewritten before Cursor sees them |
| Return format | JSON | Cursor requires valid JSON response |
| Empty response | Handled | Returns `{}` when no filter applies |

## Testing (Windows)

```powershell
cargo test test_cursor
```

Rust test suite validates Cursor message format and rewrite behavior on Windows.

## Troubleshooting

**Hook not activating in Cursor:**
```powershell
rtk-windows init --show    # verify hook is registered
```

If not registered, restart Cursor and re-run `rtk-windows init -g --cursor`.

**Command not being rewritten:**

Check if RTK recognizes the command:
```powershell
rtk-windows proxy <your-command>    # test if RTK would filter this command
```

If RTK returns the output unchanged, no filter exists for that command.
