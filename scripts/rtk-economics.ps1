param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Require-Command([string]$Name, [string]$InstallHint) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        Write-Error ("Error: {0} not found. {1}" -f $Name, $InstallHint)
    }
}

Require-Command 'ccusage' 'Install: npm install -g @anthropics/claude-code-usage'
Require-Command 'rtk' 'Install: cargo install --path .'

$currentMonth = Get-Date -Format 'yyyy-MM'
Write-Output 'RTK Economic Impact Analysis'
Write-Output '============================================================'
Write-Output ''

Write-Output 'Fetching token usage data from ccusage...'
$ccusage = & ccusage monthly --json | ConvertFrom-Json

Write-Output 'Fetching token savings data from rtk...'
$rtk = & rtk gain --monthly --format json | ConvertFrom-Json

$ccMonth = $ccusage.monthly | Where-Object { $_.month -eq $currentMonth } | Select-Object -First 1
$rtkMonth = $rtk.monthly | Where-Object { $_.month -eq $currentMonth } | Select-Object -First 1

$ccCost = [double]($ccMonth.totalCost ?? 0)
$ccInput = [double]($ccMonth.inputTokens ?? 0)
$ccOutput = [double]($ccMonth.outputTokens ?? 0)
$ccTotal = [double]($ccMonth.totalTokens ?? 0)

$saved = [double]($rtkMonth.saved_tokens ?? 0)
$commands = [double]($rtkMonth.commands ?? 0)
$rtkInput = [double]($rtkMonth.input_tokens ?? 0)
$rtkOutput = [double]($rtkMonth.output_tokens ?? 0)
$rtkPct = [double]($rtkMonth.savings_pct ?? 0)

$savedCost = [Math]::Round($saved * 0.0001, 2)
$totalWithoutRtk = [Math]::Round($ccCost + $savedCost, 2)
$savingsPct = if ($totalWithoutRtk -gt 0) { [Math]::Round(($savedCost / $totalWithoutRtk) * 100, 1) } else { 0 }

$costPerCmdWithout = if ($commands -gt 0) { [Math]::Round($totalWithoutRtk / $commands, 4) } else { 0 }
$costPerCmdWith = if ($commands -gt 0) { [Math]::Round($ccCost / $commands, 4) } else { 0 }

Write-Output ("Economic Impact Report - {0}" -f $currentMonth)
Write-Output '============================================================'
Write-Output ("Tokens consumed: input={0:N0}, output={1:N0}, total={2:N0}" -f $ccInput, $ccOutput, $ccTotal)
Write-Output ("Actual cost: ${0}" -f $ccCost)
Write-Output ''
Write-Output ("Tokens saved by rtk: commands={0:N0}, saved={1:N0} ({2}%)" -f $commands, $saved, $rtkPct)
Write-Output ("Cost avoided: ~${0}" -f $savedCost)
Write-Output ''
Write-Output ("Cost without rtk: ${0}" -f $totalWithoutRtk)
Write-Output ("Cost with rtk: ${0}" -f $ccCost)
Write-Output ("Net savings: ${0} ({1}%)" -f $savedCost, $savingsPct)
Write-Output ("Cost per command: ${0} -> ${1}" -f $costPerCmdWithout, $costPerCmdWith)
Write-Output ("Tokens per command: {0:N0} -> {1:N0}" -f ($rtkInput / [Math]::Max($commands, 1)), ($rtkOutput / [Math]::Max($commands, 1)))
Write-Output ''
Write-Output ("12-month projection savings: ~${0}" -f [Math]::Round($savedCost * 12, 2))
Write-Output '============================================================'
