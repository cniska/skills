---
name: skill-authoring
description: Create or update a skill in this repo, matching its conventions. Use when authoring a new skill or amending an existing one.
---

# Skill authoring

A skill is a self-contained instruction to a model — one per file at `skills/<name>/SKILL.md`. This skill carries the *how* of writing one here; `AGENTS.md` is the source of truth for the mechanical rules the validator enforces (frontmatter, `## Red flags`, no cross-directory links, tier vocabulary). Read it first; don't restate it here.

Two modes, inferred from the request:

- **Create** — a capability has no skill yet. Start from scaffolding, then clone the shape of the closest existing skill.
- **Update** — a skill exists and a rule needs adding or sharpening. Merge into the right section and trim what it duplicates; never blind-append. Updating is the harder half.

## Workflow

1. **Pick the mode** and read `AGENTS.md` (`## Authoring a skill`) for the rules in force.
2. **Find the closest sibling** and match its shape — don't invent a new one. A "create/update a GitHub thing" clones `issue`; a two-modes artifact skill clones `docs` or `agents-md`; a review dimension clones a `*-review` skill.
3. **Scaffold (Create only)**: `make new-skill NAME=<kebab-case> DESC="<imperative description>"`, or copy `SKILL_TEMPLATE.md`.
4. **Write to the conventions**: imperative body, terse, `description` starts with a verb and says when to use it; reference other skills by bare name in `## See also`; end with `## Red flags`. Match wording to the sibling — same section order, same lead-in style.
5. **Validate**: `make validate`.
6. **Dry-run before commit**: run `skill-test` on unlike real repos for any material change, and fold convergent fixes back in. A change is material if it alters what the skill detects, flags, or produces — even one bullet — not if it merely reads that way; a wording-only fix with no behavioral change (typo, link, terminology) can skip the dry-run.
7. **Commit** direct to `main` with a Conventional Commit subject — only once the user gives the go.

## See also

- `skill-test` — dry-run a changed skill on real repos before pushing
- `second-opinion` — cross-check a skill's design with a different model

## Red flags

- Restating AGENTS.md's mechanical rules in the skill body, so the two drift
- Inventing a new structure instead of cloning the closest sibling
- Blind-appending a rule on update instead of merging and trimming duplicates
- Committing a materially changed skill without the `skill-test` dry-run
- Treating a small diff as automatically non-material — a single new bullet can change what a skill flags
- Growing a skill with rules for one-off friction instead of trimming
- Referencing another skill by path instead of bare name
