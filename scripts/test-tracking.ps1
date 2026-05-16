param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$pass = 0
$fail = 0
$fails = New-Object System.Collections.Generic.List[string]

function Check-Contains {
    param(
        [string]$Name,
        [string]$Needle,
        [scriptblock]$Command
    )

    $output = ''
    try {
        $output = & $Command 2>&1 | Out-String
    }
    catch {
        $output = $_ | Out-String
    }

    if ($output -match [regex]::Escape($Needle)) {
        $script:pass++
        Write-Output ("  PASS  {0}" -f $Name)
    }
    else {
        $script:fail++
        $script:fails.Add($Name)
        Write-Output ("  FAIL  {0}" -f $Name)
        Write-Output ("        expected: '{0}'" -f $Needle)
        Write-Output ("        got: {0}" -f (($output -split "`n")[0..([Math]::Min(2, ($output -split "`n").Count - 1))] -join ' | '))
    }
}

Write-Output '=== RTK Tracking Validation ==='
Write-Output ''

& rtk ls . *> $null
Check-Contains 'rtk ls tracked' 'rtk ls' { rtk gain --history }

& rtk git status *> $null
Check-Contains 'rtk git status tracked' 'rtk git status' { rtk gain --history }

& rtk git log -5 *> $null
Check-Contains 'rtk git log tracked' 'rtk git log' { rtk gain --history }

Write-Output ''
Write-Output '--- Passthrough commands ---'
& rtk git tag --list *> $null
Check-Contains 'git passthrough tracked' 'git tag --list' { rtk gain --history }

Write-Output ''
Write-Output '--- GitHub CLI tracking ---'
$hasGh = Get-Command gh -ErrorAction SilentlyContinue
if ($hasGh) {
    try {
        & gh auth status *> $null
        & rtk gh pr list *> $null
        Check-Contains 'rtk gh pr list tracked' 'rtk gh pr' { rtk gain --history }
    }
    catch {
        Write-Output '  SKIP  gh (not authenticated)'
    }
}
else {
    Write-Output '  SKIP  gh (not installed)'
}

"line1`nline2`nline1`nERROR: bad`nline1" | rtk log *> $null
Check-Contains 'rtk log stdin tracked' 'rtk log' { rtk gain --history }

$output = (& rtk gain 2>&1 | Out-String)
if ($output -match 'Tokens saved') {
    $pass++
    Write-Output '  PASS  rtk gain summary works'
}
else {
    $fail++
    $fails.Add('rtk gain summary')
    Write-Output '  FAIL  rtk gain summary'
}

Write-Output ''
Write-Output ("=== Results: {0} passed, {1} failed ===" -f $pass, $fail)
if ($fails.Count -gt 0) {
    Write-Output ("Failures: {0}" -f ($fails -join ', '))
}

exit $fail
