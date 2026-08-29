---
name: build
description: Implement features incrementally through vertical slices. Use when building features, adding functionality, or implementing tasks that touch multiple files.
---

# Build

Build in thin vertical slices. Implement one piece, verify it, commit it, then move on. Never accumulate uncommitted work across multiple slices.

## Workflow

Before the first slice, if not already on a dedicated branch, create one. Consider an isolated worktree (`git worktree add -b <topic> .claude/worktrees/<topic>`) so the main session stays an orchestrator. Never use `git -C <path>` — always `cd` into the target first.

1. **Pick the smallest slice** that delivers a complete, testable path through the change.
2. **Read before writing.** Load the relevant files, understand existing patterns, check for utilities you can reuse. For external libraries and version-sensitive APIs, confirm behavior against the docs or upstream source for the version pinned in this repo — not memory, not blog posts.
3. **Implement the slice.** Stay within its boundary — don't fix adjacent issues or refactor unrelated code. Comments must earn their keep: write one only for a *why* a name, type, or test can't carry — never narrate *what* the code does. Don't hedge: a default or `catch`-and-continue written because you don't know the correct behavior turns uncertainty into silent runtime behavior — ask, or fail where the caller can see it. Degradation you chose on purpose is fine; say so in a comment where the choice isn't obvious from the line.
4. **Verify the slice.** Run the targeted tests; they must pass before the next slice starts. Run the project's full verification once before pushing or opening a PR.
5. **Commit the slice.** One logical change per commit.
6. **Repeat.** Pick the next slice. If the plan needs adjusting, adjust it before continuing.

## Slicing strategies

- **Vertical slice** — one complete path through the stack (type + implementation + test). Preferred default.
- **Contract-first** — define the schema and types first, then implement consumers.
- **Risk-first** — tackle the uncertain part first, then build the straightforward parts on top.

A slice is one path, not one layer. Good: `POST /orders` endpoint + the form that calls it + one test. Bad: all endpoints, then all UI, then all tests.

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
