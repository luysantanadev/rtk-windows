# VS Code Copilot Chat & Copilot CLI (Windows/PowerShell)

> Part of [`hooks/`](../README.md) — see also [`src/hooks/`](../../src/hooks/README.md) for installation code

## Overview

RTK provides full transparent rewrite support for VS Code Copilot Chat and GitHub Copilot CLI on Windows.

- Uses the `rtk-windows hook copilot` Rust binary (native Windows, no dependencies)
- Detects two input formats: VS Code Copilot Chat (snake_case) and Copilot CLI (camelCase with JSON args)
- VS Code Copilot Chat: Returns `updatedInput` for transparent rewrite
- Copilot CLI: Returns `permissionDecision: "deny"` with suggestion (CLI API doesn't support `updatedInput`, so user retries)

## Installation (Windows)

**Global (recommended — applies to all VS Code projects):**
```powershell
rtk-windows init -g --copilot
```

**Project-scoped (single workspace):**
```powershell
rtk-windows init --copilot
```

Copilot hook registers in `settings.json`:
- Global: `$env:APPDATA\GitHub Copilot\settings.json`
- Project: `.vscode/settings.json` (workspace)

Restart VS Code after installation.

## Behavior (Windows)

| Agent | Integration Type | Transparent Rewrite | Notes |
|-------|------------------|-------------------|-------|
| **VS Code Copilot Chat** | Native Rust hook | ✅ Yes | Full command rewrite |
| **GitHub Copilot CLI** | Native Rust hook | ⚠️ Deny-with-suggestion | API limitation (no `updatedInput` support) |

**Copilot CLI behavior:** When Copilot CLI runs a command, RTK hook returns `deny` with a suggestion to retry with `rtk-windows` prefix. The user sees the suggestion and can accept it to execute the optimized command.

## Testing (Windows)

```powershell
cargo test test_copilot
```

Rust test suite validates both VS Code Copilot Chat and Copilot CLI message formats and checks rewrite behavior on Windows.

## Troubleshooting

**Hook not working in VS Code Copilot Chat:**
```powershell
rtk-windows init --show    # verify hook is registered
```

If not registered, restart VS Code and re-run `rtk-windows init -g --copilot`.

**Copilot CLI returns "permission denied":**

This is expected behavior. Copilot CLI shows the RTK suggestion, which you can accept to retry with the optimized command. RTK cannot provide transparent rewrite like VS Code because the CLI API doesn't support updating the command before execution.
