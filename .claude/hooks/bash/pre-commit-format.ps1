param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Write-Output 'Running Rust pre-commit checks...'

& cargo fmt --all
if ($LASTEXITCODE -ne 0) {
    Write-Error 'cargo fmt failed.'
}

$clippyOut = (& cargo clippy --all-targets 2>&1 | Out-String)
if ($LASTEXITCODE -ne 0 -and $clippyOut -match 'error:') {
    Write-Output 'Clippy found errors. Fix them before committing.'
    exit 1
}

Write-Output 'Pre-commit checks passed (warnings allowed)'
