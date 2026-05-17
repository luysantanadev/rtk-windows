# CI/CD Flows

## PR Quality Gates (ci.yml)

Trigger: pull_request to develop or main

```
                          ┌──────────────────┐
                          │    PR opened      │
                          └────────┬─────────┘
                                   │
                          ┌────────▼─────────┐
                          │    fmt --all     │
                          └────────┬─────────┘
                                   │
                       ┌───────────▼──────────┐
                       │ clippy --all-targets │
                       └───┬───┬───┬───┬───┬──┘
                           │   │   │   │   │
           ┌───────────────┘   │   │   │   └────────────────┐
           │       ┌───────────┘   │   └───────────┐        │
           ▼       ▼              ▼               ▼        ▼
     ┌──────────┐ ┌──────────┐ ┌───────────┐ ┌─────────┐ ┌──────────┐
     │ test     │ │ security │ │ semgrep   │ │benchmark│ │ doc      │
     │ ubuntu   │ │ cargo    │ │ AST-aware │ │ >=80%   │ │ review   │
     │ windows  │ │ audit    │ │ diff-only │ │ savings │ │ ai agent │
     │ macos    │ │ patterns │ │           │ │         │ │          │
     └────┬─────┘ └────┬─────┘ └─────┬─────┘ └────┬────┘ └────┬─────┘
          │            │             │             │            │
          └────────────┴─────────┬───┴─────────────┴────────────┘
                                 │
                      ┌──────────▼─────────┐
                      │  All must pass     │
                      │  to merge          │
                      └────────────────────┘

     + DCO check (independent, develop PRs only)
     + Dependabot (weekly: Cargo deps + GitHub Actions)
```

## Merge to develop — pre-release (cd.yml)

Trigger: push to develop | workflow_dispatch (not main) | Concurrency: cancel-in-progress

```
     ┌──────────────────┐
     │ push to develop   │
     │ OR dispatch       │
     └────────┬─────────┘
              │
     ┌────────▼──────────────────┐
     │ pre-release                │
     │ compute next version      │
     │ from conventional commits │
     │ baseline: v0.0.0 if no tag│
     │ tag = dev-{next}-rc.{run} │
     └────────┬──────────────────┘
              │
     ┌────────▼──────────────────┐
     │ release.yml               │
     │ Windows x86_64 only       │
     │ prerelease = true         │
     └────────┬──────────────────┘
              │
     ┌────────▼──────────────────┐
     │ Build (windows-latest)    │
     │ rtk-windows-x86_64-pc-    │
     │ msvc.zip                  │
     └────────┬──────────────────┘
              │
     ┌────────▼──────────────────┐
     │ GitHub Release            │
     │ (pre-release badge)       │
     │ token: GITHUB_TOKEN       │
     └──────────────────────────┘
```

## Merge to main — stable release (cd.yml)

Trigger: push to main (only) | Concurrency: never cancelled

```
     ┌──────────────────┐
     │ push to main      │
     └────────┬─────────┘
              │
     ┌────────▼──────────────────┐
     │ stable-release             │
     │ compute next version      │
     │ from conventional commits │
     │ baseline: v0.0.0 if no tag│
     │ tag = v{MAJOR}.{MINOR}.   │
     │       {PATCH}             │
     └────────┬──────────────────┘
              │
         ┌────┴──────────────────┐
         │                       │
    tag exists               new tag
    (idempotent)                 │
         │                       ▼
         ▼              ┌────────────────────┐
      skipped           │ release.yml        │
                        │ Windows x86_64 only│
                        │ prerelease = false │
                        └────────┬───────────┘
                                 │
                        ┌────────▼───────────┐
                        │ Build              │
                        │ rtk-windows-x86_64-│
                        │ windows-msvc.zip   │
                        └────────┬───────────┘
                                 │
                        ┌────────▼───────────┐
                        │ GitHub Release     │
                        │ (stable badge)     │
                        │ token: GITHUB_TOKEN│
                        └────────────────────┘
```

## Manual release (release.yml)

Trigger: workflow_dispatch

```
     ┌────────────────────────┐
     │ workflow_dispatch       │
     │ inputs: tag, prerelease │
     └───────────┬────────────┘
                 │
     ┌───────────▼────────────┐
     │ Build pipeline          │
     │ Windows x86_64 only     │
     └───────────┬────────────┘
                 │
          ┌──────┴──────┐
          │             │
   prerelease=false  prerelease=true
          │             │
          ▼             ▼
     GitHub Release  GitHub Release
     (stable badge)  (pre-release badge)
```

