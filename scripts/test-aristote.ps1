param(
    [string]$AristotePath = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Get-Command rtk -ErrorAction SilentlyContinue)) {
    Write-Error 'rtk not found in PATH. Run: cargo install --path .'
}

if ([string]::IsNullOrWhiteSpace($AristotePath)) {
    $AristotePath = $env:ARISTOTE_PATH
}

if ([string]::IsNullOrWhiteSpace($AristotePath) -or -not (Test-Path $AristotePath)) {
    Write-Error 'Set -AristotePath or ARISTOTE_PATH to a valid project directory.'
}

Push-Location $AristotePath
try {
    Write-Output 'RTK Smoke Tests - Aristote Project (PowerShell Core)'
    & rtk ls .
    & rtk ls src
    & rtk find '*.tsx' src
    & rtk read package.json
    & rtk grep 'import' src
    & rtk git status
    & rtk deps .
    & rtk gain
    & rtk gain --history
}
finally {
    Pop-Location
}
