param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$pass = 0
$fail = 0
$skip = 0
$failures = New-Object System.Collections.Generic.List[string]

function Pass([string]$Name) { $script:pass++; Write-Output ("  PASS  {0}" -f $Name) }
function Fail([string]$Name, [string]$Detail) { $script:fail++; $script:failures.Add($Name); Write-Output ("  FAIL  {0}" -f $Name); if ($Detail) { Write-Output ("        {0}" -f $Detail) } }
function Skip([string]$Name, [string]$Reason) { $script:skip++; Write-Output ("  SKIP  {0} ({1})" -f $Name, $Reason) }

function Assert-Command {
    param([string]$Name, [scriptblock]$Command, [string]$Needle)

    try {
        $output = & $Command 2>&1 | Out-String
        if ($Needle -and $output -notmatch $Needle) {
            Fail $Name ("expected pattern not found: {0}" -f $Needle)
        }
        else {
            Pass $Name
        }
    }
    catch {
        Fail $Name ($_.Exception.Message)
    }
}

if (-not (Get-Command rtk -ErrorAction SilentlyContinue)) {
    Write-Error 'rtk not found in PATH. Run: cargo install --path .'
}

Write-Output 'RTK Smoke Test Suite (PowerShell Core)'
Write-Output ("Version: {0}" -f (& rtk --version))
Write-Output ''

Assert-Command 'rtk --help' { rtk --help } 'Usage:'
Assert-Command 'rtk ls' { rtk ls . } ''
Assert-Command 'rtk read Cargo.toml' { rtk read Cargo.toml } ''
Assert-Command 'rtk git status' { rtk git status } ''
Assert-Command 'rtk git log -5' { rtk git log -n 5 } ''
Assert-Command 'rtk grep pub fn src' { rtk grep 'pub fn' src/ } ''
Assert-Command 'rtk find *.rs' { rtk find '*.rs' src/ } ''
Assert-Command 'rtk deps' { rtk deps . } ''
Assert-Command 'rtk env' { rtk env } ''
Assert-Command 'rtk gain' { rtk gain } ''
Assert-Command 'rtk init --show' { rtk init --show } ''
Assert-Command 'rtk proxy echo' { rtk proxy echo hello } ''
Assert-Command 'rtk rewrite git status' { rtk rewrite 'git status' } 'rtk git status'
Assert-Command 'rtk verify' { rtk verify } ''

if (Get-Command gh -ErrorAction SilentlyContinue) {
    Assert-Command 'rtk gh --help' { rtk gh --help } 'Usage:'
}
else {
    Skip 'rtk gh --help' 'gh not installed'
}

Write-Output ''
Write-Output ("Results: {0} passed, {1} failed, {2} skipped" -f $pass, $fail, $skip)
if ($failures.Count -gt 0) {
    Write-Output 'Failures:'
    foreach ($f in $failures) { Write-Output ("  - {0}" -f $f) }
}

exit $fail
