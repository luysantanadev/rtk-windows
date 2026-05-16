param(
    [string]$WorkingDir = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Get-Command rtk -ErrorAction SilentlyContinue)) {
    Write-Error 'rtk not found in PATH. Run: cargo install --path .'
}
if (-not (Get-Command ruby -ErrorAction SilentlyContinue)) {
    Write-Error 'ruby not found in PATH. Install Ruby first.'
}

if ([string]::IsNullOrWhiteSpace($WorkingDir)) {
    $WorkingDir = Join-Path ([System.IO.Path]::GetTempPath()) ('rtk-ruby-smoke-' + [guid]::NewGuid().ToString('N'))
}

New-Item -ItemType Directory -Path $WorkingDir -Force | Out-Null
Push-Location $WorkingDir
try {
    Write-Output 'RTK Smoke Tests - Ruby (PowerShell Core)'
    & rtk rspec --help
    & rtk rubocop --help
    & rtk rake --help
    & rtk gain
}
finally {
    Pop-Location
}
