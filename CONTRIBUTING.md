# Contributing

## Skill format

- Each skill lives in `<name>/SKILL.md`.
- YAML frontmatter is required and must include `name` and `description`.
- Frontmatter `name` must match the directory name.
- `description` starts with an imperative verb.
- Use `## Red flags` for warning sections (not `## Anti-patterns`).

## Commits

- Use Conventional Commit format: `type(scope): description`.
- Subject line only. No commit body.
- Keep commits focused and slice-based (one logical change per commit).

## Local checks

Before pushing:

```bash
make validate
```

For first-time setup in a fresh clone:

```bash
./scripts/bootstrap.sh
```
