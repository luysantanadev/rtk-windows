---
title: Installation
description: Install RTK for Windows in this fork and verify the correct version
sidebar:
  order: 1
---

# Installation

## Name collision warning

Two unrelated projects share the name `rtk`. Make sure you install the right one:

- **Rust Token Killer** (`https://github.com/luysantanadev/rtk-windows.git`) — this project, a token-saving CLI proxy
- **Rust Type Kit** (`reachingforthejack/rtk`) — a different tool for generating Rust types

The easiest way to verify you have the correct one: run `rtk gain`. It should display token savings stats. If it returns "command not found", you either have the wrong package or RTK is not installed.

> **Windows-only:** This repository is exclusively for Windows 10/11 with PowerShell Core or Command Prompt. Multi-platform support is not available.

## Check before installing

```powershell
rtk --version   # should print: rtk x.y.z
rtk gain        # should show token savings stats
```

If both commands work, RTK is already installed. Skip to [Project initialization](#project-initialization).

## Windows binary (recommended)

Download `rtk-x86_64-pc-windows-msvc.zip` from [GitHub releases](https://github.com/luysantanadev/rtk-windows.git/releases), extract `rtk.exe`, and place it in a folder on your PATH.

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\\bin" | Out-Null
Copy-Item .\rtk.exe "$env:USERPROFILE\\bin\\rtk.exe" -Force
```

If needed, add the install folder to PATH:

```powershell
[Environment]::SetEnvironmentVariable(
  "Path",
  $env:Path + ";$env:USERPROFILE\\bin",
  "User"
)
```

## Cargo

:::caution[Name collision risk]
`cargo install rtk` may install **Rust Type Kit** instead of Rust Token Killer — two unrelated projects share the same crate name. Use the explicit Git URL to guarantee the correct package:
:::

```powershell
cargo install --git https://github.com/luysantanadev/rtk-windows.git rtk
```

## Pre-built binaries

Download from [GitHub releases](https://github.com/luysantanadev/rtk-windows.git/releases):
- Windows: `rtk-x86_64-pc-windows-msvc.zip`

Extract the zip and place `rtk.exe` in a directory on your PATH. Run RTK from Command Prompt, PowerShell, or Windows Terminal.

## Linux/macOS users

**rtk-windows is exclusively for Windows.** Multi-platform support is not planned for this fork.

For a similar token optimization tool that supports other platforms, you may search for alternatives.

## Verify installation

```powershell
rtk --version   # rtk x.y.z
rtk gain        # token savings dashboard
```

If `rtk gain` fails but `rtk --version` succeeds, you installed Rust Type Kit by mistake. Uninstall it first:

```powershell
cargo uninstall rtk
```

Then reinstall using one of the methods above.

## Project initialization

Run once per project to enable the Claude Code hook:

```powershell
rtk init
```

For a global install that patches `settings.json` automatically:

```powershell
rtk init --global
```

## Uninstall

```powershell
rtk init -g --uninstall    # remove hook, RTK.md, and settings.json entry
cargo uninstall rtk         # remove binary (if installed via Cargo)
```
