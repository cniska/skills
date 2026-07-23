---
name: spec
description: Create and maintain a specification that states what to build, not how. Use when writing a spec, editing requirements, or defining acceptance criteria.
---

# Spec

A spec states what must be true, never how to achieve it. Algorithms, specific API calls, data structures, byte offsets: those live in code or an architecture doc. The spec must be complete enough to reimplement from and precise enough to verify against. Every requirement is a claim someone can later prove or disprove.

Two modes, inferred from the request:

- **New** — draft a spec from a rough idea or a design conversation. Supply the structure so the user describes intent, not format.
- **Edit** — refine an existing spec: add requirements, strip the *how* that crept in, cross-check completeness against the code.

A spec need not arrive complete. It may start with a handful of FRs and grow one change at a time — the ID rules below make later growth safe.

When the source is an existing codebase rather than a design conversation, you are reverse-engineering the *what* from the *how*: the code says what the system does, never what the author intended. State each requirement as observed behavior and flag the ones you can't confirm as deliberate — a stopgap or a tuned default frozen as contract will drive future work toward preserving it. Mark the draft reverse-engineered and unverified against intent until a human confirms.

## Labelled requirements

Every requirement gets a stable ID: a two-letter family prefix and a number (`FR-12`, `NF-3`, `AC-9`). IDs are the spec's addressing system. Acceptance criteria cite the requirements they verify, tests cite the requirement they cover, and cross-references point by ID, not by prose.

Core families. Add domain families as the project needs (`ST` styling, `AU` auth, `SEC` security):

- **FR** — functional: what the tool does.
- **NF** — non-functional: performance, reliability, error behavior, testing.
- **AC** — acceptance criteria: the conditions that together mean "done".
- **D** — deliverables: the artifacts that must ship.
- **C** — constraints: fixed decisions the builder may not revisit — language, runtime, distribution, hard exclusions (step 4 draws the line against mere conventions).

Rules:

- **Never renumber.** IDs are permanent addresses. Renumbering silently breaks every cross-reference and every test that cites one. Append new requirements with the next free number.
- **Insert with a letter suffix** (`FR-21a`) only when a new item must sit beside a related one for reading order. Reordering for looks is not worth a broken reference.
- **One claim per ID.** A requirement with two independently-verifiable claims is two requirements.
- **Retire in place.** Removing a requirement never deletes its ID or renumbers around it. Mark it retired — `**FR-9** — *Retired (superseded by FR-38).*` — so no citation ever dangles.
- **Earn each family and each ID.** A dimension gets its own family only when it carries distinct, independently-verifiable claims, not just functional surface that could sit under FR. Aim for a spec you could reimplement from, not an exhaustive inventory; when two readers would land far apart on the requirement count, you are enumerating mechanism, not contract.

## Workflow

1. **Gather intent.** For a new spec, read the reference the user points to and the conversation so far; for an edit, read the current spec in full. Resolve remaining ambiguity by asking one question at a time, each with your recommended answer, instead of guessing.
2. **Cross-check against code** (when it exists). Every shipped behavior needs a requirement; every requirement needs a way to verify it. Enumerate the real surface from the source, not from memory: CLI flags, config format, error paths. A requirement the code contradicts is stale. Reconcile it.
3. **Draft from the template.** Fill the section skeleton in [`template.md`](template.md), assigning IDs as you go. Done when every section is filled or explicitly marked not-applicable.
4. **Sort what from how.** Any sentence naming an algorithm, a request shape, or an offset is *how*. Move it to the architecture doc and leave the requirement stating only the observable outcome. A fixed decision stays under Constraints only if reversing it would force a rewrite or change what the deliverable *is* — language, runtime, distribution form, hard exclusions like "no telemetry". A decision a tool could re-apply mechanically with every AC still passing — formatter, lint rules, indent width — is a convention: it lives in AGENTS.md, not the spec. A user-observable default (a default port, a timeout) is a requirement; the internal tuning value behind the same behavior is an open decision.
5. **Make edge cases requirements.** The constructs a naive build gets wrong are requirements, not nice-to-haves. Give each its own ID so it earns its own test.
6. **Separate constraints from open decisions.** Close with two explicit lists: what is fixed, and what is deliberately left to the builder. The silence between them is where scope disputes grow.
7. **Verify the traces close.** Each AC maps to the FRs it exercises; each edge-case requirement appears in the testing section. At scale one AC cannot cite every requirement — ACs then cover representative bundles and the per-requirement trace is carried by test citations. A requirement reached by neither an AC nor a cited test, or an AC that verifies nothing, is the gap. Fix it before the spec is done.

## Editing an existing spec

Before touching the living doc, think the change as a delta of IDs — what is **added**, **modified**, **retired**, and which traces it moves (which ACs gain or lose an FR):

```
ADDED FR-38; MODIFIED FR-12 (narrowed); AC-4 now also cites FR-38; RETIRED FR-9
```

Stable IDs and retire-in-place keep that delta legible in the git diff itself, so it needs no separate document — the spec stays a clean statement of the *current* contract. Load-bearing rationale goes in a PR description or an ADR, never as motivation prose in the spec. A tombstone's brief reason, and a policy's `serves FR-x` pointer, are the exception: permitted guards against silently re-adding what you removed, not motivation.

## See also

- `plan` — design and decompose once the spec is stable
- `architecture-review`, `doc-review` — where the *how* lives, and keeping the spec free of drift
- [`template.md`](template.md) — the canonical section skeleton to copy from

## Red flags

- Specifying *how* (an algorithm, a request shape, a data structure) where an outcome would do
- Drifting into PRD territory (user stories, success metrics, motivation) instead of testable requirements
- Renumbering existing IDs, or reusing a retired one
- Acceptance criteria that cite no requirement, or requirements no criterion verifies
- Edge cases written as aspirations instead of labelled requirements
- Fixed constraints and open decisions blended into the same prose
- A requirement stated so vaguely no test could prove it met
- Copying another project's domain families wholesale instead of choosing the ones this project needs
