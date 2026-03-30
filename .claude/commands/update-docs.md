# Update Documentation

Scan project documentation for quality issues and suggest improvements following the patterns in [docs/DOCUMENTATION-GUIDE.md](docs/DOCUMENTATION-GUIDE.md).

## Checks to Run

### 1. Missing At-a-Glance Summaries

Scan all `.md` files in the repo (excluding `_admin/`, `node_modules/`, `.git/`). Check if each file starts with a blockquote summary (a line beginning with `>` within the first 5 lines).

Report files that are missing summaries.

### 2. Cross-Reference Link Validation

For each `.md` file, extract all relative links (links that don't start with `http` or `mailto`). Check if the target file or directory exists.

Report broken links with their source file and target.

### 3. README Counts Match Filesystem

Check that claims in README.md match reality:
- "7 AI" agents — count: `ls CLAUDE.md AGENTS.md GEMINI.md .cursorrules .windsurfrules .github/copilot-instructions.md .aider.conf.yml 2>/dev/null | wc -l`
- "16 Workflows" — count: `find .github/workflows -name '*.yml' -type f | wc -l`
- "5 templates" — count: `find .github/ISSUE_TEMPLATE -name '*.yml' -not -name 'config.yml' -type f | wc -l`
- "25+ labels" — count: `grep -c 'gh label create' scripts/labels.sh`

Report any mismatches.

### 4. CHANGELOG Has Recent Entries

Check if CHANGELOG.md exists and has an entry dated within the last 30 days. If stale, suggest updating it.

### 5. Documentation Quality Suggestions

For each `.md` file in `docs/`:
- Check for Mermaid diagrams (files covering complex topics should have at least one)
- Check for GitHub callouts (TIP, WARNING, IMPORTANT, NOTE, CAUTION)
- Check for "See also" links at the bottom
- Check for unfilled `<!-- TODO -->` placeholders

### Output Format

Present findings as a checklist:

```
Documentation Audit Results
===========================

Missing at-a-glance summaries:
  [ ] docs/ARCHITECTURE.md — add blockquote summary at top
  [x] docs/AI-SECURITY.md — has summary

Broken links:
  [ ] README.md -> docs/MISSING.md (file not found)

README count mismatches:
  [x] AI agents: 7 (matches)
  [ ] Workflows: found 15, README says 16

CHANGELOG:
  [ ] Last entry: 2026-01-15 (stale — update recommended)

Quality suggestions:
  [ ] docs/ARCHITECTURE.md — no Mermaid diagrams (consider adding one)
  [ ] CONTRIBUTING.md — no GitHub callouts (consider adding a TIP)
```

For each issue found, suggest the specific fix following DOCUMENTATION-GUIDE.md patterns.
