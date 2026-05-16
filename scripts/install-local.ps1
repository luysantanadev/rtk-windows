param(
    [string]$InstallDir = (Join-Path $HOME '.cargo/bin')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$binaryPath = 'target/release/rtk.exe'
if (-not (Get-Command cargo -ErrorAction SilentlyContinue)) {
    Write-Error 'error: cargo not found. Install Rust: https://rustup.rs'
}

Write-Output ("installing to: {0}" -f $InstallDir)

$needsBuild = $true
if (Test-Path $binaryPath) {
    $binaryItem = Get-Item $binaryPath
    $newerSource = @(
        Get-ChildItem src -Recurse -File -ErrorAction SilentlyContinue
        Get-Item Cargo.toml -ErrorAction SilentlyContinue
        Get-Item Cargo.lock -ErrorAction SilentlyContinue
    ) | Where-Object { $_ -and $_.LastWriteTimeUtc -gt $binaryItem.LastWriteTimeUtc } | Select-Object -First 1

    if (-not $newerSource) {
        $needsBuild = $false
    }
}

if ($needsBuild) {
    Write-Output 'building rtk (release)...'
    & cargo build --release
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
else {
    Write-Output 'binary is up to date'
}

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
$installPath = Join-Path $InstallDir 'rtk.exe'
Copy-Item -Force $binaryPath $installPath

Write-Output ("installed: {0}" -f $installPath)
$version = & $installPath --version
Write-Output ("version: {0}" -f $version)

$pathEntries = $env:PATH -split ';'
if ($pathEntries -notcontains $InstallDir) {
    Write-Output ''
    Write-Warning ("{0} is not in your PATH" -f $InstallDir)
    Write-Output 'add this to your PowerShell profile:'
    Write-Output ("`$env:PATH += ';{0}'" -f $InstallDir)
}
