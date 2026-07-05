---
name: handoff
description: Summarize the session and reset context to save costs. Use when the context is getting long or before switching focus.
---

# Handoff

Summarize what matters, clear the noise, and continue without paying for stale tokens.

Two modes — infer from the argument:

- **End-of-session** (default, no argument or a topic): for yourself. What does the next session need to resume?
- **Delegate** (argument names a recipient or different context): for another agent or person. What does that recipient need to start the task? Strip originating project context; orient to the target.

## Workflow

1. Check if the conversation started with a prior handoff summary. If so, merge it — carry forward what's still live, drop what's resolved or stale. Never append verbatim.
2. Write the summary to a unique path: `date -u +/tmp/handoff-%Y%m%dT%H%M%SZ.md`. The Write is silent — it is not the review copy.
3. **Print the full summary once** in your reply and ask whether it's good to copy or needs changes. This is the only place the user sees it. If edits are needed, rewrite the file and print the revised version — never `cat` or repeat it otherwise.
4. Only once confirmed: copy to clipboard (`pbcopy < <path>` on macOS, `xclip -selection clipboard < <path>` on Linux). Tell the user to `/clear` and paste it as the first message.

Note: context clearing is client-side — the user must do it. This is the only manual step.

## Format

    # Session summary — <topic or ticket>

    ## Status
    <one line: where the work actually stands>

    ## Decisions and why
    <choices that still constrain what the next session will do — with the why>

    ## Dead ends
    <approaches tried that didn't work>

    ## Pointers
    <file paths, doc URLs, ticket IDs — addresses, not content>

    ## Open
    <blockers, questions, things waiting on someone else>

    ## Next
    <one concrete first action — enough for a cold start>

    Keep going.

Drop sections that have no content. The closing `Keep going.` is load-bearing — without it the next session tends to wait for instructions instead of picking up from Next.

## What to include / omit

Include: decisions and the reasoning behind them, open questions, the immediate next step, carried-forward context (merged, not appended).

Omit: file contents, diffs, command output, anything derivable from `git log` or the code.

## Red flags

- Summary so long it defeats the purpose
- Omitting the "why" behind key decisions
- Skipping next steps — a cold context needs a foothold
- Appending prior summaries verbatim instead of merging them
- Printing the summary more than once
