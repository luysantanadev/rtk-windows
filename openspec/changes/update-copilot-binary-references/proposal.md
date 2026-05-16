## Why

The fork now uses `rtk-windows` as its canonical binary name, but some Copilot-facing instructions and reference docs still emit `rtk`. That mismatch creates broken commands, inconsistent onboarding, and outdated guidance in the exact places contributors rely on most.

## What Changes

- Update Copilot-facing instructions and generated command examples to use `rtk-windows` as the default binary name.
- Remove or rewrite legacy `rtk` references where they would mislead users or the Copilot-generated guidance.
- Keep historical `rtk` references only when they are explicitly labeled as upstream or legacy context.
- Align command snippets in maintained docs with the renamed binary so the generated guidance matches the installed executable.

## Capabilities

### New Capabilities

- None.

### Modified Capabilities

- `fork-identity-version-lineage`: the requirement for binary identity and usage guidance changes to consistently present `rtk-windows` in Copilot instructions and related documentation output.

## Impact

- Affects Copilot instruction templates, generated command examples, and maintained documentation that references the executable name.
- No runtime behavior changes are expected.
- Reduces confusion for Windows users and prevents Copilot from suggesting commands for the wrong binary name.