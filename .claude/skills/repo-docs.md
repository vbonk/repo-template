---
name: repo-docs
description: Audit and upgrade repository documentation to production quality. Generates or rewrites README.md with status badges, at-a-glance metrics, architecture diagrams, document indexes, and proper structure. Validates and improves all docs/ files with cross-references, callouts, summaries, and Mermaid diagrams. Use when docs are stale, thin, or template placeholders. Triggers on "update docs", "fix readme", "improve documentation", "docs audit", "readme", "document this repo".
---

# Repo Documentation Skill

Bring any repository's documentation up to production quality. Modeled on the standard set by well-maintained repos with status dashboards, architecture diagrams, document indexes, and cross-referenced docs.

## When to Use

- README is a template placeholder or outdated
- Docs are thin, missing, or inconsistent
- After significant project changes that docs don't reflect
- Before sharing a repo with collaborators or going public
- When docs exist but lack structure, cross-references, or visual aids
- Periodic docs hygiene pass

## Quality Standard

Every repo's documentation should meet these criteria:

### README.md Must Have

1. **Title and one-line description** — what this project is
2. **Status badges** — phase, build status, key metrics (use shields.io)
3. **At-a-Glance table** — current state of key components with status indicators
4. **Blockquote summary** — 1-2 sentence elevator pitch after badges
5. **Table of Contents** — linked sections for anything over 100 lines
6. **Architecture section** — Mermaid diagram showing system components
7. **Getting Started** — prerequisites, setup, first run
8. **Commands** — dev, build, test, lint (table format)
9. **Project Structure** — file tree with annotations
10. **Key Decisions** — table of important architectural choices with rationale
11. **Environment Variables** — table with required/optional, description
12. **Deployment** — where it runs, how to deploy
13. **Related Repos** — if part of a multi-repo system
14. **Last Updated date** — when the README was last verified

### docs/ Files Must Have

1. **Blockquote summary at top** — what this doc covers (within first 5 lines)
2. **Last Updated date**
3. **Referenced by / See also** — cross-references to related docs
4. **GitHub callouts** — WARNING, IMPORTANT, NOTE, TIP, CAUTION where appropriate
5. **Tables for structured data** — not prose paragraphs listing things
6. **Mermaid diagrams** — for anything involving flow, architecture, or relationships
7. **No unfilled TODOs** — replace or remove `<!-- TODO -->` placeholders
8. **Working links** — all relative links resolve to real files

## Procedure

### Phase 1: Audit Current State

Read the current documentation and assess:

```
1. Read README.md — score against the 14-point checklist above
2. List all .md files in docs/ — score each against the 8-point checklist
3. Read CLAUDE.md — extract project context (name, stack, architecture, commands, deployment)
4. Read package.json or equivalent — extract name, description, scripts, dependencies
5. Check git log --oneline -10 — understand recent activity
6. Check for existing Mermaid diagrams, badges, tables
7. Run: find docs/ -name "*.md" -exec grep -L "^>" {} \; — files missing summaries
8. Run: grep -r "<!-- TODO" docs/ README.md — unfilled placeholders
```

Report findings as a checklist:

```
## Documentation Audit: {repo-name}

### README.md (X/14)
- [x] Title and description
- [ ] Status badges — MISSING
- [ ] At-a-Glance table — MISSING
- [x] Blockquote summary
...

### docs/ Files (Y total, Z passing)
- docs/strategy.md (6/8) — missing: cross-references, Mermaid diagram
- docs/architecture.md (3/8) — missing: summary, date, callouts, links, diagram
...

### Broken Links
- README.md:42 → docs/MISSING.md (not found)

### Stale Placeholders
- CLAUDE.md:15 — "<!-- TODO: Replace with project name -->"
```

### Phase 2: Generate / Rewrite

Based on the audit, generate or rewrite documentation:

#### README.md Generation

Use project context from CLAUDE.md, package.json, and the codebase to generate a complete README following the 14-point standard. Key principles:

- **Extract real data** — don't invent metrics. Count actual files, issues, tests.
- **Use shields.io badges** — `https://img.shields.io/badge/{label}-{value}-{color}`
- **Mermaid architecture diagram** — derive from CLAUDE.md architecture section or actual file structure
- **Commands from package.json** — use actual scripts, not guesses
- **Project structure from filesystem** — use actual directory listing

Badge color conventions:
- Green (`brightgreen`): live, complete, passing
- Blue (`blue`): in progress, informational
- Yellow (`yellow`): pending, warning
- Red (`red`): blocked, failing

At-a-Glance table format:
```markdown
| Metric | Value | Status |
|--------|-------|--------|
| **Phase** | Phase 1: Foundation | ![60%](https://img.shields.io/badge/60%25-blue?style=flat-square) |
| **Stack** | Next.js 14, TypeScript | ![Live](https://img.shields.io/badge/Live-brightgreen?style=flat-square) |
```

#### docs/ File Improvement

For each doc file that scored below 6/8:
1. Add blockquote summary if missing
2. Add "Last Updated" date
3. Add "Referenced by" / "See also" section with actual cross-references
4. Add GitHub callouts where content warrants warnings, tips, or important notes
5. Convert prose lists to tables where appropriate
6. Add Mermaid diagrams for flow/architecture content
7. Fix broken links
8. Remove or fill TODO placeholders

#### Document Index

If the repo has 5+ docs, generate a document index section in README.md:

```markdown
## Document Index

| Category | Document | Purpose |
|----------|----------|---------|
| Strategy | [strategy.md](docs/strategy.md) | Niche positioning, content model, monetization |
| Architecture | [architecture.md](docs/architecture.md) | System design and tech decisions |
```

### Phase 3: Validate

After writing, verify:

```
1. All relative links in README.md resolve to real files
2. All relative links in docs/*.md resolve to real files
3. README badge counts match filesystem reality
4. No <!-- TODO --> placeholders remain
5. Every docs/ file has a blockquote summary
6. Mermaid diagrams render (check syntax)
```

Report final scores:

```
## Documentation Updated

### Before → After
- README.md: 5/14 → 14/14
- docs/strategy.md: 4/8 → 8/8
- docs/options.md: 3/8 → 7/8

### New Files Created
- (none, or list any)

### Validation
- [x] All links resolve
- [x] Badge counts match reality
- [x] No TODO placeholders
- [x] All docs have summaries
```

## Important Notes

- **Never invent metrics.** If you can't verify a number, don't badge it.
- **Preserve existing content.** Improve structure and add missing elements — don't rewrite accurate prose.
- **README is the storefront.** It's the first thing anyone sees. Invest accordingly.
- **CLAUDE.md is the source of truth for project context.** README should be consistent with it but serve a different audience (humans browsing GitHub vs. AI agents working in the repo).
- **Cross-reference actively.** Every doc should link to related docs. Orphaned docs are invisible docs.
- **Keep it maintainable.** Don't add metrics that will go stale without automation. Static facts (stack, architecture) are fine. Dynamic counts need a process to update.
