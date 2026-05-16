param(
    [string]$Version = $env:RTK_VERSION,
    [string]$InstallDir = $env:RTK_INSTALL_DIR
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($InstallDir)) {
    $InstallDir = Join-Path $HOME '.local/bin'
}

$repo = 'luysantanadev/rtk-windows'
$binaryName = 'rtk.exe'

function Info([string]$Message) { Write-Output ("[INFO] {0}" -f $Message) }
function Warn([string]$Message) { Write-Warning $Message }

function Get-LatestVersion {
    $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/releases/latest" -Headers @{ 'User-Agent' = 'rtk-installer' }
    if (-not $release.tag_name) {
        throw 'Failed to get latest version. Set RTK_VERSION=vX.Y.Z to pin.'
    }
    return [string]$release.tag_name
}

if ([string]::IsNullOrWhiteSpace($Version)) {
    $Version = Get-LatestVersion
}

$assetName = "$binaryName"
$downloadUrl = "https://github.com/$repo/releases/download/$Version/$assetName"

$tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("rtk-install-" + [guid]::NewGuid().ToString('N'))
$archivePath = Join-Path $tempDir $assetName

New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
try {
    Info ("Downloading from: {0}" -f $downloadUrl)
    Invoke-WebRequest -Uri $downloadUrl -OutFile $archivePath -UseBasicParsing

    # Path traversal safety guard parity: reject absolute paths or .. components.
    if ($archivePath.StartsWith('/') -or $archivePath -match '(^|/)\.\.(/|$)') {
        throw 'Unsafe archive path detected.'
    }

    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    $installPath = Join-Path $InstallDir $binaryName
    Copy-Item -Force $archivePath $installPath

    Info ("Successfully installed to {0}" -f $installPath)
    try {
        $ver = & $installPath --version
        Info ("Verification: {0}" -f $ver)
    }
    catch {
        Warn 'Binary installed but failed to run directly. Ensure dependencies are present.'
    }
}
finally {
    if (Test-Path $tempDir) {
        Remove-Item -Recurse -Force $tempDir
    }
}

if (($env:PATH -split ';') -notcontains $InstallDir) {
    Warn ("{0} is not in PATH. Add it to your PowerShell profile." -f $InstallDir)
}

Write-Output ''
Info 'Installation complete! Run rtk --help to get started.'
