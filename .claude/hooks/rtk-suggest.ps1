param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$inputRaw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($inputRaw)) { exit 0 }

$payload = $inputRaw | ConvertFrom-Json
$cmd = [string]($payload.tool_input.command)
if ([string]::IsNullOrWhiteSpace($cmd)) { exit 0 }

$firstCmd = $cmd
if ($firstCmd -match '^\s*(rtk\s+|.*/rtk\s+)') { exit 0 }
if ($firstCmd.Contains('<<')) { exit 0 }

$suggestion = ''

switch -Regex ($firstCmd) {
    '^git\s+status(\s|$)' { $suggestion = 'rtk git status'; break }
    '^git\s+diff(\s|$)' { $suggestion = 'rtk git diff'; break }
    '^git\s+log(\s|$)' { $suggestion = 'rtk git log'; break }
    '^git\s+add(\s|$)' { $suggestion = 'rtk git add'; break }
    '^git\s+commit(\s|$)' { $suggestion = 'rtk git commit'; break }
    '^git\s+push(\s|$)' { $suggestion = 'rtk git push'; break }
    '^git\s+pull(\s|$)' { $suggestion = 'rtk git pull'; break }
    '^git\s+branch(\s|$)' { $suggestion = 'rtk git branch'; break }
    '^git\s+fetch(\s|$)' { $suggestion = 'rtk git fetch'; break }
    '^git\s+stash(\s|$)' { $suggestion = 'rtk git stash'; break }
    '^git\s+show(\s|$)' { $suggestion = 'rtk git show'; break }
    '^gh\s+(pr|issue|run)(\s|$)' { $suggestion = ($cmd -replace '^gh\s+', 'rtk gh '); break }
    '^cargo\s+test(\s|$)' { $suggestion = 'rtk cargo test'; break }
    '^cargo\s+build(\s|$)' { $suggestion = 'rtk cargo build'; break }
    '^cargo\s+clippy(\s|$)' { $suggestion = 'rtk cargo clippy'; break }
    '^cargo\s+check(\s|$)' { $suggestion = 'rtk cargo check'; break }
    '^cargo\s+install(\s|$)' { $suggestion = 'rtk cargo install'; break }
    '^cargo\s+nextest(\s|$)' { $suggestion = 'rtk cargo nextest'; break }
    '^cargo\s+fmt(\s|$)' { $suggestion = 'rtk cargo fmt'; break }
    '^cat\s+' { $suggestion = ($cmd -replace '^cat\s+', 'rtk read '); break }
    '^(rg|grep)\s+' { $suggestion = ($cmd -replace '^(rg|grep)\s+', 'rtk grep '); break }
    '^ls(\s|$)' { $suggestion = ($cmd -replace '^ls', 'rtk ls'); break }
    '^tree(\s|$)' { $suggestion = ($cmd -replace '^tree', 'rtk tree'); break }
    '^find\s+' { $suggestion = ($cmd -replace '^find\s+', 'rtk find '); break }
    '^diff\s+' { $suggestion = ($cmd -replace '^diff\s+', 'rtk diff '); break }
    '^docker\s+(ps|images|logs)(\s|$)' { $suggestion = ($cmd -replace '^docker\s+', 'rtk docker '); break }
    '^kubectl\s+(get|logs)(\s|$)' { $suggestion = ($cmd -replace '^kubectl\s+', 'rtk kubectl '); break }
    '^curl\s+' { $suggestion = ($cmd -replace '^curl\s+', 'rtk curl '); break }
    '^wget\s+' { $suggestion = ($cmd -replace '^wget\s+', 'rtk wget '); break }
    '^pnpm\s+(list|ls|outdated)(\s|$)' { $suggestion = ($cmd -replace '^pnpm\s+', 'rtk pnpm '); break }
}

if ([string]::IsNullOrWhiteSpace($suggestion)) { exit 0 }

@{
    hookSpecificOutput = @{
        hookEventName = 'PreToolUse'
        permissionDecision = 'allow'
        systemMessage = "RTK available: `$suggestion` (60-90% token savings)"
    }
} | ConvertTo-Json -Depth 10 -Compress
