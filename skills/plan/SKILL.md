---
name: plan
description: Design a feature or behavior change through dialogue. Use when asked to plan, scope, design, or break down work before coding.
---

# Plan

Design a feature or behavior change through dialogue.

If an issue number is given, fetch it with `gh issue view $ARGUMENTS` and use it as the starting point.

Have a design conversation about this task. Read the relevant code, share what you find, say what you think, and let the user shape the direction. The plan emerges from the dialogue — do not build it in isolation.

Question the premise before designing to it. The framed change is a proposal, not a given: is it the right unit of work, would removing something serve better than adding, is the feature still earning its keep or has the world moved past it? Prefer deletion and source fixes to accretion. Say so when the framing is off; don't silently build to spec.

If a question can be answered by reading the code, read the code instead of asking. When scope is genuinely ambiguous, resolve it before drafting: ask one question at a time, in dependency order, each with your recommended answer — and only ask what the code can't tell you.

Ground every recommendation in current code, docs, and project rules. For non-trivial context gathering, spawn a few **fast-tier** readers in parallel (cap ~5; one per load-bearing file), then bring what you found back to the user before drafting — the read-back is a conversation turn, not a silent research phase.

## Task sizing

- **Small (1-2 files):** single endpoint, component, or utility
- **Medium (3-5 files):** one feature slice through the stack
- **Large (5-8 files):** multi-component feature — consider splitting

Anything larger needs further decomposition. Slice vertically (complete paths through the stack), not horizontally (all types, then all implementations, then all tests).

## When aligned

Aligned means the user has explicitly agreed to a concrete proposal — not merely heard it. If you haven't gotten a confirming response, you're not aligned yet.

Summarize what was agreed: **Outcome** | **Decisions made** | **Change list** | **Validation** | **Open questions**.

Split into phases if the work is large. Each phase independently valuable and verifiable. Reference concrete files.

For non-trivial plans, track agreed steps in a checklist as the conversation progresses. When planning is done, the checklist is ready — hand it to the user and stop. Execution starts only when the user says so (typically via `build`).

## Program design

For a change past a single file, make its shape concrete before handing off — a decision on the table is cheaper to change now than at review time:

- **File-tree diff** — files added, changed, or deleted, one line of intent each; for an edit to just a file or two, a sentence beats a block (see below).
- **Key signatures** — the new or changed function and type signatures the slice introduces.
- **Call path** — the entry-to-leaf path through those signatures.

Tag every fenced block with its language so it renders highlighted where the host supports it — `diff` for the file-tree, the source language (`ts`, `py`, …) for signatures. In the file-tree put the `+`/`-` marker at column 0 so added and deleted files actually color; a modified file is a plain line with a trailing note. The file-tree earns its place when files are added, removed, or moved, or the change spans distinct modules; when it is edits to a file or two, just name them in a sentence — a block that is all plain lines with nothing colored communicates nothing, and one glob line covers many files of the same kind. Keep the tag accurate: a wrong language reads worse than none, and when none fits (a pure deletion, markup with no faithful fence) describe it in prose rather than force a tag. Sketch the shape in the conversation, not a separate document. If drawing it surfaces a decision, resolve it with the user here — that is the point.

## See also

- `build` for execution discipline per slice

## Red flags

- Disappearing to build a plan and returning with a document for approval
- Presenting options instead of surfacing the underlying problem
- Accepting the framing when the real move is deletion or a smaller source fix
- Planning from intuition without reading current code
- Hiding uncertainty instead of stating assumptions

Do not implement inside this skill flow unless the user explicitly switches to execution.
