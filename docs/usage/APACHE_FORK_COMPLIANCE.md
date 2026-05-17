# Apache-2.0 Fork Compliance Checklist

This checklist defines the minimum legal and documentation checks before publishing a source or binary release from this fork.

## Scope

- Applies to all public releases (pre-release and stable).
- Applies to source archives, release notes, and binary artifacts.

## Pre-Release Checklist

- [ ] `LICENSE` exists in repository root and contains Apache License 2.0 text.
- [ ] Upstream copyright/attribution notices are preserved.
- [ ] Modified files include a prominent change notice where applicable.
- [ ] README states this repository is an unofficial fork.
- [ ] README and release text state non-affiliation/non-endorsement by upstream maintainers.
- [ ] Branding and wording do not imply official upstream sponsorship.
- [ ] Release notes include a link to this compliance checklist as evidence.

## Release Notes Evidence

Include a section like:

```md
## Compliance
- Apache-2.0 license and attribution notices preserved.
- This repository is an unofficial fork and is not endorsed by upstream maintainers.
- Checklist: docs/usage/APACHE_FORK_COMPLIANCE.md
```

## Operational Guidance

- If upstream introduces a `NOTICE` file, include applicable notices in redistributed artifacts.
- For high-risk legal scenarios (enterprise redistribution, trademark disputes, dual-licensing), obtain legal review before release.

## Non-Legal Advice Notice

This checklist is an operational compliance aid and not legal advice.
