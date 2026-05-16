param(
    [string]$BaseBranch = 'origin/develop',
    [switch]$SelfTest
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($SelfTest) {
    $tmpFile = 'src/cmds/system/_rtk_check_self_test_cmd.rs'
    try {
        Set-Content -Path $tmpFile -Value 'pub fn run() {}' -NoNewline
        $content = Get-Content -Path $tmpFile -Raw
        if ($content -match '#\[cfg\(test\)\]') {
            Write-Error 'FAIL: self-test broken (false negative)'
        }
        Write-Output 'PASS: --self-test detection works correctly'
        exit 0
    }
    finally {
        if (Test-Path $tmpFile) {
            Remove-Item -Force $tmpFile
        }
    }
}

$changedFiles = git diff --name-only --diff-filter=AM --no-renames "$BaseBranch...HEAD" 2>$null |
    Where-Object { $_ -match '^src/cmds/.+_cmd\.rs$' }

if (-not $changedFiles -or $changedFiles.Count -eq 0) {
    Write-Output 'check-test-presence: no *_cmd.rs changes detected - OK'
    exit 0
}

Write-Output ("check-test-presence: checking {0} filter module(s)..." -f $changedFiles.Count)
Write-Output ''

$failed = $false
foreach ($file in $changedFiles) {
    if (-not (Test-Path $file)) {
        continue
    }

    $content = Get-Content -Path $file -Raw
    if ($content -match '#\[cfg\(test\)\]') {
        Write-Output ("  PASS  {0}" -f $file)
    }
    else {
        Write-Output ("  FAIL  {0}" -f $file)
        Write-Output '        Missing #[cfg(test)] module.'
        Write-Output '        Every *_cmd.rs filter must include inline unit tests.'
        Write-Output '        Reference: src/cmds/cloud/aws_cmd.rs'
        Write-Output ''
        $failed = $true
    }
}

Write-Output ''
if ($failed) {
    Write-Output 'check-test-presence: FAILED - add tests before merging.'
    Write-Output 'See .claude/rules/cli-testing.md for the testing guide.'
    exit 1
}

Write-Output 'check-test-presence: all filter modules have tests - OK'
exit 0
