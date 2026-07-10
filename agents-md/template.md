# Project Rules

<One sentence: what the project is and its primary runtime/surface.> If a `SPEC.md` or canonical doc is the source of requirements, name it here and say to read it first.

## Architecture

<Module boundaries, entry points, extension points — where to add a new X.> Keep this to a reference line pointing to `docs/architecture.md` when one exists; a long architecture section belongs in a doc humans and agents read on demand, not here.

## Invariants

These must always hold; break them and the system breaks — often silently.

1. <The rule that, if broken, corrupts data or breaks the system in a non-obvious way. Cite a spec ID (e.g. `FR-15`) when one applies.>
2. Run `<verify command>` before every commit.

## Workflow

1. <Autonomy stance: default to autonomous; pause only when a decision is ambiguous, risky, or irreversible.>
2. When behavior and tests diverge, fix the implementation — update expectations only if explicitly asked.
3. Commit only when explicitly requested.
4. Keep the spec/canonical doc current — it never lags the code; requirement changes land in the same change.
5. <Branch/PR vs direct-to-`main` policy: what lands via branch + review, what commits straight to `main`.>

## Commits

Format: `type(scope): description` — types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`. Single-line subject, no body, ASCII only. Aim under 50 characters, never over 72 (counting the ` (#N)` a squash-merge appends). No issue references or spec IDs in the subject — describe the change; the spec is the reference for why.

## Pull requests

- Gate: run `/review` (multi-dimension, not `/code-review`) and fix all findings before opening.
- Title: conventional-commit form, under 50 characters, no trailing period; it becomes the squash-merge subject.
- Body follows `.github/pull_request_template.md`: brief motivation (omit when obvious), then a flat summary; cut anything a reviewer would infer from the diff.
- End with `Fixes #N` when an issue matches. Never push or open a PR without approval.

## Code

- No transitional architecture: land the canonical owner, contract, and single source of truth.
- Define string unions and shared types as a schema first (e.g. Zod), infer the type from it.
- Import from the canonical module — no re-export layers.
- Comments: code documents itself. Add one only for a *why* that can't be encoded in a name, type, or test — never the *what*, never banner/separator comments.

## Style

- <Formatter and linter of record, with the command to run them.>
- <Naming conventions that deviate from the language default — e.g. `create*` factories, direct `export const` over alias + re-export.>

## Docs

- One H1 per doc (page title); H1 title case, H2+ sentence case.
- <Where docs live and when to update them.>

## Testing

- <Command to run the suite.>
- Unit tests are pure — mock boundary effects (filesystem, network, subprocess); integration tests exercise the real wiring.
- Any invariant above that needs a dedicated test gets one (it is not covered by happy-path tests alone).
