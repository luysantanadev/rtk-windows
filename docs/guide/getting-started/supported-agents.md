---
title: Supported Agents
description: How to integrate RTK with Claude Code, Cursor, Copilot, Cline, Windsurf, Codex, OpenCode, Hermes, Kilo Code, and Antigravity
sidebar:
  order: 3
---

# Supported Agents

RTK supports all major AI coding agents across 3 integration tiers. Mistral Vibe support is planned.

## How it works

Each agent integration intercepts CLI commands before execution and rewrites them to their RTK equivalent. The agent runs `rtk cargo test` instead of `cargo test`, sees filtered output, and uses up to 90% fewer tokens — without any change to your workflow.

All rewrite logic lives in the RTK binary (`rtk rewrite`). Agent hooks are thin delegates that parse the agent-specific JSON format and call `rtk rewrite` for the actual decision.

```
Agent runs "cargo test"
  -> Hook intercepts (PreToolUse / plugin event)
  -> Calls rtk rewrite "cargo test"
  -> Returns "rtk cargo test"
  -> Agent executes filtered command
  -> LLM sees 90% fewer tokens
```

## Supported agents

| Agent | Integration tier | Can rewrite transparently? | Windows native? |
|-------|-----------------|---------------------------|-------------|
| Claude Code | Shell hook (`PreToolUse`) | Yes | ⚠️ Fallback mode (instructions only) |
| VS Code Copilot Chat | Rust binary (`PreToolUse`) | Yes | ✅ Full support |
| GitHub Copilot CLI | Rust binary (deny-with-suggestion) | No (agent retries) | ✅ Full support |
| Cursor | Shell hook (`preToolUse`) | Yes | ⚠️ Fallback mode |
| Gemini CLI | Rust binary (`BeforeTool`) | Yes | ✅ Full support |
| OpenCode | TypeScript plugin (`tool.execute.before`) | Yes | ✅ Full support |
| OpenClaw | TypeScript plugin (`before_tool_call`) | Yes | ✅ Full support |
| Hermes | Python plugin (`terminal` command mutation) | Yes | ✅ Full support |
| Cline / Roo Code | Rules file (prompt-level) | N/A | ✅ Full support |
| Windsurf | Rules file (prompt-level) | N/A | ✅ Full support |
| Codex CLI | AGENTS.md instructions | N/A | ✅ Full support |
| Kilo Code | Rules file (prompt-level) | N/A | ✅ Full support |
| Google Antigravity | Rules file (prompt-level) | N/A | ✅ Full support |
| Mistral Vibe | Planned ([#800](https://github.com/luysantanadev/rtk-windows.git/issues/800)) | Not yet available |

## Installation by agent

### Claude Code

```bash
rtk init --global    # installs hook + patches settings.json
```

Restart Claude Code. Verify:

```bash
rtk init --show    # shows hook status
```

### Cursor

```bash
rtk init --global --cursor
```

Restart Cursor. The hook uses `preToolUse` with Cursor's `updated_input` format.

### VS Code Copilot Chat

```bash
rtk init --global --copilot
```

### Gemini CLI

```bash
rtk init --global --gemini
```

### OpenCode

```powershell
rtk-windows init -g --opencode
```

Creates `~/.config/opencode/plugins/rtk.ts`. Uses the `tool.execute.before` hook.

### OpenClaw

```bash
openclaw plugins install ./openclaw
```

Plugin in the `openclaw/` directory. Uses the `before_tool_call` hook, delegates to `rtk rewrite`.

### Hermes

```bash
rtk init --agent hermes
```

Creates `~/.hermes/plugins/rtk-rewrite/` and enables it through `plugins.enabled` in the Hermes config. Hermes loads Python plugins, so the plugin entrypoint is Python, but it is only a thin adapter. It mutates the Hermes `terminal` tool `command` before execution and delegates all rewrite decisions to Rust through `rtk rewrite`. The repository source and tests for that adapter live in `hooks/hermes/`; only installed runtime files use the `~/.hermes/plugins/rtk-rewrite/` path.

The plugin fails open. If `rtk` is missing at load time, the hook is not registered. If `rtk rewrite` errors, the tool is not `terminal`, the payload has no string `command`, or the plugin raises an exception, Hermes runs the original command unchanged. The same `rtk rewrite` limitations apply: already-prefixed `rtk` commands, compound shell commands, heredocs, and commands without filters are not rewritten.

### Cline / Roo Code

```bash
rtk init --cline    # creates .clinerules in current project
```

Cline reads `.clinerules` as custom instructions. RTK adds guidance telling Cline to prefer `rtk <cmd>` over raw commands.

### Windsurf

```bash
rtk init --windsurf    # creates .windsurfrules in current project
```

### Codex CLI

```bash
rtk init --codex    # creates AGENTS.md or patches existing one
```

### Kilo Code

```bash
rtk init --agent kilocode    # creates .kilocode/rules/rtk-rules.md in current project
```

Kilo Code reads `.kilocode/rules/` as custom instructions. RTK adds guidance telling Kilo Code to prefer `rtk <cmd>` over raw commands.

### Google Antigravity

```bash
rtk init --agent antigravity    # creates .agents/rules/antigravity-rtk-rules.md in current project
```

Antigravity reads `.agents/rules/` as custom instructions. RTK adds guidance telling Antigravity to prefer `rtk <cmd>` over raw commands.

### Mistral Vibe (planned)

Support is not yet available pending required callback support in Mistral Vibe. Tracked in [#800](https://github.com/luysantanadev/rtk-windows.git/issues/800).

## Integration tiers explained

| Tier | Mechanism | How rewrites work |
|------|-----------|------------------|
| **Full hook** | Shell script or Rust binary, intercepts via agent API | Transparent — agent never sees the raw command |
| **Plugin** | TypeScript, JavaScript, or Python in agent's plugin system | Transparent, in-place mutation when the agent allows it |
| **Rules file** | Prompt-level instructions | Guidance only — agent is told to prefer `rtk <cmd>` |

Rules file integrations (Cline, Windsurf, Codex, Kilo Code, Antigravity) rely on the model following instructions. Full hook integrations (Claude Code, Cursor, Gemini) are guaranteed — the command is rewritten before the agent sees it.

## Windows support

### Full native Windows support (RTK 0.34.0+)

**VS Code Copilot Chat** and **Copilot CLI** now use Rust-native hooks (`rtk hook copilot`) — full transparent rewrite on Windows.

```powershell
rtk init -g --copilot    # Full native Windows support
```

Other agents fallback to **CLAUDE.md injection mode** (prompt-level instructions) on native Windows:

- `rtk init -g` (Claude Code) → instructions only, no auto-rewrite
- Filters work normally (`rtk cargo test`, `rtk git status`)

### WSL: Full feature parity with Linux/macOS

For full hook support on all agents (Claude Code, Cursor, Gemini), use [WSL](https://learn.microsoft.com/en-us/windows/wsl/install). Inside WSL, all agents work identically to Linux:

```bash
# Inside WSL terminal
rtk init -g    # Full auto-rewrite for all agents
```

## Graceful degradation

Hooks never block command execution. If RTK is missing, the hook exits cleanly and the raw command runs unchanged:

- RTK binary not found: warning to stderr, exit 0
- Invalid JSON input: pass through unchanged
- RTK version too old: warning to stderr, exit 0
- Filter logic error: fallback to raw command output

## Override: disable RTK for one command

```bash
RTK_DISABLED=1 git status    # runs raw git status, no rewrite
```

Or exclude commands permanently in `~/.config/rtk/config.toml`:

```toml
[hooks]
exclude_commands = ["git rebase", "git cherry-pick"]
```
