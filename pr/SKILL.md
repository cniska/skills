---
name: pr
description: Create a pull request with review and verify. Use when the branch is ready to merge.
---

# PR

Two modes: **Create** (default) — push and open a PR; **Update** — rewrite an existing PR's description without pushing. Detect which by checking for an open PR on the current branch before acting.

## Conventions

- Title: Conventional Commit format (`type(scope): description`), under 60 chars, no trailing period
- Body: follow `.github/pull_request_template.md` if it exists — fill in each section, do not add or remove sections
- Keep it short — the fewest bullets that convey the change. Omit anything a reviewer would infer from the diff: mechanical steps, refactors in service of the main change, file moves, renames
- Bullets: high-signal plain English only; describe reviewer-relevant *what* and *why* — no code blocks, no prose paragraphs, no implementation bookkeeping
- Motivation: optional and brief (1-2 sentences); include only when the *why* isn't obvious from the summary
- If an issue matches the branch work, add `Fixes #<number>` at the end of the body

## Workflow

1. **Check preconditions** (all must pass before continuing):
   - working directory is clean (`git status`)
   - branch has commits ahead of `main` (`git log main..HEAD --oneline`)
   - project verification passes (run the project's test/lint/typecheck command)
2. **Prepare review context**:
   - if the implementation happened in a long session, suggest the user run `handoff` and re-run `/pr` in a fresh session for a cleaner review; otherwise proceed
3. **Run the review skill** (if available):
   - if there are must-fix findings, stop and report them — do not create the PR
4. **Gather context**:
   - read `.github/pull_request_template.md` if it exists
   - run `git log main..HEAD --oneline` to see commits
   - run `git diff main...HEAD --stat` to see changed files
   - run `git diff main...HEAD` to read the full diff
   - run `gh issue list` to check for an associated issue
5. **Audit the commits** (`/pr` opens a PR; it does not clean up history for you — fix it here):
   - every commit follows the project's commit conventions (`AGENTS.md` / `CONTRIBUTING` / the `git`
     skill), including **one logical change per commit**
   - if any commit violates, **stop and fix the history first** (split/reword per the `git` skill),
     then re-audit — do not open the PR on non-compliant commits
6. **Draft the PR**:
   - infer a title from the commits and diff
   - fill in the template body (or use a sensible default structure)
   - render the title and body in the conversation and wait for approval — do not push before sign-off
   - if the branch has a throwaway name, rename it first: `git branch -m <topic>`
7. **Push if needed**:
   - check remote tracking: `git status -sb`
   - if not pushed: `git push -u origin HEAD`
8. **Create the PR**:
   - `gh pr create --title "..." --body "..."`
9. **Return only the PR URL**

## Rules

- Never create a PR with uncommitted changes in the working directory
- Never create a PR without running verification first
- Never create a PR with must-fix review findings
- Never open a PR whose commits violate the project's convention or bundle unrelated changes — fix the history first
- Never push without checking remote tracking status first
- Always check for associated issues

## See also

- `git` for commit conventions and rewriting history before push
- `review` for severity and gating decisions
- `doc-review` for user-facing drift checks before merge

## Red flags

- Skipping verification because "tests passed earlier"
- Skipping the review because it takes time
- Opening a PR with commits that bundle unrelated changes (e.g. a refactor and a feature in one commit)
- Pushing before checking if the branch already tracks a remote
- Creating the PR without checking for associated issues
