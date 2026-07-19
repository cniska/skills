---
name: docs
description: Create or update project documentation. Use when creating architecture docs, runtime docs, reference docs, or design documents that explain what the system does.
---

# Docs

A doc explains what the system does. One owner, one H1, one job. Written for agents and developers to read once and reference forever.

Two modes, inferred from the request:

- **New** — create a doc for a system, subsystem, or concept that has no documentation home yet.
- **Edit** — update an existing doc to reflect a change in behavior, contract, or scope.

## Conventions this skill enforces

- One H1 per doc. H1 is the topic in title case. H2+ are sentence case.
- First sentence is the summary. One line. The reader knows what this doc covers without scrolling.
- Cross-reference, don't repeat. If another doc owns the detail, link to it. Repeating detail is how docs drift.
- Flow diagrams use ```text blocks with `→` arrows and `|` branches.
- Tables are for structured data — column definitions, severity matrices, index lists, test tiers. Not prose.
- Bullets start with a bold label or a capital letter.
- Business terminology wins over technical terms when they differ.
- Mark features as live, planned, or deferred. A doc that doesn't reflect what's shipped is misleading.
- No marketing language. State what it does.
- No speculative future work. If it's not shipped or actively being built, it doesn't belong.

## Template

```
# [Topic]

One-sentence summary of what this doc covers.

## [Primary content]

Tables, flow diagrams, and bullets.

## Design rule

One paragraph. What principle explains why this design is the way it is?
```

Omit sections that don't apply. Cross-reference related docs where they own adjacent context.

## Workflow

### New mode

1. **Read the code.** The doc describes what the code does, not what you think it should do. Read source files, contracts, and tests before writing anything.
2. **Read adjacent docs.** Understand what's already documented. Identify the owner for any overlapping detail.
3. **Determine the doc type.** Architecture, design, security, runtime, reference, or comparison — different types emphasize different sections.
4. **Write the summary line.** One sentence. What does this system/concept do?
5. **Write the primary content.** Tables for structured data. Flow diagrams for sequences. Bullets for lists of facts. Track live/planned/deferred status.
6. **Write the design rule.** One paragraph. What principle explains why this design is the way it is?
7. **Cross-reference.** Link to related docs where they own adjacent context.
8. **Add to the docs index.** (e.g. `docs/README.md`)
9. **Verify.** Read the doc against the code. Every claim should be provable from the source.

### Edit mode

1. **Read the current doc.** Understand its structure and conventions before changing anything.
2. **Read the code that changed.** The doc must reflect what the code does now.
3. **Find the section.** Match the doc's existing vocabulary and structure.
4. **Merge, don't append.** If an existing bullet overlaps, rewrite it. If a new concept is introduced, give it its own subsection.
5. **Update cross-references.** If the change affects them.
6. **Update the docs index.** If the doc's scope changed.
7. **Verify.** Read the doc against the code. If the code and doc disagree, the code wins.

## Doc types

- **Architecture** — system layout, trust boundaries, data flows, request paths.
- **Design** — schema, column definitions, indexes, constraints, transactional functions.
- **Security** — threat model, severity matrices, build invariants.
- **Runtime** — behavior during a request. Lifecycle, tool execution, memory.
- **Reference** — tables and lists. CLI commands, configuration options, error codes.
- **Comparison** — feature matrices, benchmark results.

## See also

- `doc-review` — check existing docs for drift after code changes
- `spec` — requirements that docs reference
- `agents-md` — project rules that docs must follow

## Red flags

- Writing a doc without reading the code first
- Repeating detail that another doc already owns
- Creating a new doc when an existing one should be edited
- Adding speculative "future work" sections
- Writing prose where a table or flow diagram would be clearer
- Omitting cross-references to adjacent docs
- A doc that says what something should do instead of what it does
