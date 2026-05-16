## Context

Currently, `release.yml` compiles RTK for 5 targets across 3 operating systems:
- **macOS**: x86_64, aarch64 (ARM)
- **Linux**: x86_64-musl (static), aarch64-gnu (cross-compile)
- **Windows**: x86_64-msvc

Each build takes ~5-8 minutes; total release cycle ~40 minutes. Additionally, DEB and RPM packages are built for Linux distribution channels. GitHub Actions matrix parallelizes compilation, but startup/teardown overhead remains significant.

**Pipeline cost**: ~$0.50–1.00 per release in Actions minutes.  
**Maintenance burden**: Cross-platform shell escaping bugs, dependency matrix complexity, platform-specific build issues.

## Goals / Non-Goals

**Goals:**
- Reduce release pipeline execution time from 40 minutes to <10 minutes
- Eliminate multi-platform build infrastructure (remove DEB, RPM, cross-compile tooling)
- Simplify CI/CD matrix to single Windows target
- Maintain binary release artifacts for Windows users
- Reduce operational complexity (fewer moving parts to debug)

**Non-Goals:**
- Do NOT remove Rust multi-platform support in codebase (code must still compile on any platform locally)
- Do NOT deprecate macOS/Linux support entirely—users can still `cargo install --path .`
- Do NOT remove CI quality gates (fmt, clippy, test must run on all commits)
- Do NOT remove `cargo.toml` dependencies or platform-agnostic tests

## Decisions

**Decision 1: Remove all non-Windows targets from release.yml**
- **Choice**: Keep only `x86_64-pc-windows-msvc` in build matrix
- **Rationale**: Focus on Windows for now; macOS/Linux developers can compile from source or use old releases
- **Alternative considered**: Keep macOS x86_64 only → still 40% overhead; dismissed to maximize simplification
- **Impact**: Release artifacts available only for Windows

**Decision 2: Remove DEB and RPM build jobs**
- **Choice**: Delete `build-deb` and `build-rpm` jobs entirely from release.yml
- **Rationale**: Debian/RedHat package managers are distribution channels that depend on multi-platform support; no Windows equivalent
- **Alternative considered**: Publish DEB/RPM alongside Windows binary → contradicts Windows-only goal
- **Impact**: Homebrew and Linux repos cannot be updated; legacy releases remain available

**Decision 3: Single-target build means no artifact array**
- **Choice**: Build matrix becomes trivial (single OS); can inline build steps or keep matrix for future expansion
- **Rationale**: Keep matrix structure for clarity; easier to re-add targets later
- **Impact**: Faster pipeline setup since GitHub Actions only spins up one runner

**Decision 4: Update documentation to reflect Windows-only release**
- **Choice**: README.md, INSTALL.md, docs/guide updated to note Windows-only binaries
- **Rationale**: Users must know pre-compiled binaries are Windows only; local builds remain supported
- **Alternative considered**: Keep docs silent and only communicate in release notes → worse UX
- **Impact**: Clear user expectations during onboarding

## Risks / Trade-offs

| Risk | Mitigation |
|------|-----------|
| **macOS/Linux users excluded from pre-built binaries** | Document "cargo install --path ." workaround; maintain old releases; consider re-adding targets if demand increases |
| **Rust CI (fmt, clippy, test) only runs on Windows** | Acceptable: Rust's type system + tests catch most cross-platform issues; code still compiles on user machines for their target |
| **Maintenance debt when re-adding macOS/Linux** | Keep release.yml architecture (matrix, artifact upload) unchanged; only restore target entries |
| **Users on macOS/Linux behind firewalls may struggle with `cargo install`** | Out of scope; encourage local compilation or pre-built distribution channels external to GitHub |
| **Release artifacts become Windows-only lock-in** | Mitigated by supporting cross-compilation from source; RTK remains MIT-licensed, anyone can fork and add platforms |

## Migration Plan

1. **Phase 1 (Breaking)**: Modify `.github/workflows/release.yml`
   - Remove matrix entries: macOS x86_64, macOS aarch64, Linux musl, Linux aarch64-gnu
   - Remove `build-deb` and `build-rpm` jobs
   - Simplify to single Windows target

2. **Phase 2 (Documentation)**: Update README and guides
   - Add section: "Platform Support: Currently Windows binaries only; compile from source for macOS/Linux"
   - Update INSTALL.md with `cargo install` instructions for non-Windows users
   - Note that Homebrew updates are suspended

3. **Phase 3 (Release)**: Publish as v{next} with BREAKING label
   - Include migration note in changelog
   - Post community announcement

4. **Rollback**: If critical user impact, revert release.yml matrix to previous state and republish

## Open Questions

1. **Should CI (ci.yml) remain multi-platform?**  
   → Proposal: Keep Windows only (reduces CI cost). Trade-off: Misses cross-platform bugs caught in test phase.

2. **How long will this be Windows-only?**  
   → Depends on business needs; no hard timeline to re-add platforms

3. **Should RTK maintain a pre-compiled fork for macOS/Linux (e.g., on a separate branch)?**  
   → Out of scope for this change; can be handled as future infrastructure project
