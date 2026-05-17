import type { Plugin } from "@opencode-ai/plugin"

// RTK OpenCode plugin — rewrites commands to use rtk-windows for token savings.
// Requires: rtk-windows in PATH.
//
// This is a thin delegating plugin: all rewrite logic lives in `rtk-windows rewrite`,
// which is the single source of truth (src/discover/registry.rs).
// To add or change rewrite rules, edit the Rust registry — not this file.

export const RtkOpenCodePlugin: Plugin = async ({ $ }) => {
  try {
    await $`rtk-windows --version`.quiet()
  } catch {
    console.warn("[rtk] rtk-windows binary not found in PATH — plugin disabled")
    return {}
  }

  return {
    "tool.execute.before": async (input, output) => {
      const tool = String(input?.tool ?? "").toLowerCase()
      const isShellTool =
        tool === "bash" ||
        tool === "shell" ||
        tool === "powershell" ||
        tool === "pwsh" ||
        tool === "powershell-core"
      if (!isShellTool) return
      const args = output?.args
      if (!args || typeof args !== "object") return

      const command = (args as Record<string, unknown>).command
      if (typeof command !== "string" || !command) return

      const trimmed = command.trim()
      if (!trimmed) return

      try {
        const result = await $`rtk-windows rewrite -- ${trimmed}`.quiet().nothrow()
        const rewritten = String(result.stdout).trim()
        if (rewritten && rewritten !== trimmed) {
          ;(args as Record<string, unknown>).command = rewritten
        }
      } catch {
        // rewrite failed — pass through unchanged
      }
    },
  }
}
