# RTK Plugin for Hermes (Windows/PowerShell)

RTK plugin for Hermes AI agent rewrites terminal commands to RTK equivalents before execution, compressing output without changing your workflow.

## Installation (Windows)

```powershell
rtk-windows init -g --hermes
```

The installer writes the plugin to:
- `$env:APPDATA\Hermes\plugins\rtk-rewrite\` (global)
- Or project-local: `.hermes\plugins\rtk-rewrite\` (if inside a project)

Plugin is enabled through `plugins.enabled` in the Hermes configuration.

Restart Hermes after installation.

## How It Works (Windows)

1. Hermes loads the RTK plugin from Python
2. Python plugin adapter intercepts Hermes `terminal` tool calls
3. Plugin calls `rtk-windows rewrite` command to decide if rewrite applies
4. Plugin updates the command payload before Hermes executes it
5. Hermes runs the optimized command and receives compressed output

All rewrite logic stays in Rust (`rtk-windows rewrite`). When RTK adds new filters, Hermes automatically uses them — no plugin update needed.

## Fail-open Behavior (Windows)

The plugin does not block command execution. If anything fails, Hermes runs the original command unchanged.

Conditions that skip rewriting:

| Condition | Behavior |
|-----------|----------|
| `rtk-windows` not in PATH | Warning logged, hook skipped |
| `rtk rewrite` command fails | Original command runs |
| Non-terminal tool called | Unchanged (plugin only handles `terminal`) |
| No `command` field in payload | Unchanged |
| Command has no RTK filter | Unchanged (passes through) |
| Plugin exception | Original command runs, warning logged |

## Configuration (Windows)

Edit Hermes configuration file:

```powershell
# Global: $env:APPDATA\Hermes\config.yaml
# Or: .hermes\config.yaml (project-local)

plugins:
  enabled:
    - rtk-rewrite
```

## Troubleshooting (Windows)

**Plugin not loading:**

Verify RTK is in PATH:
```powershell
rtk-windows --version    # should print version
which rtk-windows        # verify location in PATH
```

Verify Hermes plugin directory exists:
```powershell
Get-ChildItem $env:APPDATA\Hermes\plugins\rtk-rewrite\
```

**Commands not being rewritten:**

Check if RTK recognizes the command:
```powershell
rtk-windows rewrite cargo test    # test if this command would be rewritten
rtk-windows proxy cargo test      # see what RTK would do
```

Verify Hermes `plugins.enabled` includes `rtk-rewrite`.

## Windows-specific Notes

- Plugin works with PowerShell Core and Command Prompt
- All paths use Windows conventions: `$env:APPDATA\...`
- Environment variables: `$env:VARIABLE` format
- Backslash path separators throughout
