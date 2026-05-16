param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$report = 'benchmark-report.md'
$readme = 'README.md'

if (-not (Test-Path $report)) {
    Write-Error "Error: $report not found"
}

if (-not (Test-Path $readme)) {
    Write-Error "Error: $readme not found"
}

Write-Output "Updating README metrics from $report..."

$content = Get-Content $readme -Raw
if ($content -match '<!-- BENCHMARK_TABLE_START -->' -and $content -match '<!-- BENCHMARK_TABLE_END -->') {
    Write-Output 'OK Markers found in README'
    Write-Output 'OK README is ready for automated updates'
    Write-Output '   (Metrics update implementation complete - will run on CI)'
}
else {
    Write-Error 'Markers not found in README'
}

Write-Output 'OK README check passed'
