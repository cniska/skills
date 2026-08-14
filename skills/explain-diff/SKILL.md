---
name: explain-diff
description: Explain a diff's intent and risk, then gate your understanding of it, so a change is grasped before review, handoff, or merge. Use when a change is complex, unfamiliar, or headed to other people.
argument-hint: "[pr-url-or-number]"
---

# Explain diff

A diff shows *what* changed. It never shows *why*, *what to worry about*, or *whether you actually understood it*. This skill recovers the first two — intent and risk — and then tests the third: you do not pass on a change whose explanation you cannot give. It explains and gates; it does not judge (that is `review`) or sell the change for merge (that is `pr`).

Written for readers who read code fluently. Explain the why and the risk, never the what — the diff carries the what. High-signal, not a tutorial: no beginner walkthrough, no narrating mechanics the diff already shows.

Two modes: **Self** (no argument) — current branch diff against `main`, including uncommitted changes; **PR** (URL or number) — someone else's PR.

## Workflow

1. **Gather the change and its intent.** Intent is *stated* in spec IDs, design notes, ADRs, commit messages, or a linked issue — find it before inferring. **Self:** diff the current branch against `main` (`git diff main...HEAD`, plus `git diff HEAD` for uncommitted work); read `git log main..HEAD` for commit messages, and for an uncommitted change check the diff's own spec/doc hunks first — read those and the small contract files before the biggest code hunk, and treat them as the commit message you do not have. **PR:** fetch with `gh pr diff <N>` and read intent from `gh pr view <N>` — the description and any linked issue. Prefer stated intent to inferred; the code says what it does, never what the author meant. Delegate the whole gather-and-draft pass to a fresh subagent whenever one is available, whatever the diff's size — a session that touched the change explains its own mental model back, and the gaps it papers over are exactly the ones it cannot see. Hand the agent only where to look: repo or worktree path, diff range or PR number, and tooling quirks it would otherwise trip on (a shell proxy that rewrites command output, an unusual build). Never your intent, rationale, alternatives weighed, or findings — a cold reader that converges on your reading independently is signal; one you briefed is an echo. Run it on a **balanced-tier** model or better. Keep the comprehension gate in this session regardless: you cannot delegate answering it for yourself.
2. **Find the spine.** Name the one logical change and the problem it solves. Group hunks by logical change, not by file — a change that spans five files is one story, not five. Git's hunk-header heuristic can mislabel the enclosing function; verify against the file rather than trusting the diff's own labels.
3. **For each logical change, give three things:** the **intent** (what it is for), the **load-bearing decision and the alternative not taken** (why this shape), and the **risk** (what could break, what a reviewer should scrutinize).
4. **Surface the non-obvious.** Implicit contracts touched, invariants relied on, ordering or concurrency, migrations, **trust dependencies** (where one component assumes an invariant another enforces without checking it — especially across a process or network boundary), anything a careful reader would miss on a first pass.
5. **Separate stated from inferred.** Never present an inferred *why* as fact. A reverse-engineered intent no source confirms is a guess — mark it as one.
6. **Stay high-signal.** Omit what the diff makes obvious. Mechanical renames, moves, and reindentation earn one line, not a tour. Measure length against the change's *meaning*, not its line count — a 200-line reindent carrying fifteen lines of real signal warrants a short explanation, not a long one.

## Comprehension gate

Close with a few multiple-choice questions, medium difficulty — hard enough that only someone who actually grasps the intent and risk can answer, never trivia or gotchas: *why this shape and not the alternative, what breaks if X changes, where the invariant lives.* One correct answer per question, plausible distractors drawn from real misunderstandings of the diff — never guessable from a fixed position or a tell in the phrasing. Let the reader click an option and see whether it's correct, with a brief explanation, before moving on. Answer them before you own the change — merge it, hand it off, or ship it.

The gate is not education; it is a rule: **you do not pass on code whose explanation you cannot give.** If you cannot answer, the change is not understood well enough to own — go back to the diff, or to the author. Solo, it is a check on yourself before merge; for a handoff, it travels with the file described below.

## Output

Render as a single self-contained HTML file — inline CSS and JS, no external fonts, CDNs, packages, or network calls, so it opens standalone in a browser with nothing to fetch. The gate's multiple-choice interactivity (option selection, reveal) needs the inline JS; it isn't optional polish. Use the environment's artifact-publishing capability if one is available; otherwise write the file directly, named with today's date (`YYYY-MM-DD-explain-<slug>.html`), to a scratch location outside the repo. Fall back to plain text with the gate as open questions only when there's nowhere to write a file, or the user asks for text directly.

A narrative organized by logical change, not by file. Close with **what to scrutinize** (the parts a reviewer must not skim), **assumptions I could not confirm** (inferred intent, flagged), and the **gate questions**. No code blocks restating the diff.

Spell out abbreviations and acronyms on first use — a reader fluent in code isn't necessarily fluent in this codebase's jargon. Gloss unfamiliar or domain-specific terms briefly: a short parenthetical in text, or a collapsed `<details>` aside. If several terms recur throughout — jargon dense enough that scattering parentheticals would fragment the narrative — front-load one short glossary block instead, then use the terms bare afterward. Never a standalone paragraph mid-narrative that interrupts the flow.

## See also

- `review` — judge the change once it is understood; explain-diff builds the understanding review acts on
- `pr` — describe the change for merge; explain-diff is for grasping it, not the PR body
- `spec` — the source of stated intent; cite its IDs rather than inferring
- `debug` — when the risk is behavioral, a minimal repro proves it rather than asserting it

## Red flags

- Narrating mechanics the diff already shows instead of the why and the risk
- Presenting inferred intent as stated fact
- Explaining file-by-file instead of by logical change
- Gate questions that are trivia or gotchas, free-text instead of multiple choice, or a gate you rubber-stamp instead of answering
- No "what to scrutinize" — an explanation that names no risk explained nothing
- Beginner padding when a plain answer would do
- A walkthrough so long the reader would rather just read the diff
- Plain text output when a self-contained HTML file could have been written
- External fonts, CDNs, packages, or network calls in the HTML instead of a fully self-contained file
- An acronym or abbreviation used without spelling it out on first use
- A term gloss long enough to interrupt the narrative instead of a short parenthetical, collapsed aside, or up-front glossary block for jargon-dense diffs
- Running the pass in this session when a fresh subagent was available, or judging a diff too small to be worth delegating
- Briefing the subagent with your intent, rationale, or findings, so it grades your reading instead of forming its own
- Trusting a diff's hunk-header function label without checking it against the file
- A guessable gate — correct answer in a fixed position, or a distractor that's a joke, an impossible claim, or trivia instead of a plausible misunderstanding
