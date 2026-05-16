param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$line = '============================================================'
Write-Output $line
Write-Output '           RTK Installation Verification'
Write-Output $line
Write-Output ''

Write-Output '1. Checking if RTK is installed...'
$rtkCmd = Get-Command rtk -ErrorAction SilentlyContinue
if (-not $rtkCmd) {
    Write-Output '   [FAIL] RTK is NOT installed'
    Write-Output ''
    Write-Output '   Install with:'
    Write-Output '   cargo install --path .'
    exit 1
}
Write-Output '   [OK] RTK is installed'
Write-Output ("   Location: {0}" -f $rtkCmd.Source)
Write-Output ''

Write-Output '2. Checking RTK version...'
$rtkVersion = try { & rtk --version 2>$null } catch { 'unknown' }
Write-Output ("   Version: {0}" -f $rtkVersion)
Write-Output ''

Write-Output '3. Verifying this is Token Killer (not Type Kit)...'
$correctRtk = $true
try {
    & rtk gain *> $null
}
catch {
    try {
        & rtk gain --help *> $null
    }
    catch {
        $correctRtk = $false
    }
}

if ($correctRtk) {
    Write-Output '   [OK] CORRECT - You have Rust Token Killer'
}
else {
    Write-Output '   [FAIL] WRONG - You may have Rust Type Kit (different project!)'
    Write-Output ''
    Write-Output '   You installed the wrong package. Fix it with:'
    Write-Output '   cargo uninstall rtk'
    Write-Output '   cargo install --path . --force'
    exit 1
}
Write-Output ''

Write-Output '4. Checking available features...'
$helpText = (& rtk --help 2>$null | Out-String)
$features = @(
    @{ Cmd = 'gain'; Name = 'Token savings analytics' },
    @{ Cmd = 'git'; Name = 'Git operations' },
    @{ Cmd = 'gh'; Name = 'GitHub CLI' },
    @{ Cmd = 'pnpm'; Name = 'pnpm support' },
    @{ Cmd = 'vitest'; Name = 'Vitest test runner' },
    @{ Cmd = 'lint'; Name = 'ESLint/linters' },
    @{ Cmd = 'tsc'; Name = 'TypeScript compiler' },
    @{ Cmd = 'next'; Name = 'Next.js' },
    @{ Cmd = 'prettier'; Name = 'Prettier' },
    @{ Cmd = 'playwright'; Name = 'Playwright E2E' },
    @{ Cmd = 'prisma'; Name = 'Prisma ORM' },
    @{ Cmd = 'discover'; Name = 'Discover missed savings' }
)

$missing = @()
foreach ($feature in $features) {
    if ($helpText -match ("(?m)^\s*{0}(\s|$)" -f [regex]::Escape($feature.Cmd))) {
        Write-Output ("   [OK] {0}" -f $feature.Name)
    }
    else {
        Write-Output ("   [WARN] {0} (missing - upgrade to fork?)" -f $feature.Name)
        $missing += $feature.Name
    }
}
Write-Output ''

Write-Output '5. Checking Claude Code integration...'
$homeDir = [Environment]::GetFolderPath('UserProfile')
$globalClaude = Join-Path $homeDir '.claude/CLAUDE.md'
$localClaude = 'CLAUDE.md'
$globalInit = $false
$localInit = $false

if (Test-Path $globalClaude) {
    $globalContent = Get-Content $globalClaude -Raw
    if ($globalContent -match 'rtk') {
        Write-Output '   [OK] Global CLAUDE.md initialized (~/.claude/CLAUDE.md)'
        $globalInit = $true
    }
}
if (-not $globalInit) {
    Write-Output '   [WARN] Global CLAUDE.md not initialized'
    Write-Output '      Run: rtk init --global'
}

if (Test-Path $localClaude) {
    $localContent = Get-Content $localClaude -Raw
    if ($localContent -match 'rtk') {
        Write-Output '   [OK] Local CLAUDE.md initialized (./CLAUDE.md)'
        $localInit = $true
    }
}
if (-not $localInit) {
    Write-Output '   [WARN] Local CLAUDE.md not initialized in current directory'
    Write-Output '      Run: rtk init (in your project directory)'
}
Write-Output ''

Write-Output '6. Checking auto-rewrite hook (optional but recommended)...'
$rewriteJson = Join-Path $homeDir '.claude/hooks/rtk-rewrite.json'
$settingsJson = Join-Path $homeDir '.claude/settings.json'
if (Test-Path $rewriteJson) {
    Write-Output '   [OK] Hook definition installed (rtk-rewrite.json)'
    if ((Test-Path $settingsJson) -and ((Get-Content $settingsJson -Raw) -match 'rtk\s+hook\s+claude')) {
        Write-Output '   [OK] Hook enabled in settings.json'
    }
    else {
        Write-Output '   [WARN] Hook definition exists but not enabled in settings.json'
    }
}
else {
    Write-Output '   [WARN] Auto-rewrite hook not installed (optional)'
    Write-Output '      Install: rtk init --global'
}
Write-Output ''

Write-Output $line
Write-Output '                    SUMMARY'
Write-Output $line

if ($missing.Count -gt 0) {
    Write-Output '[WARN] You have a basic RTK installation'
    Write-Output ''
    Write-Output 'Missing features:'
    foreach ($item in $missing) {
        Write-Output ("  - {0}" -f $item)
    }
    Write-Output ''
    Write-Output 'To get all features, install the fork:'
    Write-Output '  cargo uninstall rtk'
    Write-Output '  cargo install --path . --force'
}
else {
    Write-Output '[OK] Full-featured RTK installation detected'
}

Write-Output ''
if (-not $globalInit -and -not $localInit) {
    Write-Output '[WARN] RTK not initialized for Claude Code'
    Write-Output '   Run: rtk init --global (for all projects)'
    Write-Output '   Or:  rtk init (for this project only)'
}

Write-Output ''
Write-Output 'Need help? See docs/guide/resources/troubleshooting.md'
Write-Output $line
