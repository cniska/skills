---
name: style-review
description: Review code style, naming, patterns, and consistency. Use when reviewing code quality or style drift.
---

# Style Review

Review naming, coding patterns, and style consistency against the codebase's existing conventions.

## Scope

### 1. Naming and shape consistency

- naming consistency across types, constants, functions, and files
- names that describe their content rather than their category, judged in context: a bare `data`, `temp`, or `result` holding something specific is the smell, but the same word is right where it is the domain's own term, a published API name, or an accumulator the function builds and returns — check the spec and the exports before flagging one
- renamed concepts stay aligned across code, tests, docs, and exported identifiers
- constructor and factory naming follows a single project convention
- module and file layout follows the established project structure
- import/export patterns are consistent across the codebase

### 2. Control flow and state modeling

- exhaustive handling of state variants where applicable
- consistent assertion and error patterns
- prefer explicit status/state fields over boolean flags for state transitions
- prefer guard clauses and early returns over deep nesting — three levels of conditional in one body is the trigger
- prefer data-driven lookups over long control-flow chains; likewise for one predicate re-tested throughout a body, and for a dispatch whose arms share an implementation. Not an exhaustive match over a closed type — a lookup table there trades a compile-time guarantee for a runtime one
- one error boundary per failure mode: nested or back-to-back `try` blocks mean the boundary hasn't been decided — extract each fallible step into a function that handles or propagates

### 3. Pattern consistency

Check where the codebase already has a clear local pattern:

- structural patterns (table-driven, rule-driven) where nearby code uses them
- error classification follows the project's established convention
- repeated argument groups that want one named type
- raw strings or magic values that should become typed constants
- sibling concepts with different intent should not collapse into one ambiguous shape or name

### 4. Readability and hygiene

- comments must earn their keep: flag any that restate *what* the code does, and banner/separator comments — a comment justifies itself only by a *why* a name, type, or test can't carry
- no unused params, dead branches, or ad-hoc fallbacks
- a new inline comment silencing a type, lint, or security check, or a stub standing where the work should be — an unimplemented throw, an empty catch turning a failure into silence. Flag it unless the diff says why
- keep style aligned with nearby code
- abstractions must earn their complexity — if a wrapper adds no value, inline it, judged against the language's own idiom rather than a general one: a newtype, or a constructor delegating to a default, is conventional and not an empty wrapper
- avoid nested ternaries for branching logic; use explicit conditionals, maps, or helpers when multiple cases affect readability
- prefer clarity over cleverness: dense one-liners that require a mental pause should be simplified
- a temp holding a complex expression, where the expression itself would read better named as a query

## Evidence threshold

Sections 1 and 3 require evidence of a local convention — cite the nearby code that establishes it. Sections 2 and 4 are default checks that apply without repo evidence, but cap them at **Consider** unless a documented convention elevates them. Never report a default check as must-fix.

A suppression comment is the exception: the lint or type config it silences is itself the documented convention, so cite that config and label it **Fix**.

## Workflow

1. Identify local style conventions from nearby code.
2. Compare against repo-wide documented conventions.
3. Find concrete deviations with evidence. For large diffs (more than 3 files), fan out **fast-tier** readers — one per file or logical area — to surface candidate findings. Verify each before reporting.
4. Report findings ordered by severity.

## Output

For each finding: **label** (Critical / Fix / Consider / Nit — see `review`), **file**, **violated convention**, **evidence** (cite both the offending line and the code that establishes the convention), **fix direction**.

- Bad: "`getUserData` — inconsistent, should be `fetchUserData`." (no evidence)
- Good: **Fix** — `src/api/user.ts:12` `getUserData` breaks the fetch-prefix convention (9 of 10 siblings in `src/api/` use `fetch*`). Rename to `fetchUserData`.

Order Critical → Fix → Consider → Nit. If nothing clears the threshold, report "No style findings" — don't pad. Aggregate repeated instances of one smell into a single finding carrying a count and two or three representative locations; ten separate entries for one pattern drown the review they sit in.

## See also

- `simplify` for performing the cleanups this review identifies

## Red flags

- Enforcing generic style dogma over local conventions
- Broad rewrites instead of minimal fixes
- Speculative abstractions
- Nitpicking formatting not tied to repo conventions
