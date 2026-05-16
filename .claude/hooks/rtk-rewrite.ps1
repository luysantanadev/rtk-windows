param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-AuditLog {
    param(
        [string]$Action,
        [string]$Original,
        [string]$Rewritten = '-'
    )

    if ($env:RTK_HOOK_AUDIT -ne '1') {
        return
    }

    $dir = if ([string]::IsNullOrWhiteSpace($env:RTK_AUDIT_DIR)) {
        Join-Path $HOME '.local/share/rtk'
    }
    else {
        $env:RTK_AUDIT_DIR
    }

    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $line = "{0} | {1} | {2} | {3}" -f (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'), $Action, $Original, $Rewritten
    Add-Content -Path (Join-Path $dir 'hook-audit.log') -Value $line
}

if (-not (Get-Command rtk -ErrorAction SilentlyContinue)) {
    Write-AuditLog 'skip:no_deps' '-'
    exit 0
}

$inputRaw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($inputRaw)) {
    Write-AuditLog 'skip:empty' '-'
    exit 0
}

$payload = $inputRaw | ConvertFrom-Json
$cmd = [string]($payload.tool_input.command)

if ([string]::IsNullOrWhiteSpace($cmd)) {
    Write-AuditLog 'skip:empty' '-'
    exit 0
}

if ($cmd.Contains('<<')) {
    Write-AuditLog 'skip:heredoc' $cmd
    exit 0
}

$rewritten = ''
$exitCode = 0
try {
    $rewritten = (& rtk rewrite $cmd 2>$null | Out-String).Trim()
    $exitCode = 0
}
catch {
    $exitCode = if ($LASTEXITCODE) { $LASTEXITCODE } else { 1 }
}

switch ($exitCode) {
    0 {
        if ($cmd -eq $rewritten) {
            Write-AuditLog 'skip:already_rtk' $cmd
            exit 0
        }
    }
    1 {
        Write-AuditLog 'skip:no_match' $cmd
        exit 0
    }
    2 {
        Write-AuditLog 'skip:deny_rule' $cmd
        exit 0
    }
    3 {
        # Ask flow; continue and omit explicit permissionDecision.
    }
    default {
        exit 0
    }
}

Write-AuditLog 'rewrite' $cmd $rewritten

$originalInput = $payload.tool_input
$originalInput.command = $rewritten

$hookSpecificOutput = @{
    hookEventName = 'PreToolUse'
    updatedInput = $originalInput
}

if ($exitCode -ne 3) {
    $hookSpecificOutput.permissionDecision = 'allow'
    $hookSpecificOutput.permissionDecisionReason = 'RTK auto-rewrite'
}

@{ hookSpecificOutput = $hookSpecificOutput } | ConvertTo-Json -Depth 10 -Compress
