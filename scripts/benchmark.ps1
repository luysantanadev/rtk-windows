param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$rtkPath = Join-Path (Get-Location) 'target/release/rtk.exe'
if (-not (Test-Path $rtkPath)) {
    $cmd = Get-Command rtk -ErrorAction SilentlyContinue
    if (-not $cmd) {
        Write-Error "Error: rtk not found. Run 'cargo build --release' or install rtk."
    }
    $rtkPath = $cmd.Source
}

$benchDir = Join-Path (Get-Location) 'scripts/benchmark'
if (-not $env:CI) {
    if (Test-Path $benchDir) { Remove-Item -Recurse -Force $benchDir }
    New-Item -ItemType Directory -Force -Path (Join-Path $benchDir 'unix') | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $benchDir 'rtk') | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $benchDir 'diff') | Out-Null
}

function Count-Tokens([string]$InputText) {
    [int][Math]::Ceiling($InputText.Length / 4.0)
}

function Invoke-Bench {
    param(
        [string]$Name,
        [scriptblock]$UnixCommand,
        [scriptblock]$RtkCommand
    )

    $unixOut = ''
    $rtkOut = ''
    try { $unixOut = & $UnixCommand 2>$null | Out-String } catch {}
    try { $rtkOut = & $RtkCommand 2>$null | Out-String } catch {}

    $u = Count-Tokens $unixOut
    $r = Count-Tokens $rtkOut
    $pct = if ($u -gt 0) { [int](($u - $r) * 100 / $u) } else { 0 }
    Write-Output ("{0,-24} | {1,6} -> {2,6} ({3,4}%)" -f $Name, $u, $r, $pct)
}

Write-Output 'RTK Benchmark (PowerShell Core)'
Write-Output '============================================================'
Invoke-Bench 'ls' { Get-ChildItem -Force } { & $rtkPath ls . }
Invoke-Bench 'git status' { git status } { & $rtkPath git status }
Invoke-Bench 'git log -5' { git log -5 } { & $rtkPath git log -n 5 }
Invoke-Bench 'read main.rs' { Get-Content src/main.rs -Raw } { & $rtkPath read src/main.rs }
Invoke-Bench 'grep fn src' { Select-String -Path src/**/*.rs -Pattern 'fn ' } { & $rtkPath grep 'fn ' src/ }
Write-Output '============================================================'
