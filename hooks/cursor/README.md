# Cursor IDE Hooks

> Part of [`hooks/`](../README.md) — see also [`src/hooks/`](../../src/hooks/README.md) for installation code

Windows-only fork note: this integration is documented for Windows-native use in this repository. For Linux/macOS guidance, use upstream: https://github.com/rtk-ai/rtk.

## Specifics

- Native Rust hook command (`rtk hook cursor`) with Cursor JSON output (`permission`/`updated_input`)
- Returns `{}` (empty JSON) when no rewrite applies -- Cursor requires JSON output for all code paths
- Does not require `jq` or shell script wrappers
