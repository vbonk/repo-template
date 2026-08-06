# ADR-003: Skills Use the <name>/SKILL.md Directory Layout

## Status

Accepted (2026-08)

## Context

Six skills shipped April 2026 as flat `.claude/skills/<name>.md` files. Runtime verification (August 2026: a fixture repo with both layouts queried via `claude -p`) proved Claude Code silently ignores flat files and discovers only `<name>/SKILL.md` directories — every bundled skill had been dead weight for four months. The bundled skill-validator even taught the correct layout while the template shipped the wrong one.

## Decision

Every skill is a directory containing `SKILL.md` with `name` and `description` frontmatter (documented fields only — the undocumented `triggers:` list is ignored by Claude Code; trigger phrases belong in the description). A self-test design-check fails if any skill directory lacks SKILL.md or any flat skill file appears.

## Consequences

### Positive

- Skills actually load (verified at runtime, both directions)
- Directories can carry supporting files alongside SKILL.md
- The layout mistake cannot silently recur

### Negative

- One-file skills carry directory overhead
- Downstream repos created from pre-migration snapshots need manual migration
