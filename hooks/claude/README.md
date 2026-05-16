# Claude Code Hooks

> Part of [`hooks/`](../README.md) — see also [`src/hooks/`](../../src/hooks/README.md) for installation code

Windows-only fork note: this integration is documented for Windows-native use in this repository. For Linux/macOS guidance, use upstream: https://github.com/rtk-ai/rtk.

## Specifics

- Native Rust `PreToolUse` hook (`rtk hook claude`)
- Returns `updatedInput` JSON for transparent command rewrite (agent doesn't know RTK is involved)
- Exits silently (exit 0) on no-match/unsupported payload paths to preserve non-blocking behavior
- `rtk-awareness.md` is a slim 10-line instructions file embedded into CLAUDE.md by `rtk init`

## Testing

```powershell
# Run native Claude hook tests
cargo test hooks::hook_cmd::tests::run_claude

# Run init migration/idempotency tests (includes legacy cleanup paths)
cargo test hooks::init::tests::test_global_default_mode_idempotent
```
