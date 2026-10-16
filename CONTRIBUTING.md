# Contributing

Thank you for considering a contribution.

## What is welcome

- Language or framework diagnostics added to `references/` (for example Node.js, Go, Rust, Java)
- Additional worked examples in `examples/`
- Clarifications that make a phase easier to follow
- Reports of cases where the skill let an unverified claim through

## Guidelines

1. Keep `SKILL.md` under 500 lines. Put detail in `references/` and link to it from the workflow table.
2. Preserve the core rule: no success claim without execution.
3. Keep the verification vocabulary (`VERIFIED`, `PARTIALLY VERIFIED`, `UNVERIFIED`) unchanged.
4. Use formal, precise language. Avoid emojis.
5. Every new reference file must be linked from `SKILL.md` and from the README.
6. New examples should follow the report template in `references/06-report-template.md`.

## Pull request checklist

- [ ] Frontmatter in `SKILL.md` is valid (`name` and `description` present)
- [ ] New files are linked from `SKILL.md` and the README
- [ ] Examples include a verification status
- [ ] No claims of success without evidence
