## Context

RTK already ships an OpenCode plugin (`hooks/opencode/rtk.ts`) and installation lifecycle paths in `rtk init`, but the behavior contract is currently spread across code and documentation. This creates drift risk across plugin rewrite behavior, `rtk init --opencode` user flows, and verification/troubleshooting docs. The change introduces an explicit spec-level contract so future edits to hooks and docs remain aligned.

## Goals / Non-Goals

**Goals:**
- Define a normative OpenCode lifecycle contract (install, update, verify, uninstall) that matches actual CLI behavior.
- Make OpenCode rewrite behavior explicitly consistent with command rewrite registry guarantees, including compound commands and passthrough.
- Ensure user-facing status and troubleshooting outputs are deterministic and testable.
- Reduce maintenance drift by making docs and tests derive from the same requirements.

**Non-Goals:**
- Replacing OpenCode plugin architecture or introducing a new plugin runtime.
- Redesigning global `rtk init` UX for all agents.
- Expanding rewrite coverage beyond existing RTK command families.
- Introducing telemetry, remote services, or new external dependencies.

## Decisions

1. Capability split: introduce a dedicated `opencode-integration-lifecycle` spec and keep rewrite semantics in `command-rewrite-registry`.
- Rationale: lifecycle and rewrite concerns evolve at different rates; separating them avoids coupling install behavior to rewrite algorithm details.
- Alternative considered: place all OpenCode behavior in `command-rewrite-registry`; rejected because lifecycle invariants are not rewrite rules.

2. OpenCode remains global-only for installation.
- Rationale: plugin placement and OpenCode configuration model are global by nature (`~/.config/opencode/plugins/rtk.ts`), and current CLI behavior already enforces this.
- Alternative considered: project-local OpenCode plugin support; rejected for now due to undefined OpenCode-local plugin workflow and migration complexity.

3. Reuse existing hook lifecycle helpers in `src/hooks/init.rs` and `src/hooks/hook_check.rs` instead of adding a parallel installer.
- Rationale: minimizes code paths and preserves existing idempotent write/remove checks.
- Alternative considered: dedicated OpenCode installer module; rejected as unnecessary duplication.

4. Enforce rewrite consistency through spec scenarios and focused tests on `hooks/opencode/rtk.ts` behavior.
- Rationale: plugin-level regressions are easier to catch with behavior tests than with doc-only assertions.
- Alternative considered: only update docs and rely on manual testing; rejected due to regression risk.

## Risks / Trade-offs

- [Spec-code mismatch during rollout] -> Mitigation: update specs first, then align code/tests in same implementation change.
- [Over-constraining OpenCode behavior could slow future plugin upgrades] -> Mitigation: keep requirements focused on externally observable outcomes, not internal implementation details.
- [Cross-agent rewrite parity regressions] -> Mitigation: keep command rewrite registry as shared source of truth and add OpenCode-specific scenarios without duplicating full command matrices.
- [User confusion around global-only limitation] -> Mitigation: explicit error/help messaging and troubleshooting docs.
