---
name: git
description: Manage commits, branches, and change history. Use when committing, branching, or managing version control.
---

# Git

Commits are save points, branches are sandboxes, history is documentation. Treat them accordingly.

## Commit messages

[Conventional Commits](https://www.conventionalcommits.org/) — `type(scope): subject`. Types: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `build`, `ci`, `perf`. Single-line subject, aim under 50 characters and never over 72. Do not put issue references or links in the subject (`(#123)`, `Fixes #123`) — those belong in the PR body. Defer to the repo's `AGENTS.md` or contributing guide if it overrides this.

## Commit discipline

- **Commit after each successful slice.** Don't accumulate work — a commit is a save point you can return to.
- **One logical change per commit.** A commit that refactors and adds a feature is two commits.
- **Explain intent, not mechanics.** Describe why the change matters, not what files were touched.

## Change sizing

- ~100 lines per commit: good.
- ~300 lines: acceptable if one logical change.
- 1000+ lines: too large — split it.

Separate refactoring from feature work. Separate formatting from behavior changes.

## Branch workflow

- When using raw Git, start task branches from the current integration base, normally `origin/main`; fetch first rather than updating a shared primary checkout.
- Use short topic branch names without type prefixes, e.g. `signal-toolkit`, not `feat/signal-toolkit`.
- Keep branches short-lived — merge within days, not weeks.
- Rewrite local history before pushing — amend, rebase, squash to keep history clean. Commit noise should never become permanent.
- Never amend commits already pushed to remote.
- Use `--force-with-lease` over `--force`.
- Never use `git -C <path>` — always `cd` into the target first. It hides the real working directory and risks operating on the wrong repo.
- Land PRs with the repo's configured merge method. When none is set, default to squash — keeps history linear, one merge commit per PR.
- After a PR merges, prune the branch locally and on the remote, then `git fetch --prune` to clear stale tracking refs.

## Worktrees

- Treat worktrees as disposable branch sandboxes. Keep the primary checkout as an orchestrator, not a task workspace.
- Create each task in a fresh topic branch using a separate worktree.
- Run `git worktree list` before creating or removing one, and `git status` before beginning work or cleanup.
- Run Git commands from the target worktree; never use `git -C <path>`.
- Remove a worktree after its branch is merged or abandoned. Do not remove one with uncommitted changes.
- Follow repository-specific worktree setup and cleanup commands when they exist; they determine the task's base and setup. When a worktree is gone outside Git, run `git worktree prune` to clear stale metadata.

## Save-point pattern

When exploring uncertain changes, commit early with a clear message. If the approach doesn't work out, you can revert cleanly. Uncommitted work can't be reverted — only lost.

## Change summaries

After a set of changes, provide a structured summary:
- **What changed** — the diff in plain language
- **What was intentionally excluded** — scope discipline
- **What to watch** — potential concerns for reviewers

## Red flags

- Long-lived branches diverging from main
- Commits with "misc", "fix", "update" as the entire message
- Force-pushing to shared branches
- Mixing unrelated changes in one commit
- Working without committing for extended periods
- Removing a worktree without checking its status
