# Claude Code Skills

> Project-local, auto-discovered Claude Code capabilities. Skills are loaded when their `description` matches the current task; commands remain the explicit `/project:X` entrypoints.

## Required Layout

Each skill is a directory containing `SKILL.md`:

```text
.claude/skills/
└── skill-name/
    └── SKILL.md
```

Flat files such as `.claude/skills/skill-name.md` are not discovered reliably and must not be used.

## Discovery Contract

A skill begins with YAML frontmatter:

```yaml
---
name: skill-name
description: "What the skill does and the specific situations in which Claude should use it."
---
```

The `description` is the discovery surface. Keep it specific, include likely user-language triggers, and quote it so YAML punctuation cannot break parsing.

### Skills vs. commands vs. agents

| Need | Use |
|---|---|
| Automatic assistance when a task matches | Skill |
| Explicit user-invoked workflow | `.claude/commands/` |
| Complex isolated or parallel work | `.claude/agents/` |

Skills consume some context through their descriptions. Prefer a small number of high-value, clearly triggered capabilities rather than broad generic helpers.

## Bundled Skills

This template ships seven working skills:

| Skill | Purpose |
|---|---|
| `cot` | Structured risk assessment before complex or destructive actions |
| `hibernate` | Put a repository into a dormant state and restore it later |
| `repo-docs` | Audit and improve README/documentation quality |
| `skill-builder` | Create new skills with valid discovery-oriented frontmatter |
| `skill-validator` | Validate skill structure, discovery, and YAML frontmatter |
| `task-cleanup` | Archive or clear completed task records |
| `template-upgrade` | Reconcile a repo-template-derived project with a newer template baseline while preserving project-specific work |

`template-upgrade` is intentionally paired with the model-neutral [`docs/TEMPLATE-UPGRADE.md`](../../docs/TEMPLATE-UPGRADE.md). Claude may auto-discover the skill, but Codex and other agents use the canonical SOP directly.

## Creating a Skill

Use the bundled `skill-builder` when possible. The minimal structure is:

```text
my-skill/
└── SKILL.md
```

Example:

```markdown
---
name: migration-safety
description: "Review database migrations for data-loss, rollback, and backward-compatibility risks. Use when creating or reviewing schema migrations."
---

# Migration Safety

1. Inspect the migration and surrounding schema.
2. Identify irreversible or compatibility-sensitive changes.
3. Verify rollback and deployment ordering.
4. Report risks and recommended remediation.
```

## Validation

For a new or edited skill:

1. Confirm it lives at `.claude/skills/<name>/SKILL.md`.
2. Parse the frontmatter as YAML.
3. Confirm `name` is unique and `description` is specific.
4. Test likely trigger phrases.
5. Run the repository template validation before merge.

A quick YAML check:

```bash
python3 - <<'PY'
from pathlib import Path
import yaml
p = Path('.claude/skills/my-skill/SKILL.md')
frontmatter = p.read_text().split('---', 2)[1]
yaml.safe_load(frontmatter)
print('OK')
PY
```

## See Also

- [Commands](../commands/) — explicit project workflows
- [Agents](../agents/README.md) — specialized sub-agents
- [Template Upgrade SOP](../../docs/TEMPLATE-UPGRADE.md) — cross-agent downstream reconciliation
