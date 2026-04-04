# Agent Skills

Engineering skills for AI coding agents. Each skill is a step-by-step workflow the agent follows — not reference documentation. Compatible with [agentskills.io](https://agentskills.io).

```
plan → build → review
```

I wrote these to work more efficiently with AI coding agents. They are opinionated, based on 15+ years of building production software, and encode the workflow I actually follow. They took shape while building [Acolyte](https://github.com/cniska/acolyte), where generic prompts did not hold up across sessions; the agent would drift, second-guess itself, or produce noise instead of findings.

Some ideas refined after reviewing [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills).

## Install

```
npx skills add cniska/skills
```

Or pick individual skills:

```
npx skills add cniska/skills -s plan
```

## Skills

| Phase | Skill | Description |
|-------|-------|------------|
| **Plan** | explore | Clarify requirements through systematic questions |
| | plan | Design through dialogue, slice vertically |
| **Build** | build | Vertical slices — implement, verify, commit, repeat |
| | tdd | Red-green-refactor, mock at boundaries |
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
| **Workflow** | pr | Verify, review, then open the pull request |
| | issue | Check duplicates, draft, get approval, create |

## Principles

These show up across multiple skills and form the shared engineering philosophy.

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
| Save-point pattern | Commit early when exploring uncertain changes | git |
| Evidence threshold | Concrete references, not speculation | review skills |

## How they work

Every review skill has the same structure: scope, evidence threshold, workflow, output format, red flags. The evidence threshold is what matters. Findings need concrete code references or plausible failure scenarios. No speculative concerns, no generic style dogma.

The skills compose. `/review` runs all five review dimensions and deduplicates. `/pr` gates on `/review` before creating the pull request. You can run any skill individually if that is all you need.

## License

MIT
