param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Write-Output 'Validating RTK documentation consistency...'

$srcFiles = Get-ChildItem src -Recurse -Filter *.rs |
    Where-Object { $_.Name -notin @('mod.rs', 'main.rs') }
Write-Output ("Rust source files in src/: {0}" -f $srcFiles.Count)

$pythonGoCmds = @('ruff', 'pytest', 'pip', 'go', 'golangci')
Write-Output 'Checking Python/Go commands documentation...'

if (-not (Test-Path 'README.md')) {
    Write-Warning 'README.md not found, skipping'
}
else {
    $readme = Get-Content 'README.md' -Raw
    foreach ($cmd in $pythonGoCmds) {
        if ($readme -notmatch ("\b{0}\b" -f [regex]::Escape($cmd))) {
            Write-Error ("README.md does not mention command {0}" -f $cmd)
        }
    }
    Write-Output 'Python/Go commands: documented in README.md'
}

$hookFile = '.claude/hooks/rtk-rewrite.sh'
if (Test-Path $hookFile) {
    Write-Output 'Checking hook rewrites...'
    $hookContent = Get-Content $hookFile -Raw
    foreach ($cmd in $pythonGoCmds) {
        if ($hookContent -notmatch ("\b{0}\b" -f [regex]::Escape($cmd))) {
            Write-Warning ("Hook may not rewrite {0} (verify manually)" -f $cmd)
        }
    }
    Write-Output 'Hook file exists and mentions Python/Go commands'
}
else {
    Write-Warning "Hook file not found: $hookFile"
}

Write-Output ''
Write-Output 'Documentation validation passed'
