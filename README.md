# Agent Skills

Opinionated engineering skills for AI coding agents. Process, not prose. Compatible with [agentskills.io](https://agentskills.io).

```
plan → build → review
```

Built while developing [Acolyte](https://github.com/cniska/acolyte). Some ideas refined after reviewing [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills).

## Install

```
npx skills add cniska/skills
```

## Skills

| Phase | Skill | Description |
|-------|-------|------------|
| **Plan** | explore | Clarify requirements through systematic questions |
| | plan | Design through dialogue, slice vertically |
| | issue | File a GitHub issue — check duplicates, draft, get approval |
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
| Save-point pattern | Commit early when exploring uncertain changes | git |
| Evidence threshold | Concrete references, not speculation | review skills |

## License

MIT
