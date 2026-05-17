# OpenCode Hooks

> Part of [`hooks/`](../README.md) — see also [`src/hooks/`](../../src/hooks/README.md) for installation code

## Specifics

- TypeScript plugin using the zx library (not a shell hook)
- Intercepts `tool.execute.before` events (bash/shell/powershell/pwsh), calls `rtk-windows rewrite` as a subprocess
- Uses `.quiet().nothrow()` to silently ignore failures
- Mutates `args.command` in-place if rewrite differs from original
- Installed to `~/.config/opencode/plugins/rtk.ts` by `rtk-windows init -g --opencode`

## Lifecycle and Constraints

- Installation is global-only: `rtk-windows init --opencode` without `-g` is rejected.
- OpenCode mode cannot be combined with Codex mode (`--codex`).
- Re-running `rtk-windows init -g --opencode` is idempotent: plugin content is only updated when embedded content changes.
- `rtk-windows init --show` reports OpenCode plugin status as installed/not found.

## Rewrite Contract

- Delegates rewrite decisions to `rtk-windows rewrite` (single source of truth in Rust registry).
- Supports command chains and passthrough exactly as `rtk-windows rewrite` returns.
- Fails open: if `rtk-windows` is missing or rewrite fails, the original command runs unchanged.

## PowerShell Core Example

```powershell
rtk-windows init -g --opencode
rtk-windows init --show
```
