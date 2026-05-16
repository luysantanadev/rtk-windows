param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$installScript = Join-Path $repoRoot 'install.ps1'

if (-not (Test-Path $installScript)) {
    Write-Output ("FAIL: install.ps1 not found at {0}" -f $installScript)
    exit 1
}

$fail = $false

function Pass($msg) { Write-Output ("  PASS: {0}" -f $msg) }
function Fail($msg) { Write-Output ("  FAIL: {0}" -f $msg); $script:fail = $true }

function Test-ArchiveSafety {
    param([string]$ArchivePath)

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [System.IO.Compression.ZipFile]::OpenRead($ArchivePath)
    try {
        foreach ($entry in $archive.Entries) {
            if ($entry.FullName.StartsWith('/') -or $entry.FullName -match '(^|/)\.\.(/|$)') {
                return $false
            }
        }
        return $true
    }
    finally {
        $archive.Dispose()
    }
}

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("rtk-install-test-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tempRoot | Out-Null

try {
    $safeZip = Join-Path $tempRoot 'safe.zip'
    $safeFolder = Join-Path $tempRoot 'safe-src'
    New-Item -ItemType Directory -Path $safeFolder | Out-Null
    Set-Content -Path (Join-Path $safeFolder 'rtk.exe') -Value 'binary' -NoNewline
    Compress-Archive -Path (Join-Path $safeFolder 'rtk.exe') -DestinationPath $safeZip

    if (Test-ArchiveSafety $safeZip) { Pass 'safe archive accepted' } else { Fail 'safe archive rejected (false positive)' }

    $installContent = Get-Content $installScript -Raw
    if ($installContent -match 'StartsWith\(''\/''\)' -and $installContent -match '\(\^\|/\)\\\.\\\.\(/\|\$\)') {
        Pass 'install.ps1 still contains the path-traversal check'
    }
    else {
        Fail 'install.ps1 is missing path traversal checks'
    }
}
finally {
    if (Test-Path $tempRoot) {
        Remove-Item -Recurse -Force $tempRoot
    }
}

if (-not $fail) {
    Write-Output 'All install.ps1 path traversal tests passed'
    exit 0
}

Write-Output 'Some tests failed'
exit 1
