# RTK - Rust Token Killer

**Purpose**: CLI proxy that filters/compresses command output before it reaches your LLM context.
**Savings**: 60-90% token reduction on common development operations.

## Golden Rule

**Always prefix commands with `rtk`**. If RTK has a filter, it compresses output. If not, it passes through unchanged. RTK is always safe to use.

## Git (59-80% savings)
```bash
rtk git status    rtk git log    rtk git diff    rtk git show
rtk git add       rtk git commit rtk git push    rtk git pull
rtk git branch    rtk git fetch  rtk git stash   rtk git worktree
```
Also: `rtk gh` (GitHub CLI), `rtk gt` (Graphite), `rtk glab` (GitLab)

## Build & Lint (70-90% savings)
```bash
rtk cargo build   rtk cargo check  rtk cargo clippy  rtk cargo test
rtk tsc           rtk lint         rtk prettier --check  rtk next build
```

## Test (60-99% savings)
```bash
rtk cargo test    rtk go test    rtk jest    rtk vitest
rtk playwright test  rtk pytest  rtk rake test  rtk rspec
rtk test <cmd>    # Generic test wrapper — shows failures only
```

## Package Managers (70-90% savings)
```bash
rtk pnpm list     rtk pnpm outdated  rtk pnpm install
rtk npm run <script>  rtk npx <cmd>  rtk prisma
```

## Files & Search (60-75% savings)
```bash
rtk ls <path>     rtk read <file>  rtk grep <pattern>  rtk find <pattern>
rtk wc            rtk json <file>  rtk diff <file1> <file2>
```

## Infrastructure (85% savings)
```bash
rtk docker ps     rtk docker images  rtk docker logs <container>
rtk kubectl get   rtk kubectl logs
```

## Network (65-70% savings)
```bash
rtk curl <url>    rtk wget <url>
```

## Analysis & Debug
```bash
rtk err <cmd>     # Filter errors only from any command
rtk log <file>    # Deduplicated logs with counts
rtk env           # Environment variables (sensitive values masked)
rtk summary <cmd> # Smart summary of command output
rtk deps          # Project dependency overview
```

## Meta Commands (use rtk directly)
```bash
rtk gain                # Token savings analytics
rtk gain --history      # Command history with savings
rtk gain --project      # Project-scoped savings
rtk discover            # Find missed RTK opportunities in Claude history
rtk proxy <cmd>         # Run without filtering (track usage only)
rtk init                # Install RTK hooks for this project
rtk init -g             # Install RTK hooks globally
rtk config              # Show/create configuration
rtk verify              # Verify hook integrity
rtk trust               # Trust project-local TOML filters
rtk untrust             # Revoke trust for project filters
```

## Important Notes
- **Hook auto-rewrite**: The Claude Code hook automatically rewrites commands (e.g., `git status` → `rtk git status`). You can also prefix manually.
- **Command chains**: Use `rtk` on each segment: `rtk git add . && rtk cargo test && rtk git commit -m "msg"`
- **Name collision**: If `rtk gain` fails, you may have the wrong `rtk` package (Rust Type Kit). Verify with `rtk --version`.
