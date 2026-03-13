# Initialize Template

Customize this repository template for your project.

## Instructions

Guide the user through template customization interactively.

### 1. Gather Project Information

Ask for:
- **Project name** (e.g., "my-awesome-app")
- **One-line description**
- **Tech stack** (e.g., "TypeScript, Node.js, PostgreSQL")
- **Primary language**: Node.js/TypeScript, Python, Go, Rust, or other
- **Security contact email**

### 2. Update Files

| File | Changes |
|------|---------|
| `README.md` | Title, description, update badges with correct repo |
| `CLAUDE.md` | Project name, tech stack, commands |
| `AGENTS.md` | Mirror CLAUDE.md changes |
| `.github/workflows/ci.yml` | Uncomment relevant language section |
| `.github/dependabot.yml` | Uncomment relevant ecosystem |
| `SECURITY.md` | Add security contact email |

### 3. Language-Specific Setup

Offer to create starter configs:

**Node.js/TypeScript:**
```json
// package.json with dev, build, test, lint scripts
// tsconfig.json if TypeScript
```

**Python:**
```toml
# pyproject.toml with pytest, ruff
```

**Go:**
```go
// go.mod with module path
```

**Rust:**
```toml
# Cargo.toml with project name
```

### 4. GitHub Issues Setup (Optional)

Ask: "Set up GitHub Issues management? (labels, project board sync, helper scripts)"

If yes:

1. **Create labels:** Run `bash scripts/labels.sh`
   - Creates 19 labels: `status:*` (4), `owner:*` (3), `priority:*` (3), type (9)
   - Idempotent — safe to run multiple times

2. **Project board sync** (optional): Ask "Set up Project board auto-sync?"
   - Create or detect a GitHub Projects v2 board
   - Discover GraphQL IDs: project ID, status field ID, option IDs (Planning, In Progress, Blocked, Done)
   - Replace placeholders in `.github/workflows/sync-status.yml`:
     - `__PROJECT_ID__`, `__STATUS_FIELD_ID__`
     - `__PLANNING_OPT__`, `__IN_PROGRESS_OPT__`, `__BLOCKED_OPT__`, `__DONE_OPT__`
   - Guide user to set `PROJECT_TOKEN` secret (needs `project` scope: `gh auth refresh -s project`)

3. **Notion sync** (optional): Ask "Sync issues to Notion?"
   - Get `NOTION_DATABASE_ID` and set `NOTION_API_KEY` secret
   - Fill in `NOTION_DATABASE_ID` in sync-status.yml

### 5. Cleanup

- Remove addressed `<!-- TODO -->` comments
- Offer initial commit: `chore: Initialize project from template`

### 6. Summary

Report what was changed and suggest:
- Add code to `src/`
- Write tests in `tests/`
- Create your first issue using the issue templates
- Run `scripts/my-tasks.sh` to see filtered issue views
- Enable GitHub security features in Settings
