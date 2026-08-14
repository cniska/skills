---
name: plan
description: Design a feature or behavior change through dialogue. Use when asked to plan, scope, design, or break down work before coding.
---

# Plan

Design a feature or behavior change through dialogue.

If an issue number is given, fetch it with `gh issue view $ARGUMENTS` and use it as the starting point.

Have a design conversation about this task. Read the relevant code, share what you find, say what you think, and let the user shape the direction. The plan emerges from the dialogue — do not build it in isolation.

Question the premise before designing to it. The framed change is a proposal, not a given: is it the right unit of work, would removing something serve better than adding, is the feature still earning its keep or has the world moved past it? Prefer deletion and source fixes to accretion. Say so when the framing is off; don't silently build to spec.

Before asking the user anything, decide whether the question is actually theirs. A hard technical design question has an evidence-based answer — does this pattern already exist, which of two shapes fits this codebase, what breaks if we take that seam, what does the migration cost — and it is yours to answer, not theirs to adjudicate. Difficulty is the reason to delegate it, never the reason to escalate it.

Three dispositions, not two: answer it, delegate it, or ask. Ease is the reason not to delegate — where a file already open or one grep settles it, settle it and state the grounding; a subagent that only confirms a call you had already made is pure overhead, though one that re-derives it and comes back with provenance you lacked is not. Delegate what needs real work, to a **powerful-tier** subagent with high reasoning effort, and return with the answer and its grounding rather than the question.

What stays with the user is what no amount of evidence settles — product intent, priority, risk appetite, which tradeoff they want to live with. Most questions that feel like theirs are tangled: split off the evidence half, settle it, and put only the residue to them. Before each question, name what you tried first — if that answer is "nothing," you are not ready to ask. Research is a loop, not a pass: delegation surfaces questions that didn't exist before it ran, so re-run the disposition on each rather than batching whatever accumulated. Ask one at a time, in dependency order, each with your recommended answer.

Asking has two terminal forms. With a human, it's a question. With none — invoked from a subagent, a schedule, a batch run — the dialogue gates can't be met, so don't stall on them and don't fake agreement: state the question as a marked assumption carrying the answer you'd have recommended and the alternative's cost, then keep going. On that path the dialogue red flags below are suspended, not violated; you are producing a document for approval because there is no one to converse with.

Ground every recommendation in current code, docs, and project rules. Read enough yourself to pick the task before fanning out — which files are load-bearing is itself a finding, and a fan-out that precedes it is guessing. Then spawn readers in parallel, one per independent question rather than one per file (cap ~5), each tiered to its own question as below — file count is a poor proxy for difficulty, and a reader that summarizes a file you could have read costs more than it saves while losing the exact signatures you need. Where a grep would do, or the load-bearing material — code, spec, or prose — runs to a few hundred lines, read it yourself; measure it before deciding, since byte size misleads badly on markdown that never hard-wraps.

Match the tier to the question: **fast-tier** for retrieval (where a thing lives, what it does), **powerful-tier** for judgment (which shape fits, what breaks, what it costs). "Does X exist anywhere in here?" only looks like retrieval — it takes judgment to know what counts as an X, so a fast-tier "not found" is not evidence of absence. Verify any load-bearing claim a delegate returns before you plan on it: a confident wrong answer reads exactly like a right one, and the cost lands in the plan. Bring what you found back to the user before drafting — the read-back is a conversation turn, not a silent research phase. With no one to bring it to, it collapses into the plan's grounding: show the evidence rather than dropping the step.

## Task sizing

- **Small (1-2 files):** single endpoint, component, or utility
- **Medium (3-5 files):** one feature slice through the stack
- **Large (5-8 files):** multi-component feature — consider splitting

Anything larger needs further decomposition. Count seams of judgment, not files touched: mechanical churn (one derive added to fifteen types) and mandated doc or spec updates that mirror a decision already made don't move the band, while in a large codebase a single file can be several seams. Count decisions a reviewer could push back on — that is what a seam is. Slice vertically (complete paths through the stack), not horizontally (all types, then all implementations, then all tests).

## When aligned

Aligned means the user has explicitly agreed to a concrete proposal — not merely heard it. If you haven't gotten a confirming response, you're not aligned yet.

With no human in the loop, alignment is the reader's step rather than one you reached: label the plan unratified at the top, not in a footer, and emit the checklist unchecked as the proposed sequence — nothing was agreed, and a checklist that reads as agreed would be the fake agreement you were told to avoid.

Summarize what was agreed: **Outcome** | **Decisions made** | **Change list** | **Validation** | **Open questions**.

Split into phases if the work is large. Each phase independently valuable and verifiable. Reference concrete files.

For non-trivial plans, track agreed steps in a checklist as the conversation progresses. When planning is done, the checklist is ready — hand it to the user and stop. Execution starts only when the user says so (typically via `build`).

## Program design

For a change past a single file, make its shape concrete before handing off — a decision on the table is cheaper to change now than at review time:

- **File-tree diff** — files added, changed, or deleted, one line of intent each; for an edit to just a file or two, a sentence beats a block (see below).
- **Key signatures** — the new or changed function and type signatures the slice introduces.
- **Call path** — the entry-to-leaf path through those signatures.

Tag every fenced block with its language so it renders highlighted where the host supports it — `diff` for the file-tree, the source language (`ts`, `py`, …) for signatures. In the file-tree put the `+`/`-` marker at column 0 so added and deleted files actually color; a modified file is a plain line with a trailing note. The file-tree earns its place when files are added, removed, or moved, or the change spans distinct modules; when it is edits to a file or two, just name them in a sentence — a block that is all plain lines with nothing colored communicates nothing, and one glob line covers many files of the same kind. When both tests fire — a module-spanning change that adds a single file — go by what the block would actually render: one `+` among nine plain lines is a sentence, not a block. When neither fits, several files modified with none added or moved, the inventory still earns its place; give it as a plain list, since a fence with nothing to color only costs highlighting it can't deliver. Keep the tag accurate: a wrong language reads worse than none, and when none fits (a pure deletion, markup with no faithful fence) describe it in prose rather than force a tag. Sketch the shape in the conversation, not a separate document. If drawing it surfaces a decision, resolve it with the user here — that is the point.

## See also

- `build` for execution discipline per slice

## Red flags

- Disappearing to build a plan and returning with a document for approval
- Presenting options instead of surfacing the underlying problem
- Accepting the framing when the real move is deletion or a smaller source fix
- Planning from intuition without reading current code
- Asking the user a technical design question a powerful-tier subagent could have answered from the code
- Escalating a question to the user because it was hard rather than because it was theirs
- Asking a tangled question whole instead of settling its evidence half and putting only the residue to the user
- Delegating what a file already open, or one grep, would have answered
- Planning on a delegate's load-bearing claim without verifying it, or reading a fast-tier "not found" as proof of absence
- Hiding uncertainty instead of stating assumptions

Do not implement inside this skill flow unless the user explicitly switches to execution.
