# rtk-windows — Token-Optimized CLI

**rtk-windows** is a CLI proxy that filters and compresses command outputs, saving 60-90% tokens.

## Rule

Always prefix shell commands with `rtk-windows`:

### PowerShell / Windows

```powershell
# Instead of:                        Use:
git status                           rtk-windows git status
git log -10                          rtk-windows git log -10
cargo test                           rtk-windows cargo test
docker ps                            rtk-windows docker ps
Get-ChildItem                        rtk-windows ls
Get-Process | Select-Object Name     rtk-windows ps
dotnet test                          rtk-windows dotnet test
```

## Meta commands (use directly)

```powershell
rtk-windows gain              # Token savings dashboard
rtk-windows gain --history    # Per-command savings history
rtk-windows discover          # Find missed rtk-windows opportunities
rtk-windows proxy <cmd>       # Run raw (no filtering) but track usage
```
