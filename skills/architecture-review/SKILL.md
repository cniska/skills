---
name: architecture-review
description: Review architecture, boundaries, and design consistency. Use when reviewing module boundaries, extension seams, or contract drift.
---

# Architecture Review

Review architecture quality, design consistency, extension seams, and pattern adherence.

## Scope

### 1. Indirection pressure (primary focus)

Flag layers that add no architectural value:

- runtime import cycles across split modules
- pass-through facades that only rename or re-export
- alias/wrapper layers without independent policy or invariants
- DI bags exceeding practical seam or testing needs
- singleton imports in library modules that should accept injected params — an application reading its own central store is idiomatic and not this finding
- facade-for-facade chains

Default: if a layer carries no policy, invariants, or boundary isolation, remove it.

### 2. Extension blockers

- hard-coded behavior where project docs or an existing sibling seam establish a policy/config point
- new features requiring edits across many unrelated modules
- private coupling preventing additive providers or plugins
- extension seams with no current use adding maintenance cost

### 3. Boundary and contract integrity

- contracts and schemas as source of truth
- renamed contract terms stay aligned across the boundary; partial renames count as drift
- dependency direction consistency
- design-pattern consistency for extension seams
- logic that reads another module's state more than its own; judge one function body at a time — how much of it traverses that module — not by whether the reference was injected or passed in
- chained access (`a.getB().getC()`) reaching past a stated contract into internals the caller doesn't own
- modules reaching into each other's internals instead of through a stated contract

### 4. Cohesion and responsibility

- oversized or multi-responsibility files — for a *file*, size alone isn't the finding, so name the second responsibility or don't report it
- SRP violations: mixing unrelated concerns
- at *function* scale length is a finding on its own: a body past ~50 lines, one needing section comments to navigate, or one that computes a result and then formats it for presentation. An exhaustive match or switch whose length is entirely its arms is not this — there is no substructure to lift out
- duplication wants a name once it is a substantial block repeated twice or a small one repeated three times, in one file or across modules — size and copy count trade off against each other, so a two-line body appearing seven times counts. Leave what is duplicated on purpose: boundary-local copies keeping two modules independent, and conditionally-compiled twins that merging would defeat

### 5. Portability and product fit

- hard-coded runtime/framework assumptions violating documented goals
- abstractions that look framework-first instead of product-first

## Evidence threshold

Only report issues with concrete evidence in code, contracts, or dependency flow. Prefer demonstrated issues over speculative concerns.

An evidenced pattern is not automatically a defect. Reads through an injected collaborator, a documented facade, or a central store are idiomatic in the architectures built on them — flag one only where it also crosses a boundary the project itself states.

## Workflow

1. Build expected architecture map from project docs.
2. Compare implementation against that map. For large diffs or audits spanning many modules, fan out **fast-tier** readers — one per module or boundary — to collect raw evidence. Verify findings in this session before reporting.
3. Run cycle and indirection pass on core entrypoints.
4. Check whether the change increases coupling or creates contract drift.
5. Report findings ordered by severity.

## Output

For each finding: **label** (Critical / Fix / Consider / Nit — see `review`), **impacted files**, **violated pattern**, **evidence**, **fix direction**.

- Bad: "Consider: UserService is doing a lot; could be more decoupled." (taste, no contract, no evidence)
- Good: **Fix** — `src/api/client.ts` imports `src/auth/session.ts` which imports it back (runtime cycle), violating the api→auth dependency direction in `docs/architecture.md`. Move `TokenStore` into `auth`.

Group as **Confirmed issues** | **Open questions** | **Optional refactors** (max 3, one line each; omit if empty). "No architectural findings" is a valid, complete result.

## See also

- `simplify` for performing the moves this review identifies
- `design` for the interface shape behind a boundary finding

## Red flags

- Suggesting speculative frameworks or plugin systems
- Broad rewrites instead of minimal structural fixes
- Treating taste-level preferences as defects
- Recommending abstractions with no current product use
- Over-indexing on DRY when duplication is boundary-local
