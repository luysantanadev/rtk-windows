# GitHub Copilot Hooks

> Part of [`hooks/`](../README.md) — see also [`src/hooks/`](../../src/hooks/README.md) for installation code

## Specifics

- Uses the `rtk hook copilot` Rust binary (not a shell script) -- no `jq` dependency
- Auto-detects two input formats: VS Code Copilot Chat (snake_case `tool_name`/`tool_input`) and Copilot CLI (camelCase `toolName`/`toolArgs` with JSON-stringified args)
- VS Code format: returns `updatedInput` for transparent rewrite
- Copilot CLI format: returns `permissionDecision: "deny"` with suggestion (Copilot CLI API doesn't support `updatedInput`)

## Windows Support

Copilot hook is fully **native Windows compatible**. Uses the `rtk hook copilot` Rust binary — no shell script dependency.

### Installation

**Global (recommended):**
```powershell
rtk init -g --copilot
```

**Project-scoped:**
```powershell
rtk init --copilot
```

Copilot hook registers in `settings.json` (`~/.config/GitHub Copilot/settings.json` or workspace `.vscode/settings.json`).

### Behavior

| OS | Shell | VS Code Copilot Chat | Copilot CLI |
|----|-------|---------------------|-------------|
| Windows (native) | PowerShell/cmd.exe | ✅ Transparent rewrite | ⚠️ Deny-with-suggestion (API limitation) |
| Windows (WSL) | bash | ✅ Transparent rewrite | ⚠️ Deny-with-suggestion (API limitation) |
| macOS | zsh/bash | ✅ Transparent rewrite | ⚠️ Deny-with-suggestion (API limitation) |
| Linux | bash | ✅ Transparent rewrite | ⚠️ Deny-with-suggestion (API limitation) |

**Note:** Copilot CLI returns `permissionDecision: "deny"` with an RTK suggestion because the Copilot CLI API does not support `updatedInput`. The CLI will show the suggestion and the user can retry with the suggested command.

## Testing

### Bash (legacy)
```bash
bash hooks/test-copilot-rtk-rewrite.sh
```

### Rust (current)
```bash
cargo test test_copilot
```

Rust test suite validates both VS Code Copilot Chat and Copilot CLI formats, and checks rewrite parity across Windows/macOS/Linux.
