---
name: handoff
description: Summarize the session and reset context to save costs. Use when the context is getting long or before switching focus.
---

# Handoff

Summarize what matters, clear the noise, and continue without paying for stale tokens.

## Workflow

1. Check if the conversation started with a prior handoff summary. If so, merge it with this session's work into one cumulative summary — carry forward anything still relevant, drop anything resolved or stale.
2. Write the summary (see format below).
3. Print the summary in a fenced code block so the user can review it.
4. Copy the summary to the clipboard using the appropriate command for the OS (`pbcopy` on macOS, `clip` on Windows, `xclip -selection clipboard` on Linux).
5. Tell the user the summary is on their clipboard and to clear the context, then paste it as their first message.

The summary travels forward as the first user message in the new context, so it must be self-contained.

Note: context clearing is a client-side operation — the model cannot invoke it. The user must do it themselves. This is the only manual step.

## Summary format

```
# Session summary — <branch or topic>

## What was built
<bullet list: files changed, features added, decisions made>

## Design decisions
<any non-obvious choices and why they were made>

## What's next
<concrete next steps — enough for a cold start>
```

Keep it dense. Omit anything derivable from `git log`, the code, or docs. The goal is to preserve intent and decision rationale, not mechanics.

## What to include

- Carried-forward context from prior handoff summaries (merged, not appended)
- Work completed this session and its outcome
- Non-obvious decisions and their rationale
- Open questions or blockers
- The immediate next step

## What to omit

- File contents, diffs, or command output
- Things already in code comments or docs
- Anything that `git log` or `gh issue view` would show
- Resolved items from prior handoff summaries

## Red flags

- Summary so long it defeats the purpose
- Omitting the "why" behind key decisions
- Skipping next steps — a cold context needs a foothold
- Appending prior summaries verbatim instead of merging them
