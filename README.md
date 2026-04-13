# Agent Skills

Engineering skills for AI coding agents. Compatible with [agentskills.io](https://agentskills.io).

```
plan → build → review
```

I wrote these to work more efficiently with AI coding agents. They are opinionated, based on 15+ years of building production software, and encode the workflow I actually follow. They took shape while building [Acolyte](https://github.com/cniska/acolyte), where generic prompts did not hold up across sessions.

Some ideas were refined after reviewing [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills).

## Motivation

This repo exists to encode a practical engineering workflow for AI coding agents in my own tone and decision style. The goal is consistent execution quality across sessions, not generic prompt patterns.

## How I update these skills

Maintenance inputs: daily use in my own projects, gaps observed in real sessions, and selective upstream review (for example Addy updates) as a signal, not a source of truth.

I add guidance when it:

- repeats in real work
- improves quality, speed, or risk profile
- can be verified with concrete checks
- fits the way I want agents to operate

I remove or simplify guidance when it:

- no longer changes outcomes
- becomes outdated
- duplicates other skills
- drifts toward generic "corp" voice without adding value

## Install

```
npx skills add cniska/skills
```

## Local setup

Enable repository hooks (for pre-push commit-message checks):

```
git config core.hooksPath .githook
```

Active pre-push hook: [`.githook/pre-push`](.githook/pre-push)

## Skills

| Phase | Skill | Description |
|-------|-------|------------|
| **Plan** | explore | Clarify requirements through systematic questions |
| | plan | Design through dialogue, slice vertically |
| | issue | File a GitHub issue — check duplicates, draft, get approval |
| **Build** | build | Vertical slices — implement, verify, commit, repeat |
| | tdd | Red-green-refactor, mock at boundaries |
| | sdd | Source-driven development: verify library and API behavior in primary sources |
| | debug | Stop the line, reproduce, fix root cause, guard with test |
| | design | Hard-to-misuse interfaces, contract first, validate at boundaries |
| | simplify | Reduce complexity, Chesterton's Fence, preserve behavior |
| | git | Atomic commits, clean history, rewrite before pushing |
| | deprecation | Build replacement first, migrate consumers, remove completely |
| **Review** | review | Run all review dimensions, severity labels, fix-all policy |
| | style | Local conventions, naming, control flow, readability |
| | architecture | Boundaries, indirection pressure, contract integrity |
| | security | Trust boundaries, execution safety, concrete attack paths only |
| | tests | Coverage gaps, edge cases, test quality |
| | docs | Drift detection, terminology, outdated names |
| **GitHub** | pr | Verify, review, then open the pull request |

## Principles

| Principle | In practice | Skills |
|-----------|------------|--------|
| Vertical slices | One complete path through the stack at a time | build, plan |
| Contract first | Schema before implementation | design, build |
| SRP | One responsibility per module, one change per commit | architecture, build, git |
| YAGNI | Don't build for hypothetical requirements | architecture, design |
| Stop the line | Something breaks — stop, don't push past it | debug |
| Prove-It pattern | Failing test before fix | debug, tdd |
| Mock at boundaries | Mock external systems, not internal functions | tdd, tests |
| DAMP over DRY | Descriptive tests over deduplicated tests | tdd |
| Rule of 3 | Extract after three instances, not before | simplify, style |
| Chesterton's Fence | Understand before removing | simplify |
| Hyrum's Law | All observable behavior becomes a commitment | design, deprecation |
| Code as liability | Less code serving the same purpose is better | deprecation |
| Source over memory | Verify framework behavior in primary docs before implementation | sdd |
| Save-point pattern | Commit early when exploring uncertain changes | git |
| Evidence threshold | Concrete references, not speculation | review skills |

## Reference checklists

- [testing-patterns.md](references/testing-patterns.md)
- [security-checklist.md](references/security-checklist.md)
- [performance-checklist.md](references/performance-checklist.md)
- [accessibility-checklist.md](references/accessibility-checklist.md)

## Validate skills

Run the validator before publishing changes:

```
make validate
```

`make validate` runs [`./scripts/validate.sh`](scripts/validate.sh).

CI runs the same validation on pull requests and pushes to `main` via [`.github/workflows/validate.yml`](.github/workflows/validate.yml).

CI also validates commit messages on pull requests via [`.github/workflows/commit-messages.yml`](.github/workflows/commit-messages.yml).

## Create a new skill

Use the scaffold script:

```
./scripts/new-skill.sh <kebab-case-name> "<imperative description>"
```

Scaffold script: [`./scripts/new-skill.sh`](scripts/new-skill.sh)

Bootstrap script: [`./scripts/bootstrap.sh`](scripts/bootstrap.sh)

Template reference: [`SKILL_TEMPLATE.md`](SKILL_TEMPLATE.md).

## License

MIT
