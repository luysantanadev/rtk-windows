[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter()]
    [switch]$IncludeOptionalTools,

    [Parameter()]
    [switch]$IncludeWsl,

    [Parameter()]
    [switch]$Force,

    [Parameter()]
    [switch]$Uninstall
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$stateFilePath = Join-Path -Path $PSScriptRoot -ChildPath '.install-dev-tools-state.json'

function Write-Status {
    param(
        [Parameter(Mandatory)]
        [string]$Message
    )

    Write-Host "[rtk-setup] $Message"
}

function Test-CommandAvailable {
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    return $null -ne (Get-Command -Name $Name -ErrorAction SilentlyContinue)
}

function Test-VisualCppBuildToolsInstalled {
    $vsWherePath = Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath 'Microsoft Visual Studio\Installer\vswhere.exe'
    if (-not (Test-Path -Path $vsWherePath)) {
        return $false
    }

    $result = & $vsWherePath -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath 2>$null
    return -not [string]::IsNullOrWhiteSpace($result)
}

function Get-InstallState {
    if (-not (Test-Path -Path $stateFilePath)) {
        return @()
    }

    try {
        $raw = Get-Content -Path $stateFilePath -Raw -ErrorAction Stop
        if ([string]::IsNullOrWhiteSpace($raw)) {
            return @()
        }

        $parsed = ConvertFrom-Json -InputObject $raw -ErrorAction Stop
        if ($null -eq $parsed) {
            return @()
        }

        if ($parsed -is [System.Collections.IEnumerable] -and -not ($parsed -is [string])) {
            return @($parsed)
        }

        return @($parsed)
    } catch {
        Write-Warning "Could not parse install state file at $stateFilePath. Starting with empty state."
        return @()
    }
}

function Save-InstallState {
    param(
        [Parameter(Mandatory)]
        [array]$State
    )

    $json = $State | ConvertTo-Json -Depth 5
    Set-Content -Path $stateFilePath -Value $json -Encoding UTF8
}

function Test-ToolInstalled {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Tool
    )

    if ($Tool.Name -eq 'MSVC Build Tools') {
        return (Test-VisualCppBuildToolsInstalled)
    }

    foreach ($commandName in $Tool.Commands) {
        if (Test-CommandAvailable -Name $commandName) {
            return $true
        }
    }

    return $false
}

function Test-WingetPackageInstalled {
    param(
        [Parameter(Mandatory)]
        [string]$Id
    )

    if (-not (Test-CommandAvailable -Name 'winget')) {
        return $false
    }

    $output = & winget list --id $Id --exact --accept-source-agreements 2>$null | Out-String
    return $output -match [regex]::Escape($Id)
}

function Install-WithWinget {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Tool
    )

    if (-not (Test-CommandAvailable -Name 'winget')) {
        return $false
    }

    $commonArguments = @(
        'install',
        '--id', $Tool.WingetId,
        '--exact',
        '--accept-package-agreements',
        '--accept-source-agreements',
        '--silent',
        '--disable-interactivity'
    )

    if ($Tool.WingetArgs -and $Tool.WingetArgs.Count -gt 0) {
        $commonArguments += $Tool.WingetArgs
    }

    Write-Status "Trying winget id: $($Tool.WingetId)"
    & winget @commonArguments
    if ($LASTEXITCODE -eq 0) {
        return $true
    }

    if ($Tool.WingetName) {
        $nameArguments = @(
            'install',
            '--name', $Tool.WingetName,
            '--accept-package-agreements',
            '--accept-source-agreements',
            '--silent',
            '--disable-interactivity'
        )

        Write-Status "Winget id failed, trying winget name: $($Tool.WingetName)"
        & winget @nameArguments
        if ($LASTEXITCODE -eq 0) {
            return $true
        }
    }

    return $false
}

function Install-WithChocolatey {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Tool
    )

    if (-not $Tool.ChocoPackage) {
        return $false
    }

    if (-not (Test-CommandAvailable -Name 'choco')) {
        return $false
    }

    Write-Status "Trying chocolatey: $($Tool.ChocoPackage)"
    & choco install $Tool.ChocoPackage --yes --no-progress
    return ($LASTEXITCODE -eq 0)
}

function Install-WithScoop {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Tool
    )

    if (-not $Tool.ScoopPackage) {
        return $false
    }

    if (-not (Test-CommandAvailable -Name 'scoop')) {
        return $false
    }

    Write-Status "Trying scoop: $($Tool.ScoopPackage)"
    & scoop install $Tool.ScoopPackage
    return ($LASTEXITCODE -eq 0)
}

function Uninstall-WithWinget {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Tool
    )

    if (-not (Test-CommandAvailable -Name 'winget')) {
        return $false
    }

    $idArguments = @(
        'uninstall',
        '--id', $Tool.WingetId,
        '--exact',
        '--accept-source-agreements',
        '--silent',
        '--disable-interactivity'
    )

    Write-Status "Trying winget uninstall by id: $($Tool.WingetId)"
    & winget @idArguments
    if ($LASTEXITCODE -eq 0) {
        return $true
    }

    if ($Tool.WingetName) {
        $nameArguments = @(
            'uninstall',
            '--name', $Tool.WingetName,
            '--accept-source-agreements',
            '--silent',
            '--disable-interactivity'
        )

        Write-Status "Winget uninstall by id failed, trying name: $($Tool.WingetName)"
        & winget @nameArguments
        if ($LASTEXITCODE -eq 0) {
            return $true
        }
    }

    return $false
}

function Uninstall-WithChocolatey {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Tool
    )

    if (-not $Tool.ChocoPackage) {
        return $false
    }

    if (-not (Test-CommandAvailable -Name 'choco')) {
        return $false
    }

    Write-Status "Trying chocolatey uninstall: $($Tool.ChocoPackage)"
    & choco uninstall $Tool.ChocoPackage --yes --no-progress
    return ($LASTEXITCODE -eq 0)
}

function Uninstall-WithScoop {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Tool
    )

    if (-not $Tool.ScoopPackage) {
        return $false
    }

    if (-not (Test-CommandAvailable -Name 'scoop')) {
        return $false
    }

    Write-Status "Trying scoop uninstall: $($Tool.ScoopPackage)"
    & scoop uninstall $Tool.ScoopPackage
    return ($LASTEXITCODE -eq 0)
}

function Uninstall-Tool {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Tool
    )

    if (-not $PSCmdlet.ShouldProcess($Tool.Name, 'Uninstall')) {
        return 'skipped-whatif'
    }

    if (Uninstall-WithWinget -Tool $Tool) {
        return 'uninstalled-winget'
    }

    if (Uninstall-WithChocolatey -Tool $Tool) {
        return 'uninstalled-choco'
    }

    if (Uninstall-WithScoop -Tool $Tool) {
        return 'uninstalled-scoop'
    }

    if (-not (Test-ToolInstalled -Tool $Tool)) {
        return 'already-absent'
    }

    Write-Warning "Could not auto-uninstall $($Tool.Name). Remove manually: $($Tool.ManualUrl)"
    return 'manual-required'
}

function Install-Tool {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Tool
    )

    if (-not $Force.IsPresent) {
        if (Test-ToolInstalled -Tool $Tool) {
            Write-Status "Already installed: $($Tool.Name)"
            return 'already-installed'
        }

        if (Test-WingetPackageInstalled -Id $Tool.WingetId) {
            Write-Status "Already installed (winget): $($Tool.Name)"
            return 'already-installed'
        }
    }

    if (-not $PSCmdlet.ShouldProcess($Tool.Name, 'Install')) {
        return 'skipped-whatif'
    }

    if (Install-WithWinget -Tool $Tool) {
        return 'installed-winget'
    }

    if (Install-WithChocolatey -Tool $Tool) {
        return 'installed-choco'
    }

    if (Install-WithScoop -Tool $Tool) {
        return 'installed-scoop'
    }

    Write-Warning "Could not auto-install $($Tool.Name). Install manually: $($Tool.ManualUrl)"
    return 'manual-required'
}

function Get-DevTools {
    $requiredTools = @(
        [pscustomobject]@{
            Name = 'Git'
            Commands = @('git')
            WingetId = 'Git.Git'
            WingetName = 'Git'
            ChocoPackage = 'git'
            ScoopPackage = 'git'
            WingetArgs = @()
            ManualUrl = 'https://git-scm.com/download/win'
        },
        [pscustomobject]@{
            Name = 'Rustup (Rust + Cargo)'
            Commands = @('rustup', 'cargo')
            WingetId = 'Rustlang.Rustup'
            WingetName = 'Rustup'
            ChocoPackage = 'rustup.install'
            ScoopPackage = 'rustup'
            WingetArgs = @()
            ManualUrl = 'https://rustup.rs/'
        },
        [pscustomobject]@{
            Name = 'MSVC Build Tools'
            Commands = @('cl')
            WingetId = 'Microsoft.VisualStudio.2022.BuildTools'
            WingetName = 'Visual Studio Build Tools 2022'
            ChocoPackage = 'visualstudio2022buildtools'
            ScoopPackage = $null
            WingetArgs = @(
                '--override', '--quiet --wait --norestart --nocache --installPath C:\\BuildTools --add Microsoft.VisualStudio.Workload.VCTools'
            )
            ManualUrl = 'https://visualstudio.microsoft.com/visual-cpp-build-tools/'
        }
    )

    $optionalTools = @(
        [pscustomobject]@{
            Name = 'GitHub CLI'
            Commands = @('gh')
            WingetId = 'GitHub.cli'
            WingetName = 'GitHub CLI'
            ChocoPackage = 'gh'
            ScoopPackage = 'gh'
            WingetArgs = @()
            ManualUrl = 'https://cli.github.com/'
        },
        [pscustomobject]@{
            Name = 'jq'
            Commands = @('jq')
            WingetId = 'jqlang.jq'
            WingetName = 'jq'
            ChocoPackage = 'jq'
            ScoopPackage = 'jq'
            WingetArgs = @()
            ManualUrl = 'https://jqlang.github.io/jq/download/'
        },
        [pscustomobject]@{
            Name = 'hyperfine'
            Commands = @('hyperfine')
            WingetId = 'sharkdp.hyperfine'
            WingetName = 'hyperfine'
            ChocoPackage = 'hyperfine'
            ScoopPackage = 'hyperfine'
            WingetArgs = @()
            ManualUrl = 'https://github.com/sharkdp/hyperfine/releases'
        }
    )

    $tools = @()
    $tools += $requiredTools

    if ($IncludeOptionalTools.IsPresent) {
        $tools += $optionalTools
    }

    if ($IncludeWsl.IsPresent) {
        $tools += [pscustomobject]@{
            Name = 'WSL'
            Commands = @('wsl')
            WingetId = 'Microsoft.WSL'
            WingetName = 'Windows Subsystem for Linux'
            ChocoPackage = 'wsl2'
            ScoopPackage = $null
            WingetArgs = @()
            ManualUrl = 'https://learn.microsoft.com/windows/wsl/install'
        }
    }

    return $tools
}

if (-not (Test-CommandAvailable -Name 'winget')) {
    Write-Warning 'winget is not available on this machine. Install App Installer from Microsoft Store.'
}

$toolList = Get-DevTools
$results = @()

if ($Uninstall.IsPresent) {
    Write-Status 'Starting uninstall mode.'
    $state = Get-InstallState

    $stateByToolName = @{}
    foreach ($stateItem in $state) {
        if ($stateItem.Tool) {
            $stateByToolName[$stateItem.Tool] = $stateItem
        }
    }

    $toolsToUninstall = @()
    foreach ($tool in $toolList) {
        if ($stateByToolName.ContainsKey($tool.Name)) {
            $toolsToUninstall += $tool
        }
    }

    if ($toolsToUninstall.Count -eq 0) {
        Write-Warning "No installed tools tracked in $stateFilePath for the selected flags."
        Write-Warning 'Use -IncludeOptionalTools and/or -IncludeWsl when uninstalling, or remove manually.'
    }

    foreach ($tool in $toolsToUninstall) {
        try {
            $status = Uninstall-Tool -Tool $tool
            $results += [pscustomobject]@{
                Tool = $tool.Name
                Status = $status
            }
        } catch {
            Write-Warning "Failed to uninstall $($tool.Name): $($_.Exception.Message)"
            $results += [pscustomobject]@{
                Tool = $tool.Name
                Status = 'error'
            }
        }
    }

    $remainingState = @()
    foreach ($entry in $state) {
        $hasResult = $results | Where-Object { $_.Tool -eq $entry.Tool }
        if (-not $hasResult) {
            $remainingState += $entry
            continue
        }

        $status = ($hasResult | Select-Object -First 1).Status
        if ($status -notin @('uninstalled-winget', 'uninstalled-choco', 'uninstalled-scoop', 'already-absent')) {
            $remainingState += $entry
        }
    }

    if ($remainingState.Count -eq 0) {
        if (Test-Path -Path $stateFilePath) {
            Remove-Item -Path $stateFilePath -Force -ErrorAction SilentlyContinue
        }
    } else {
        Save-InstallState -State $remainingState
    }

    Write-Host ''
    Write-Host 'Uninstall summary:'
    if ($results.Count -gt 0) {
        $results | Format-Table -AutoSize
    } else {
        Write-Host 'No tracked tools to uninstall for current selection.'
    }
} else {
    Write-Status "Starting tool installation. IncludeOptionalTools=$($IncludeOptionalTools.IsPresent), IncludeWsl=$($IncludeWsl.IsPresent), Force=$($Force.IsPresent)"

    $state = Get-InstallState
    $stateByToolName = @{}
    foreach ($stateItem in $state) {
        if ($stateItem.Tool) {
            $stateByToolName[$stateItem.Tool] = $stateItem
        }
    }

    foreach ($tool in $toolList) {
        try {
            $status = Install-Tool -Tool $tool
            $results += [pscustomobject]@{
                Tool = $tool.Name
                Status = $status
            }

            if ($status -in @('installed-winget', 'installed-choco', 'installed-scoop')) {
                $stateByToolName[$tool.Name] = [pscustomobject]@{
                    Tool = $tool.Name
                    WingetId = $tool.WingetId
                    WingetName = $tool.WingetName
                    ChocoPackage = $tool.ChocoPackage
                    ScoopPackage = $tool.ScoopPackage
                    InstalledAt = (Get-Date).ToString('o')
                    InstalledBy = $status
                }
            }
        } catch {
            Write-Warning "Failed to install $($tool.Name): $($_.Exception.Message)"
            $results += [pscustomobject]@{
                Tool = $tool.Name
                Status = 'error'
            }
        }
    }

    Save-InstallState -State @($stateByToolName.Values)

    Write-Host ''
    Write-Host 'Installation summary:'
    $results | Format-Table -AutoSize
}

Write-Host ''
Write-Host 'Post-install validation commands:'
Write-Host '  git --version'
Write-Host '  rustup --version'
Write-Host '  cargo --version'
Write-Host '  cargo fmt --all --check'
Write-Host '  cargo clippy --all-targets'
Write-Host '  cargo test'

if ($IncludeOptionalTools.IsPresent) {
    Write-Host '  gh --version'
    Write-Host '  jq --version'
    Write-Host '  hyperfine --version'
}

if ($IncludeWsl.IsPresent) {
    Write-Host '  wsl --status'
}

Write-Host ''
if ($Uninstall.IsPresent) {
    Write-Host 'To remove RTK itself, run: cargo uninstall rtk'
} else {
    Write-Host 'If cargo is still unavailable, restart the terminal (or log off/on) to refresh PATH.'
}
