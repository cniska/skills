---
name: ship
description: Run pre-release checks, pick the version bump, and cut the release. Use when ready to tag and release.
---

# Ship

Run a structured pre-release gate, determine the version bump from the commits, and cut the release. This is a release gate over the whole project, not a diff review — review already happened.

The skill orchestrates and gates; the release mechanics belong to the project. Read `AGENTS.md` for the verify and release commands, and defer to them — the release entry point (a script or CI workflow) owns the version bump, changelog, tag, and any project-specific pre-release gates. Where none exists, take the manual path in the workflow. The release shape varies by ecosystem — tag-and-bump, or build-and-publish a checksummed artifact — and this skill assumes none. Where the project has no release entry point, take the manual path in the workflow.

## Scope

Check the entire project against the preconditions below. Never push; the last human step is pushing the tag.

## Workflow

1. **Verify preconditions** (all must pass to proceed):
   - on the release branch (`main` unless the project says otherwise)
   - working directory is clean
   - the project's verification passes (its verify command per `AGENTS.md`)
   - no secrets in tracked files — grep tracked, non-`.env` files for common key shapes (`sk-`, `Bearer `, `-----BEGIN`, provider API-key env names)
2. **Prepare context**: if the release follows a long implementation or review session, suggest running `handoff` and re-running in a fresh session, so the gate starts from a compact summary rather than a saturated context.
3. **Run quality checks** (warn, don't block):
   - no `TODO` / `FIXME` left in non-test source
   - commits exist since the last release tag
   - user-facing docs and changelog reflect the user-visible features since the last tag — cross-reference `feat` subjects; defer drift detail to `doc-review`
4. **Determine the version bump** from commits since the last tag (SemVer + Conventional Commits):
   - previous tag: `git describe --tags --abbrev=0 --match 'v[0-9]*'`
   - commits: `git log <prev_tag>..HEAD --oneline --no-merges`
   - **major** — any commit has `BREAKING CHANGE` in the body or `!` before the colon in the subject
   - **minor** — any commit subject is `feat(...)` or `feat:`
   - **patch** — everything else
5. **Report** using the output format below, then **ask for confirmation**.
6. **Cut the release**: if the project has a release entry point, run it with the chosen level; otherwise take the manual path — record the version where the project keeps it, write the changelog entry, and create the commit and annotated tag `v<version>`.
7. **Print the push commands** and stop. Do not push.

## Output format

### Preconditions
- pass / fail per check, with failure detail

### Quality
- pass / warn per check

### Commits
- one-line list since the last tag

### Version
- previous → proposed (`<level>` — reason)

### Verdict
- **Ship it** — preconditions pass, no warnings
- **Ship with caution** — preconditions pass, warnings present
- **Fix first** — a precondition fails

## Rules

- Never cut a release if any precondition fails.
- Always ask for confirmation before creating the commit or tag.
- Never push — print the push commands for the user.
- If there are no commits since the last tag, stop and report that.

## See also

- `agents-md` — where the project's verify and release commands are declared
- `review` — the quality gate that runs before ship; ship assumes it passed
- `git` — commit conventions the version bump reads from
- `doc-review` — user-facing drift before the tag
- `handoff` — compact the context before a release that follows a long session

## Red flags

- Cutting the release without checking preconditions
- Guessing the version bump without reading the commits
- Pushing without user confirmation
- Skipping quality checks because preconditions passed
