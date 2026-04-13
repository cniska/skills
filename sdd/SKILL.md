---
name: sdd
description: Ground implementation decisions in primary sources. Use when adopting libraries, APIs, SDKs, or version-sensitive behavior.
---

# Source-driven development

Implement against primary sources, not memory. Confirm behavior in official docs, specs, or upstream code before committing to an approach.

## Workflow

1. **List claims**: identify framework or library claims in the task (API shape, lifecycle, limits, defaults).
2. **Find primary sources**: prefer official docs, language specs, maintainers' references, and upstream source.
3. **Pin versions**: verify docs match the version used in this repo.
4. **Implement to source**: choose patterns and APIs that the source explicitly supports.
5. **Record evidence**: capture links or short notes in PR/issue comments when behavior is non-obvious.
6. **Verify locally**: run tests or a minimal reproduction proving the source-backed behavior.

## Source quality order

1. Official product/library documentation
2. Language/runtime specifications
3. Maintainer-authored examples or release notes
4. Upstream source code
5. Third-party blogs and forum posts (supporting evidence only)

## See also

- `design` for contract-first boundaries
- `build` for vertical slicing after source confirmation
- `references/testing-patterns.md` for proof-oriented verification

## Red flags

- Implementing from memory for version-sensitive APIs
- Treating third-party blog posts as authoritative sources
- Mixing docs from different major versions
- Shipping code without validating source-backed assumptions
