## 1. Audit Copilot-facing sources

- [x] 1.1 Review the Copilot instruction source files and prompt templates for command examples that still use `rtk`.
- [x] 1.2 Identify any generated or derivative docs that are fed by those sources and need the binary name refreshed.

## 2. Update binary references

- [x] 2.1 Replace user-facing command examples with `rtk-windows` in the Copilot instruction source of truth.
- [x] 2.2 Update related prompt or docs templates so regenerated guidance matches the renamed binary.
- [x] 2.3 Preserve legacy `rtk` mentions only where they are explicitly labeled as upstream or historical context.

## 3. Validate consistency

- [x] 3.1 Search for remaining Copilot-facing `rtk` references and confirm they are intentional.
- [x] 3.2 Verify the change status shows proposal, specs, design, and tasks as complete before applying.