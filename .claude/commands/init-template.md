# Initialize Template

Customize this repository template for your project.

## Mode Selection

Ask: **"Quick setup (essentials only) or full setup (all features)?"**

- **Quick** (Steps 1-4): Get coding fast — core files + language setup
- **Full** (Steps 1-8): Everything — issues, security, dev tooling, releases

---

## Quick Mode (Steps 1-4)

### 1. Gather Project Information

Ask for:
- **Project name** (e.g., "my-awesome-app")
- **One-line description**
- **Tech stack** (e.g., "TypeScript, Node.js, PostgreSQL")
- **Primary language**: Node.js/TypeScript, Python, Go, Rust, or other
- **Security contact email**

### 2. Update Core Files

| File | Changes |
|------|---------|
| `README.md` | Title, description, badges with correct repo |
| `CLAUDE.md` | Project name, tech stack, commands, architecture |
| `AGENTS.md` | Mirror CLAUDE.md changes |
| `GEMINI.md` | Mirror CLAUDE.md changes |
| `.cursorrules` | Mirror AGENTS.md changes |
| `.windsurfrules` | Mirror AGENTS.md changes |
| `.github/copilot-instructions.md` | Mirror changes |
| `.github/workflows/ci.yml` | Uncomment relevant language section |
| `.github/dependabot.yml` | Uncomment relevant ecosystem |
| `.github/CODEOWNERS` | Fill in owner username |
| `CODE_OF_CONDUCT.md` | Fill in enforcement email |
| `SECURITY.md` | Add security contact email |

Set repository description: `gh repo edit --description "one-line description"`

### 3. Language-Specific Setup

Offer to create starter configs:

**Node.js/TypeScript:** package.json, tsconfig.json
**Python:** pyproject.toml
**Go:** go.mod
**Rust:** Cargo.toml

Also uncomment matching section in:
- `.devcontainer/devcontainer.json` (language feature + VS Code extension)
- `.vscode/extensions.json` (language extension)

### 4. Quick Security Hardening

Ask: "Harden GitHub security settings? (recommended, takes 5 seconds)"

If yes:
- Run `bash scripts/secure-repo.sh` — enables Dependabot alerts, branch protection, tag protection
- Run `bash templates/hooks/setup-hooks.sh` — installs pre-commit secret scanning hook

These are fast, safe, and reversible. No reason to skip them.

### 5. Cleanup & Summary

- Remove addressed `<!-- TODO -->` comments
- Offer initial commit: `chore: initialize project from template`
- Report the security scorecard from `secure-repo.sh`

**If Quick mode: STOP HERE.** Suggest: "Run `/project:init-template` again with Full mode later to add issues, advanced security, dev tooling, and releases."

---

## Full Mode (continues from Step 5)

### 6. GitHub Issues Setup

Ask: "Set up GitHub Issues management?"

If yes:
1. Run `bash scripts/labels.sh` (creates 25+ labels, idempotent)
2. **Project board sync** (optional):
   - Create/detect GitHub Projects v2 board
   - Discover GraphQL IDs and fill in `sync-status.yml` placeholders
   - Guide: `gh auth refresh -s project` for PROJECT_TOKEN secret
3. **Notion sync** (optional): Get NOTION_DATABASE_ID + NOTION_API_KEY secret

### 7. Advanced Security & Compliance

If `secure-repo.sh` was already run in Quick Mode (Step 4), this step covers the advanced options:

- **CodeQL:** Uncomment matching language in `.github/workflows/codeql.yml`
- **Branch protection (advanced):** If Step 4's basic protection isn't enough (e.g., require PR reviews, signed commits), run full `gh api` commands from `docs/BRANCH-PROTECTION.md`
- **Commit signing:** "Set up commit signing?" → see `docs/BRANCH-PROTECTION.md` for SSH/GPG instructions
- **FUNDING.yml:** "Set up sponsor button?" → uncomment platform + username
- **GitHub Topics:** "Add topics for discoverability?" → suggest relevant topics, run `gh repo edit --add-topic TOPIC`

**Fork-specific:** If the repo was created as a fork:
- Block upstream push: `git config remote.upstream.pushurl "NEVER_PUSH_TO_UPSTREAM_USE_PR"`
- Review `docs/FORK-SECURITY.md` for fork-specific security guidance
- Disable Actions on the fork if not needed: `gh api -X PUT repos/OWNER/REPO/actions/permissions --input - <<< '{"enabled": false}'`

### 8. Developer Tooling

- **Linting:** "Install linting config?" → copy from `templates/linting/` to root
- **Pre-commit hooks (linting):** "Add linting hooks?" → Node: husky; Python/Go: pre-commit (chains with secret scanning hook)
- **Coverage:** "Set up coverage?" → uncomment CI steps, copy `templates/coverage/codecov.yml.template`
- **Makefile:** "Install Makefile?" → copy from `templates/tooling/Makefile.template`
- **Version pinning:** "Pin language versions?" → copy `.tool-versions` with selected language

### 9. Release & Final Setup

- **Release workflow:** "Release method? (Tag-based / semantic-release / skip)" → uncomment variant in `.github/workflows/release.yml`
- **License:** "License? (MIT / Apache-2.0 / GPL-3.0 / keep MIT)" → update LICENSE file
- **Social preview:** Suggest adding a custom image in Settings > Social preview

Final commit: `chore: complete full project initialization`

Report everything that was configured. Suggest:
- Create your first issue using the templates
- Run `scripts/my-tasks.sh` to see filtered views
- Push a commit to trigger CI
- Tag `v0.1.0` to test the release workflow
