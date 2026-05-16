# RTK Documentation — Interface Contract

This directory contains user-facing documentation for the RTK website.
It feeds `https://github.com/luysantanadev/rtk-windows.git-website` via the `prepare-docs.mjs` pipeline.

**Scope**: `docs/guide/` is website content only. Technical and contributor documentation
lives in the codebase (distributed, co-located pattern):
- `ARCHITECTURE.md` — System design, ADRs, filtering strategies
- `CONTRIBUTING.md` — Design philosophy, PR process, TOML vs Rust
- `SECURITY.md` — Vulnerability policy
- `src/*/README.md` — Per-module implementation docs
- `hooks/README.md` — Hook system and agent integrations

## Structure

```
docs/
  README.md      <- This file (interface contract — do not remove)
  guide/         -> User-facing documentation (website "Guide" tab)
    index.md
    getting-started/
      installation.md
      quick-start.md
      supported-agents.md
    what-rtk-covers.md
    analytics/
      gain.md
    configuration.md
    troubleshooting.md
```

## Frontmatter (required on every .md)

Every markdown file under `docs/guide/` must include:

```yaml
---
title: string          # Page title (used in sidebar + search)
description: string    # One-line summary for search results and SEO
sidebar:
  order: number        # Position within the sidebar group (1 = first)
---
```

The `prepare-docs.mjs` pipeline validates this at build time and fails fast
if frontmatter is missing or malformed.

## Conventions

- **Filenames**: kebab-case, `.md` only
- **Subdirectories**: become sidebar groups in Starlight
- **Internal links**: relative (`./foo.md`, `../configuration.md`)
- **Diagrams**: Mermaid in fenced code blocks
- **Code samples**: always specify the language (`rust`, `toml`, `bash`)
- **Language**: English only
- **No `rtk-windows <cmd>` syntax**: users never type the wrapper prefix manually — hooks rewrite commands transparently.
  Only `rtk-windows gain`, `rtk-windows init`, `rtk-windows verify`, and `rtk-windows proxy` appear as user-typed commands.
