---
name: review
description: Run all review dimensions against a diff or a path. Use when reviewing a feature branch before merge, reviewing someone else's PR, or auditing a file path.
argument-hint: "[pr-url-or-number-or-path]"
---

# Review

Run all review dimensions against the current branch and produce one unified review. Approve when a change improves overall code health, even if it isn't perfect.

Three modes: **Self** (no argument) — current branch diff against `main`; **PR** (URL or number) — someone else's PR; **Path** (file or directory) — full-file audit of code already on `main`.

## Scope

**Self / PR:** review only the diff, but read enough surrounding code and docs to understand conventions and boundaries. **Path:** review the enumerated files in full — there is no diff.

Do not duplicate the same issue across categories.

## Change sizing

Self and PR modes only — Path has no diff. Before reviewing, check the diff size:

- ~100 lines: good, reviewable in one pass.
- ~300 lines: acceptable if one logical change.
- ~1000 lines: too large — ask the author to split before reviewing.

Refactoring mixed with feature work is two changes. Flag it.

## Workflow

### Self (no argument)

1. If the branch was built in a long session, run `handoff` with "run `/review`" as the next-session instruction, then perform the review in the fresh session.
2. Determine diff scope: `git log main..HEAD --oneline` and `git diff main...HEAD --stat`. If no commits ahead of `main`, report and stop.
3. **Get an independent second opinion first.** Spawn a fresh `general-purpose` subagent to review the diff independently — it isn't anchored to the author's mental model. Give it the diff, intent, and specific failure modes to probe. Ask for concrete findings with evidence only. Run on the session model, not a cheaper tier.
4. Read changed files in full, plus any project-level convention docs. **Review tests first** — they reveal intent and coverage gaps.
5. **For large diffs** (more than 3 files), fan out **fast-tier** sub-agents — one per logical area — to surface candidate findings. Verify each before including it.
6. Run the five dimension passes in this session — load each skill (`style`, `architecture`, `docs`, `security`, `tests`) and apply its criteria to the diff, one pass per dimension. If a skill fails to load, say so in that category's output rather than improvising.
7. Fold in the second opinion's findings. Verify each; discard false positives.
8. Merge findings: deduplicate, keep strongest framing per root issue.
9. Label every finding by severity (see below). Fix all findings by default — commit each fix as its own subject-scoped commit.

### PR (URL or number)

1. `gh pr view <N>` for metadata; `gh pr diff <N>` for the diff. Read repo conventions — `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`.
2. For large PRs (more than 3 files), fan out **fast-tier** sub-agents per logical area. Verify findings yourself.
3. Run the five dimension passes (as in Self step 6). Filter relentlessly — only findings with evidence.

### Path (file or directory)

1. Enumerate files; skip generated content, lockfiles, `node_modules/`.
2. For large paths, fan out **fast-tier** sub-agents per file or logical area.
3. Read conventions. Run the five dimension passes (as in Self step 6) over the full files.

## Severity

Label every finding explicitly — an unlabeled finding is ambiguous. This scale is canonical; dimension skills map their labels onto it.

| Label | Meaning |
|-------|---------|
| **Critical:** | Blocks merge — security, data loss, broken functionality |
| **Fix:** | A real defect or convention violation; address before merge |
| **Consider:** | Worth thinking about, not required |
| **Nit:** | Style preference, minor improvement |

Order output Critical → Fix → Consider → Nit. In the summary table, Consider and Nit both count as optional.

## Review checks

Look for these patterns in every review:

- term drift across code, schemas, tests, and docs after a rename or protocol change
- shared contracts that blur distinct intent where separate variants or schemas would be clearer
- escape hatches, bypass flags, and special-case options that are broader than the behavior they enable
- updated implementation that leaves stale references behind in tests or docs

## Dependency review

If the change adds a dependency, check:
- Does the existing stack already solve this?
- Is it actively maintained?
- What's the size impact?
- Any known vulnerabilities?

Every dependency is a liability.

## Fix policy

- **Self:** fix all findings by default — including trivial ones — each as its own subject-scoped commit. Small issues left unfixed accumulate into tech debt.
- **PR:** never commit to someone else's branch. Deliver findings as a review (`gh pr review`), or a comment block if asked.
- **Path:** report findings; fix only when the user asks.

## Output

One section per review dimension (Style, Architecture, Documentation, Security, Tests), then a summary table: `category | critical | fix | optional`. Note categories with no findings.

## See also

- `style`, `architecture`, `docs`, `security`, `tests` for dimension-specific depth
- `../references/security-checklist.md` for concrete abuse-path checks
- `../references/testing-patterns.md` for test-quality review heuristics

## Red flags

- Reviewing only the diff without reading touched files in context
- Duplicating the same root issue across categories
- Generic cleanup wishlists
- Speculative issues without evidence
- Broad rewrite suggestions out of scope
- "LGTM" without evidence of review
- Softening real issues — if it's a bug, say so directly
- Accepting "I'll fix it later" — require cleanup before merge
