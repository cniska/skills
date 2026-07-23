---
name: agents-md
description: Create and update AGENTS.md project rules. Use when authoring or amending the cross-tool conventions agents must follow.
---

# AGENTS.md

`AGENTS.md` holds the cross-tool project rules — the conventions any coding agent must follow in this repo. Two modes, detected by whether one already exists at the target: **Create** (none exists) infers rules from evidence; **Update** (one exists) merges a new rule into the right section and trims what it duplicates. Updating is the harder half: never blind-append.

Not the same as adjacent artifacts — keep them distinct:

- `CLAUDE.md` and `/init` are Claude Code's own memory, not the cross-tool rulebook.
- `settings.json` is harness config (the `update-config` skill), not project conventions.

When a rule belongs in AGENTS.md, put it there — don't scatter the same rule across these files.

## Conventions this file must follow (and enforce)

- One logical rule per bullet.
- Never hard-wrap markdown — one line per bullet or paragraph, let it soft-wrap.
- State the rule, not its history — "no X" beats "we used to allow X but now".
- Reuse the existing file's vocabulary — don't coin a synonym for a concept already named.
- Keep it lean — prefer trimming to growing. A new rule shouldn't grow the file if an existing bullet can absorb it.
- Decide placement by cost, not by recipe. AGENTS.md is loaded on every task, so every line pays a recurring token cost. Whether a fact belongs inline here or behind a one-line pointer to a doc or executable is a judgment: weigh how often it's needed against that per-task cost, and decide for this project. The right split differs across projects and shifts as models improve — apply the principle rather than a fixed line count or section recipe. As a rule of thumb the whole file stays well under ~80 lines.
- For any comment guidance it generates, take the self-documenting-code stance: comment the *why* that can't be encoded in a name, type, or test — never the *what*.
- If a `SPEC.md` exists, the opening line must reference it as the source of truth for requirements and require keeping it current in the same change that changes behavior — the spec never lags the code. Invariants may cite spec IDs (e.g. `FR-15`) to make them traceable, but code, comments, and test names must not — describe behavior in plain terms; the spec is the reference for why.

## Sections to consider

A menu of common dimensions, not a required skeleton. Shape the actual sections from the project's evidence — draw from these, rename them, add what this project needs, and drop what it doesn't. Use only sections with something concrete to say; an empty section is noise. Order so the load-bearing rules come first. The useful taxonomy differs per project and shifts as tools change — that structure is your call, not a fixed recipe.

- **Architecture** — module boundaries, entry points, what depends on what. Usually long and rarely needed in full — the clearest case for the placement principle above: keep a load-bearing pointer to a dedicated architecture doc here, not the map itself.
- **Invariants** — rules that must never break; the non-negotiables.
- **Workflow** — how to build, run, verify, and release locally, each as a one-line command reference (for a release with no single command, name the trigger instead — e.g. push a `vX.Y.Z` tag). The executable it names (a release script, a CI workflow) owns the procedure and any pre-release gates; keep this section to commands, and put development-process rules under Process, not here.
- **Process** — development and agent-behavior rules that are neither code contracts nor commands: branching and PR-vs-direct policy, worktrees, when to commit, autonomous-execution and sign-off expectations. Distinct from Workflow (commands) and Invariants (code contracts).
- **Commits** — message format and discipline (defer to the `git` skill's Conventional Commits unless the repo overrides).
- **Pull requests** — when to open one, the review gate, title and body rules (omit if the project doesn't use PRs).
- **Code** — language and structure rules specific to this repo.
- **Style** — formatting, naming, lint/format tool of record.
- **Docs** — where docs live and when to update them.
- **Testing** — test layout, how to run them, coverage expectations.

## Workflow

### Create mode

No AGENTS.md exists. Infer the project's *real* conventions from evidence — never invent aspirational rules the code doesn't follow.

1. Gather evidence:
   - lint/format config (`biome.json`, `.eslintrc*`, `.prettierrc*`, `rustfmt.toml`, `ruff.toml`) — the style section writes itself from these.
   - test layout and scripts (`package.json` scripts, test dirs, CI config).
   - framework and runtime (manifest files, lockfiles).
   - commit style from `git log --oneline -30` — copy the format actually in use.
   - any existing `CLAUDE.md` or `.cursorrules` — migrate real rules, drop tool-specific memory.
2. Draft sections from the menu above **only where evidence supports a concrete rule**, shaping them to this project. Skip the rest.
3. Follow every convention above — one rule per bullet, no hard wrap, terse.
4. Report which sections you filled and what evidence backed each.

### Update mode

AGENTS.md exists and you're adding a rule or change. This is a merge, not an append.

1. Read the whole file first — you can't dedupe what you haven't read.
2. Find the section the rule belongs in. Match the file's existing vocabulary and structure.
3. **Merge, don't append:**
   - if an existing bullet overlaps, rewrite that one bullet to cover both — don't add a second.
   - if the rule generalizes several existing bullets, replace them with the one general rule.
   - if the same rule is stated in two sections, dedupe to the single correct home.
4. Trim collateral duplication the change exposes, even outside the target section.
5. Re-check the file still follows every convention above (no hard wraps, one rule per bullet).
6. Report **added / merged / trimmed** explicitly — which bullets changed and why.

Concrete target behavior: adding a "comments" rule should absorb a pre-existing "no banner comments" bullet into it, not sit beside it; a rule that appears in both Style and Code should end up in one section only.

## See also

AGENTS.md is the hub that gives the other skills their project-specific grounding. Each skill reads it to understand what the project considers non-negotiable.

- `spec` — if SPEC.md exists, reference it in the opening line; defer all requirement details there. Invariants cite spec IDs; code does not.
- `git` — the Commits section defers to the `git` skill's Conventional Commits format unless the repo overrides it.
- `build` — the Workflow section names the verify command the `build` skill runs after every slice.
- `tdd` — the Testing section describes the surface the `tdd` skill drives against: test layout, run command, boundary mocking policy.
- `pr` — the Pull requests section states the review gate and title/body rules the `pr` skill fills in.
- `review` / `code-review` — the Invariants section is the checklist these skills verify. An invariant with no test and no review coverage is incomplete.
- `doc-review` — the Docs section states when to update canonical docs; the `doc-review` skill enforces it.
- `ship` — the Workflow section's release command is the entry point the `ship` skill invokes to cut a release; the script it names owns the pre-release gates.
- `update-config` — `settings.json` harness config belongs there, not here.

## Red flags

- Inlining long, rarely-needed content (a full module map) instead of pointing to a doc — spending recurring per-task cost on it.
- Blind-appending a new rule instead of merging it with the overlapping bullet.
- Hard-wrapping bullets to a column width.
- Inventing rules the codebase doesn't actually follow.
- Coining a new term for a concept the file already names.
- Growing the file when an existing bullet could have absorbed the rule.
- Putting Claude-Code-specific memory or `settings.json` config into AGENTS.md.
- Comment guidance that describes *what* the code does rather than *why*.
