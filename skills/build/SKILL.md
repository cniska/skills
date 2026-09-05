---
name: build
description: Implement features incrementally through vertical slices. Use when building features, adding functionality, implementing tasks that touch multiple files, or running slices unattended and needing to know when to stop.
---

# Build

Build in thin vertical slices. Implement one piece, verify it, commit it, then move on. Never accumulate uncommitted work across multiple slices.

## Workflow

Before the first slice, if not already on a dedicated branch, create one. Consider an isolated worktree (`git worktree add -b <topic> .claude/worktrees/<topic>`) so the main session stays an orchestrator. Never use `git -C <path>` — always `cd` into the target first.

1. **Pick the smallest slice** that delivers a complete, testable path through the change.
2. **Read before writing.** Load the relevant files, understand existing patterns, check for utilities you can reuse. For external libraries and version-sensitive APIs, confirm behavior against the docs or upstream source for the version pinned in this repo — not memory, not blog posts.
3. **Implement the slice.** Stay within its boundary — don't fix adjacent issues or refactor unrelated code. Comments must earn their keep: write one only for a *why* a name, type, or test can't carry — never narrate *what* the code does. Don't hedge: a default or `catch`-and-continue written because you don't know the correct behavior turns uncertainty into silent runtime behavior — ask, or fail where the caller can see it. Degradation you chose on purpose is fine; say so in a comment where the choice isn't obvious from the line.
4. **Verify the slice.** Run the targeted tests; they must pass before the next slice starts. Green reached by skipping a test, deleting an assertion, silencing a check, or lowering a threshold is not verification — restore the check and fix the code under it. Run the project's full verification once before pushing or opening a PR.
5. **Commit the slice.** One logical change per commit.
6. **Repeat.** Pick the next slice. If the plan no longer fits the work, stop and say so — the plan's boundary is the user's to move, not the loop's.

## Slicing strategies

- **Vertical slice** — one complete path through the stack (type + implementation + test). Preferred default.
- **Contract-first** — define the schema and types first, then implement consumers.
- **Risk-first** — tackle the uncertain part first, then build the straightforward parts on top.

A slice is one path, not one layer. Good: `POST /orders` endpoint + the form that calls it + one test. Bad: all endpoints, then all UI, then all tests.

## Running unattended

The loop runs slice after slice without a reader in between; the scope it runs inside stays the user's. Stop and hand back when:

- the next slice needs something the plan doesn't cover
- the same slice fails verification twice — a third attempt is guessing
- the fix reaches a file or contract outside the plan's boundary
- the correct behavior is unclear, and step 3 has no one to ask

Say what stopped it and which slices landed. The per-slice commits are the record — don't keep a second log beside them.

## See also

- `plan` for scope and phase boundaries
- `tdd` for red-green-refactor within each slice

## Red flags

- More than 3 files changed without a commit
- Tests haven't run since the last significant change
- Mixing refactoring with feature work in the same slice
- Expanding scope mid-slice instead of deferring to the next one
- "I'll commit it all at the end"
- Implementing a version-sensitive API from memory
- Comments that restate the code, or banner/separator comments
- A fallback added because the correct behavior was unclear, or a deliberate one whose reason a reader can't infer
- Widening the plan mid-loop instead of stopping to ask
- A third attempt at a slice that has already failed verification twice
- A slice that reached green by weakening the check rather than fixing the code
