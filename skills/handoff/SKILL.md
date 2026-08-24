---
name: handoff
description: Write forward-looking startup instructions for the next session, then reset context to save costs. Use when the context is getting long or before switching focus.
---

# Handoff

Write the opening instructions your next session needs to pick up the work. The next session is a cold agent: same tools and checkout, zero memory of this one — its only input is this document. Every handoff is a briefing for a stranger, so it's a work order, not a report: it says what to do next, not what happened. There is no "we," nothing "we decided," no "where we left off" — if a line only makes sense to someone who was here, cut it. Size it to the next move, not to the session — a one-file fix earns a ten-line handoff, however long the session was.

One variable: does the reader already share this project? If yes, pointers can be bare paths and ticket IDs. If not (a teammate, a different context), strip originating-project assumptions and spell out where things live.

## Workflow

1. Commit any unfinished work first, if it's in a committable state and the project uses version control. A clean tree means the cold agent starts from a known point instead of reverse-engineering a working tree of half-done edits — and `Next` can then point at committed state rather than spending lines describing uncommitted diffs. A `wip:` commit is fine; note it in `Next` so the reader knows to build on or amend it. Skip only when the work genuinely can't be committed (broken build mid-refactor) — then say so in one line.
2. Write `Next` first: the one concrete action the next session starts with, specific enough for a cold start. Everything else gets in only by tracing to it.
3. Admit each further line by one test: **could the cold agent execute Next without this?** If yes, cut it — however much work it represents. "Important context" and "we decided this" don't count; a decision is recorded only if Next would otherwise violate it, and then as the rule, not its history.
4. If this conversation opened with a prior handoff, merge: carry what still constrains Next, drop the rest. Never append verbatim.
5. Budget check: the whole handoff fits on one screen (~150 words; more only if Next is genuinely multi-step). Longer means you drifted into reporting — cut, don't reorganize.
6. Write it to `date -u +/tmp/handoff-%Y%m%dT%H%M%SZ.md` and copy it in the same step (`pbcopy < <path>` / `xclip -selection clipboard < <path>`) — no confirmation gate.
7. **Print the whole handoff verbatim in your reply.** The write and the copy are both silent and tool output is truncated, so this is the only place the user sees it — print the body as prose, never a `cat`. Once, then stop.
8. Tell the user to `/clear` and paste as the first message — clearing is client-side, their one manual step. On requested edits: rewrite, re-copy, reprint in full.

## Format

Exactly these three sections, in order — no others. If you're reaching for a heading like Status, Progress, Decisions, Done, Evidence, Dead ends, or Parked, that's the report shape: the content either earns one line under a section below or dies. Drop a section with nothing in it.

    # Handoff — <topic or ticket>

    ## Next
    <one concrete action, specific enough to start cold. One sentence.>

    ## What the next move needs   (≤5 bullets, one line each)
    - <a file to touch / a rule to hold / a decision already made — stated as the rule, no backstory>
    - <a live blocker, only if the move is waiting on one: "Blocked on X — who/what unblocks it">

    ## Pointers
    - <path, URL, or ticket ID — an address, not its contents>

    Start with Next.

The closing line is load-bearing: without a closing imperative the fresh session tends to summarize the handoff back or ask what to do, instead of acting on `Next`.

A decision goes in as its rule, not its history:

    Report shape: "We chose pbcopy over osascript because osascript triggered
    permission prompts on Sonoma and we lost 40 minutes to it..."
    Rule:         "- Clipboard via pbcopy, not osascript (permission prompts). Settled."

## The test

Write only what the reader must do or not do next. A line earns its place by changing the next action — not by recording that something happened. Dead ends, settled-decision histories, and "what I accomplished" all fail it: the reader acts forward, and the code, `git log`, and standing docs (AGENTS.md, SPEC, TODO) already hold the past. Link to those; don't recount them. Never paste file contents, diffs, or command output.

## Red flags

- Reads like a report — narrates what happened instead of what to do next. The reader was never here; the past is unusable to them.
- A dumping section — dead ends, decision backstories, deferred-work logs. If the next move won't act on it, the cold agent can't use it.
- `Next` missing, vague, or not first.
- Handoff longer than one screen, or longer than the work `Next` describes.
- Restating what `git log`, the code, or standing docs already hold.
- Prior handoff appended instead of merged.
- Handoff never printed in the reply — writing the file or copying it doesn't count; the user sees neither.
- Printing the handoff more than once.
