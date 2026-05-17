---
title: Troubleshooting
description: Common RTK issues and how to fix them
sidebar:
  order: 2
---

# Troubleshooting

## `rtk gain` says "not a rtk command"

**Symptom:**
```bash
$ rtk gain
rtk: 'gain' is not a rtk command. See 'rtk --help'.
```

**Cause:** You installed **Rust Type Kit** (`reachingforthejack/rtk`) instead of **Rust Token Killer** (`https://github.com/luysantanadev/rtk-windows.git`). They share the same binary name.

**Fix:**
```powershell
cargo uninstall rtk
cargo install --git https://github.com/luysantanadev/rtk-windows.git --force
rtk gain    # should now show token savings stats
```

## How to tell which rtk you have

| If `rtk gain`... | You have |
|------------------|----------|
| Shows token savings dashboard | Rust Token Killer ✅ |
| Returns "not a rtk command" | Rust Type Kit ❌ |

## AI assistant not using RTK

**Symptom:** Claude Code (or another agent) runs `cargo test` instead of `rtk cargo test`.

**Checklist:**

1. Verify RTK is installed:
   ```bash
   rtk --version
   rtk gain
   ```

2. Initialize the hook:
   ```bash
   rtk init -g    # Claude Code
   rtk init -g --cursor    # Cursor
   rtk-windows init -g --opencode  # OpenCode
   ```

3. Restart your AI assistant.

4. Verify hook status:
   ```bash
   rtk init --show
   ```

5. Check `settings.json` has the hook registered (Claude Code):
   ```bash
   cat ~/.claude/settings.json | grep rtk
   ```

## RTK not found after `cargo install`

**Symptom:**
```bash
$ rtk --version
zsh: command not found: rtk
```

**Cause:** `~/.cargo/bin` is not in your PATH.

**Fix:**

For bash (`~/.bashrc`) or zsh (`~/.zshrc`):
```bash
export PATH="$HOME/.cargo/bin:$PATH"
```

For fish (`~/.config/fish/config.fish`):
```fish
set -gx PATH $HOME/.cargo/bin $PATH
```

Then reload:
```bash
source ~/.zshrc    # or ~/.bashrc
rtk --version
```

## RTK on Windows

### Double-clicking rtk.exe does nothing

**Symptom:** You double-click `rtk.exe`, a terminal flashes and closes instantly.

**Cause:** RTK is a command-line tool. With no arguments, it prints usage and exits. The console window opens and closes before you can read anything.

**Fix:** Open a terminal first, then run RTK from there:
- Press `Win+R`, type `cmd`, press Enter
- Or open PowerShell or Windows Terminal
- Then run: `rtk --version`

### Hook not working (no auto-rewrite)

**Symptom:** `rtk init -g` shows "Falling back to --claude-md mode" on Windows.

**Cause:** Hook registration is missing or outdated in `settings.json`.

**Fix:** Re-run hook setup in PowerShell:
```powershell
# Inside WSL
cargo install --git https://github.com/luysantanadev/rtk-windows.git --force
rtk init -g    # full hook mode works in WSL
```

On native Windows, RTK falls back to CLAUDE.md injection. Your AI assistant gets RTK instructions but won't auto-rewrite commands. It can still use RTK manually: `rtk cargo test`, `rtk git status`, etc.

### Node.js tools not found

**Symptom:**
```
rtk vitest --run
Error: program not found
```

**Cause:** On Windows, Node.js tools are installed as `.CMD`/`.BAT` wrappers. Older RTK versions couldn't find them.

**Fix:** Update to RTK v0.23.1+:
```powershell
cargo install --git https://github.com/luysantanadev/rtk-windows.git
rtk --version    # should be 0.23.1+
```

## Compilation error during installation

```bash
rustup update stable
rustup default stable
cargo clean
cargo build --release
cargo install --path . --force
```

Minimum required Rust version: 1.70+.

## OpenCode not using RTK

```powershell
rtk-windows init -g --opencode
# restart OpenCode
rtk-windows init --show    # should show "OpenCode: plugin installed"
```

If you run `rtk-windows init --opencode` without `-g`, RTK will reject it because OpenCode plugin installation is global-only.

## `cargo install rtk` installs the wrong package

If Rust Type Kit is published to crates.io under the name `rtk`, `cargo install rtk` may install the wrong one.

Always use the explicit URL:

```bash
cargo install --git https://github.com/luysantanadev/rtk-windows.git
```

## Run the diagnostic script

From the RTK repository root:

```powershell
pwsh ./scripts/check-installation.ps1
```

Checks:
- RTK installed and in PATH
- Correct version (Token Killer, not Type Kit)
- Available features
- Claude Code integration
- Hook status

## Still stuck?

Open an issue: https://github.com/luysantanadev/rtk-windows.git/issues
