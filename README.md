# skills

Agent skills for a structured engineering workflow. Compatible with [agentskills.io](https://agentskills.io).

I built these to work more efficiently with AI coding agents. They took shape while building [Acolyte](https://github.com/cniska/acolyte). Generic prompts did not hold up across sessions — the agent would drift, second-guess itself, or produce noise instead of findings. These skills encode the workflow that actually worked.

## Install

```
npx skills@latest add cniska/skills
```

Or pick individual skills:

```
npx skills@latest add cniska/skills -s plan
```

## What is in here

### Workflow

- **explore** — Ask questions one at a time until the task is clear. If the code can answer, read the code instead of asking.
- **plan** — Design a feature through dialogue. The plan emerges from conversation, not isolation.
- **issue** — Create a GitHub issue. Check for duplicates, show a draft, get approval before creating.
- **pr** — Create a pull request. Runs verification and review before opening.

### Audits

- **review** — Run all audits below against the current branch diff in one pass.
- **style-audit** — Naming, control flow, pattern consistency. Enforces local conventions, not generic style guides.
- **arch-audit** — Boundaries, indirection pressure, contract integrity. If a layer carries no policy, remove it.
- **docs-audit** — Doc drift, terminology gaps, outdated names after refactors.
- **security-audit** — Trust boundaries, execution safety, secret exposure. Only reports concrete attack paths.
- **test-audit** — Coverage gaps, edge cases, test quality. Does not demand 100% coverage.

## How they work

Every audit skill has the same structure: scope, evidence threshold, workflow, output format, anti-patterns. The evidence threshold is what matters. Findings need concrete code references or plausible failure scenarios. No speculative concerns, no generic style dogma.

The skills compose. `/review` runs all five audits and deduplicates. `/pr` gates on `/review` before creating the pull request. You can run any audit individually if that is all you need.

## License

MIT
