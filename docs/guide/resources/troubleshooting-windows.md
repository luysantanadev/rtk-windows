---
title: Troubleshooting (Windows)
description: Common RTK Windows issues and solutions
sidebar:
  order: 2
---

# Troubleshooting (Windows)

## Installation Issues

### `rtk-windows` not recognized as command

**Symptom:**
```powershell
PS> rtk-windows --version
rtk-windows: The term 'rtk-windows' is not recognized
```

**Cause:** RTK binary is not in your PowerShell PATH.

**Solution:**

1. Verify installation location:
   ```powershell
   Get-Command rtk-windows
   ```

2. If not found, reinstall:
   ```powershell
   cargo install --git https://github.com/luysantanadev/rtk-windows.git --force
   ```

3. Restart PowerShell or reload your profile:
   ```powershell
   . $PROFILE    # reload PowerShell profile
   rtk-windows --version
   ```

### `rtk gain` says "not a rtk command"

**Symptom:**
```powershell
PS> rtk-windows gain
rtk: 'gain' is not a rtk command. See 'rtk --help'.
```

**Cause:** You installed wrong package. You have **Rust Type Kit** instead of **Rust Token Killer**.

**How to tell which you have:**

```powershell
# Correct (Rust Token Killer):
PS> rtk-windows gain
Token Savings Dashboard
...

# Wrong (Rust Type Kit):
PS> rtk
rtk: 'gain' is not a rtk command
```

**Fix:**
```powershell
cargo uninstall rtk rtk-windows
cargo install --git https://github.com/luysantanadev/rtk-windows.git --force
rtk-windows --version
rtk-windows gain    # should work now
```

## Runtime Issues

### Agent integration not working

**Symptom:** VS Code Copilot Chat runs commands directly instead of using RTK.

**Checklist:**

1. **Verify RTK is installed:**
   ```powershell
   rtk-windows --version
   rtk-windows gain    # shows token savings
   ```

2. **Initialize hook:**
   ```powershell
   rtk-windows init -g --copilot    # For VS Code Copilot Chat
   rtk-windows init -g --cursor      # For Cursor
   rtk-windows init -g --cline       # For Cline
   rtk-windows init -g --opencode    # For OpenCode
   rtk-windows init -g --hermes      # For Hermes
   ```

3. **Restart your AI editor:**
   - VS Code: Reload window (`Ctrl+Shift+P` → "Reload Window")
   - Cursor: Restart application
   - Cline: Restart or reload workspace

4. **Verify hook status:**
   ```powershell
   rtk-windows init --show    # shows which hooks are installed
   ```

5. **Check settings.json (VS Code Copilot Chat):**
   ```powershell
   $configPath = "$env:APPDATA\GitHub Copilot\settings.json"
   Get-Content $configPath | Select-String -Pattern rtk
   ```

### Hook registration failed

**Symptom:**
```powershell
PS> rtk-windows init -g --copilot
Error: Failed to update settings.json
```

**Cause:** Settings file is locked or permission issue.

**Fix:**

1. Ensure VS Code / Copilot Chat is closed
2. Try again:
   ```powershell
   rtk-windows init -g --copilot
   ```

3. Restart VS Code

4. Manually verify settings file was updated:
   ```powershell
   Get-Content "$env:APPDATA\GitHub Copilot\settings.json" | ConvertFrom-Json
   ```

### Command not found errors

**Symptom:**
```
rtk cargo test
Error: program "cargo" not found
```

**Cause:** The underlying command (cargo, git, npm, etc.) is not in your PATH.

**Solution:**

1. Verify the command works directly:
   ```powershell
   cargo --version    # should return version
   ```

2. If not found, install the tool or add to PATH

3. Test RTK again:
   ```powershell
   rtk-windows cargo test
   ```

### Node.js tools not found

**Symptom:**
```
rtk-windows npm install
Error: program not found
```

**Cause:** Node.js path not configured in PowerShell PATH.

**Fix:**

1. Verify npm works directly:
   ```powershell
   npm --version
   ```

2. If not found, install Node.js from https://nodejs.org/

3. Restart PowerShell or reload profile:
   ```powershell
   . $PROFILE
   rtk-windows npm install
   ```

### Python tools not found

**Symptom:**
```
rtk-windows pytest
Error: program not found
```

**Cause:** Python not in PATH or not installed.

**Fix:**

1. Verify python works:
   ```powershell
   python --version
   ```

2. If not found, install Python from https://python.org/

3. Add Python to PATH if needed:
   ```powershell
   $env:PATH += ";C:\Python311"    # Adjust version number
   ```

4. Test again:
   ```powershell
   rtk-windows pytest
   ```

## Configuration Issues

### Configuration file location

**Windows configuration path:**
```powershell
$env:APPDATA\rtk\config.toml
```

**View or edit configuration:**
```powershell
# Show current config
rtk-windows config

# Create default config
rtk-windows config --create

# Edit in your editor
code "$env:APPDATA\rtk\config.toml"
```

### Disabling telemetry

**Temporary (current session):**
```powershell
$env:RTK_TELEMETRY_DISABLED=1
rtk-windows gain
```

**Permanent (via config.toml):**
```powershell
# Edit: $env:APPDATA\rtk\config.toml
[telemetry]
enabled = false
```

### Disabling RTK for specific commands

**Single command:**
```powershell
$env:RTK_DISABLED=1; cargo test; $env:RTK_DISABLED=$null
```

**Configuration file:**
```toml
# $env:APPDATA\rtk\config.toml
[hooks]
exclude_commands = ["git rebase", "docker exec", "cargo install"]
```

## PowerShell $PROFILE Integration

### Issue: Commands not recognized after `init`

**Symptom:** After `rtk-windows init`, commands still work but RTK hook not active.

**Cause:** PowerShell $PROFILE not loaded or updated.

**Solution:**

1. Check if $PROFILE exists:
   ```powershell
   Test-Path $PROFILE
   ```

2. If missing, create it:
   ```powershell
   New-Item -Path $PROFILE -Type File -Force
   ```

3. Reload profile:
   ```powershell
   . $PROFILE
   ```

4. Verify RTK hook is in profile:
   ```powershell
   Get-Content $PROFILE | Select-String rtk
   ```

### PowerShell Core vs Windows PowerShell

**Recommended:** Use PowerShell Core (v7+):
```powershell
# Check version
$PSVersionTable.PSVersion

# Install PowerShell Core: https://github.com/PowerShell/PowerShell/releases
```

PowerShell Core 7+ supports all RTK features and is recommended for best compatibility.

## Diagnostic Script

Run the diagnostic script to check your setup:

```powershell
pwsh ./scripts/check-installation.ps1
```

**Checks:**
- RTK binary installed and in PATH
- Correct version (Token Killer, not Type Kit)
- Hook status for each agent
- Telemetry configuration
- PATH environment variable

## Still Stuck?

If you've tried the above and still having issues:

1. Collect debug info:
   ```powershell
   rtk-windows --version
   rtk-windows init --show
   $PSVersionTable.PSVersion
   Get-Command rtk-windows | Format-List
   ```

2. Open an issue with this info: https://github.com/luysantanadev/rtk-windows.git/issues

3. Include:
   - PowerShell version (output of `$PSVersionTable.PSVersion`)
   - RTK version (output of `rtk-windows --version`)
   - Windows version (output of `[System.Environment]::OSVersion`)
   - Hook initialization output
   - Error messages (copy-paste exact text)
