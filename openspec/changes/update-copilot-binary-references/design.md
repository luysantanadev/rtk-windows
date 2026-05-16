## Context

The repository is already Windows-first and the canonical fork binary name is `rtk-windows`, but command examples in generated guidance and related documentation can still drift back to `rtk`. That creates a mismatch between what Copilot is told to use and what users actually install and run.

This change is documentation- and instruction-generation-focused. It does not alter runtime command routing; it aligns the source-of-truth text that Copilot and maintainers read when generating command examples.

## Goals / Non-Goals

**Goals:**

- Make `rtk-windows` the default binary name in Copilot-facing instructions and generated command examples.
- Keep legacy `rtk` mentions only as explicit historical or upstream context.
- Update the source files that feed generated guidance so the renamed binary stays consistent over time.
- Verify that no Copilot-facing output still presents `rtk` as the primary executable name.

**Non-Goals:**

- Changing runtime behavior, command parsing, or hook execution semantics.
- Renaming internal Rust module names or historical architecture references that are not user-facing.
- Reworking the docs pipeline itself beyond the minimal text updates needed for the new binary name.

## Decisions

1. **Use `rtk-windows` as the canonical user-facing executable name.**
   - Rationale: the fork already distributes and supports that name, and it matches the current Copilot instruction file.
   - Alternatives considered: keeping `rtk` as the primary name with a note about Windows packaging, or introducing dual names. Both increase user confusion and make Copilot output less deterministic.

2. **Update source instruction text rather than manually patching every generated or derivative file.**
   - Rationale: Copilot-facing text is easiest to keep correct when the source template is authoritative.
   - Alternatives considered: editing only the rendered file or only the README snippets. That would leave other generated surfaces drifting back to the old name.

3. **Preserve `rtk` only in clearly marked legacy or upstream references.**
   - Rationale: historical context is useful, but it must not become the default command suggestion.
   - Alternatives considered: removing every `rtk` token everywhere. That would erase useful lineage references and can make docs harder to understand.

## Risks / Trade-offs

- [Docs drift] Source files can still regress if new instruction text is added without using the renamed binary -> Mitigation: keep a targeted search/validation step for Copilot-facing `rtk` references before merging.
- [Historical confusion] Some legacy mentions of `rtk` will remain in codebase history and internal architecture docs -> Mitigation: keep them explicitly labeled as upstream or historical context.
- [Generated output mismatch] If a template is missed, the Copilot-generated instructions can still surface the old name -> Mitigation: update the source-of-truth files first, then verify the rendered guidance.

## Migration Plan

1. Update the Copilot instruction source and any related prompt or documentation templates that generate command examples.
2. Regenerate or refresh the derived guidance files if the repository uses a docs pipeline for them.
3. Search for Copilot-facing `rtk` command examples and replace them with `rtk-windows` unless they are explicitly historical.
4. Verify the final diff with a targeted search so only intentional legacy references remain.

## Open Questions

- None. The change is constrained to naming consistency and does not require product decisions beyond the canonical binary name.