# repo-template

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![AI Agents: 6](https://img.shields.io/badge/AI%20Agents-6%20Supported-blue)](https://github.com/vbonk/repo-template)
[![CI](https://github.com/vbonk/repo-template/actions/workflows/ci.yml/badge.svg)](https://github.com/vbonk/repo-template/actions/workflows/ci.yml)
[![GitHub release](https://img.shields.io/github/v/release/vbonk/repo-template)](https://github.com/vbonk/repo-template/releases)
[![GitHub stars](https://img.shields.io/github/stars/vbonk/repo-template)](https://github.com/vbonk/repo-template/stargazers)
[![GitHub last commit](https://img.shields.io/github/last-commit/vbonk/repo-template)](https://github.com/vbonk/repo-template/commits)

**The AI-first GitHub repository template.** Six AI agents. Security by default. Production-ready in 2 minutes.

Stop wasting time on boilerplate. Start every project with CI/CD, security scanning, six AI agent configs, issue management, and compliance auditing already in place.

<p align="center">
  <a href="https://github.com/vbonk/repo-template/generate">
    <img src="https://img.shields.io/badge/Use%20This%20Template-238636?style=for-the-badge&logo=github&logoColor=white" alt="Use this template">
  </a>
</p>

---

<details>
<summary><strong>▶ Table of Contents</strong></summary>

- [Who Is This For?](#who-is-this-for)
- [Why This Template?](#why-this-template)
- [Features](#features)
- [What's Included](#whats-included)
- [Workflows](#workflows)
  - [New Project Workflows](#new-project-workflows)
  - [Existing Repository Workflows](#existing-repository-workflows)
  - [Workflow Comparison](#workflow-comparison)
- [What's Next?](#whats-next)
- [AI Agent Configuration](#ai-agent-configuration)
- [CI/CD](#cicd)
- [Issue Management](#issue-management)
- [Customization Guide](#customization-guide)
- [FAQ](#faq)
- [Contributing](#contributing)
- [Security](#security)
- [License](#license)
- [Acknowledgments](#acknowledgments)

</details>

---

## Who Is This For?

This template is built for:

- **Solo developers** tired of repetitive project setup
- **Teams** wanting consistent structure across repositories
- **AI-first developers** using Claude Code, GitHub Copilot, Codex, or similar tools
- **Security-conscious developers** who want sensible defaults without the research

If you create GitHub repositories regularly and want them production-ready from the start, this is for you.

---

## Why This Template?

| Traditional Setup | With This Template |
|-------------------|-------------------|
| 30+ minutes configuring | 2 minutes to start |
| Security gaps from forgetting steps | Secure by default |
| AI agents need context each session | AI agents productive immediately |
| Inconsistent structure across projects | Same patterns everywhere |

---

## Features

- **🤖 Six AI Agents** — Claude Code, Copilot, Cursor, Codex, Gemini, Windsurf — all configured
- **🔒 Secure by Default** — SHA-pinned Actions, CodeQL scanning, dependency review, prompt injection defense, secret scanning (pre-commit + CI), automated repo hardening
- **⚡ Quick or Full Setup** — 2-minute quick mode or comprehensive 8-step configuration
- **📋 Issue Management** — 5 templates (agent/human/external/bug/feature), 25+ labels, project board sync
- **🔄 13 Workflows** — CI, releases, stale management, auto-labeling, PR sizing, security scanning
- **🛡️ AI Security** — CODEOWNERS on AI configs, PR injection scanner, defense documentation
- **📦 Dev Experience** — Devcontainer, linting templates, pre-commit hooks, VS Code settings
- **📊 Compliance Audit** — Score any repo against template standards with `scripts/audit-compliance.sh`

---

## What's Included

```
┌─────────────────────────────────────────────────────────────┐
│  repo-template                                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  📁 .github/                                                │
│     ├── workflows/ci.yml      → CI pipeline (multi-stack)  │
│     ├── workflows/sync-status → Label → Project board sync │
│     ├── ISSUE_TEMPLATE/       → 5 issue forms + config     │
│     ├── PULL_REQUEST_TEMPLATE → PR checklist               │
│     ├── dependabot.yml        → Dependency updates         │
│     └── copilot-instructions  → GitHub Copilot config      │
│                                                             │
│  📁 .claude/                                                │
│     └── commands/             → Custom slash commands       │
│                                                             │
│  📁 scripts/                                                │
│     ├── labels.sh             → Create/update labels       │
│     ├── my-tasks.sh           → Filtered issue views       │
│     └── close-issue.sh        → Close with status:done     │
│                                                             │
│  📁 src/                      → Your source code            │
│  📁 tests/                    → Your tests                  │
│  📁 docs/                     → Documentation               │
│                                                             │
│  📄 CLAUDE.md                 → Claude Code instructions    │
│  📄 AGENTS.md                 → Cross-agent compatibility   │
│  📄 CONTRIBUTING.md           → Contribution guidelines     │
│  📄 SECURITY.md               → Security policy             │
│  📄 .gitignore                → Comprehensive patterns      │
│  📄 .editorconfig             → Consistent formatting       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Workflows

Choose the workflow that matches your situation:

### New Project Workflows

<details open>
<summary><strong>▶ Workflow A: GitHub Template (Recommended for most users)</strong></summary>

Best for: Quick start with GitHub's UI

1. Click **[Use this template](https://github.com/vbonk/repo-template/generate)** → Name your repo → Create
2. Clone your new repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
   cd YOUR_REPO
   ```
3. Open with Claude Code and run:
   ```
   /project:init-template
   ```
4. Answer the prompts — files update automatically

> [!IMPORTANT]
> After creating from template, run `scripts/labels.sh` to create issue labels. Labels, branch protection, secrets, and Projects do **not** transfer from template repos. See `docs/BRANCH-PROTECTION.md` for protection setup.

```mermaid
flowchart LR
    A[🎯 Use Template] --> B[📥 Clone Repo]
    B --> C[🤖 Run /init-template]
    C --> D[💬 Answer Questions]
    D --> E[✨ Files Updated]
    E --> F[🚀 Start Coding]

    style A fill:#238636,color:#fff
    style F fill:#238636,color:#fff
```

</details>

<details>
<summary><strong>▶ Workflow B: Local-First (For pre-planned projects)</strong></summary>

Best for: When you've already planned your project structure or have existing code

1. Create a local directory for your project:
   ```bash
   mkdir my-project && cd my-project
   git init
   ```
2. Start Claude Code in this directory
3. Add the init command:
   ```bash
   mkdir -p .claude/commands
   curl -sL https://raw.githubusercontent.com/vbonk/repo-template/main/.claude/commands/init-template.md \
     -o .claude/commands/init-template.md
   ```
4. Run `/project:init-template` — the agent will:
   - Ask about your project objectives and tech stack
   - Generate customized template files
   - Create the GitHub repository
   - Push the initial commit

**Advantage:** Files are customized before the GitHub repo exists — no template placeholders to clean up.

**Note:** Requires GitHub CLI (`gh`) to be installed and authenticated.

</details>

<details>
<summary><strong>▶ Workflow C: Spin-off from Existing Session</strong></summary>

Best for: When working in Claude Code and you realize a component should be its own project

1. While in an existing Claude Code session, describe the new project
2. Ask Claude to create a new repository for it
3. The agent will:
   - Set up the new repo with template standards
   - Move or generate relevant code
   - Push to GitHub
   - Return context to your original project

**Example prompt:** "Let's spin off the authentication module into its own repository called `my-auth-service`"

</details>

<details>
<summary><strong>▶ Workflow D: Empty GitHub Repo + Manual Setup</strong></summary>

Best for: Users who prefer full control or don't use Claude Code

1. Create an empty repository on GitHub (no README, no .gitignore)
2. Clone it locally
3. Copy template files manually or download from this repo
4. Find and update `TODO` comments:
   ```bash
   grep -r "TODO" --include="*.md" --include="*.yml"
   ```

| File | What to Change |
|------|---------------|
| `README.md` | Project name, description, badges |
| `CLAUDE.md` | Your tech stack and commands |
| `AGENTS.md` | Same as CLAUDE.md (for other AI tools) |
| `.github/workflows/ci.yml` | Uncomment your language section |
| `.github/dependabot.yml` | Uncomment your package ecosystem |
| `SECURITY.md` | Your security contact email |

</details>

---

### Existing Repository Workflows

<details>
<summary><strong>▶ Workflow E: Retrofit an Existing Repository</strong></summary>

Best for: Bringing an older repo up to template standards

1. First, add the init command to your existing repo:
   ```bash
   # From your existing repo root:
   mkdir -p .claude/commands
   curl -sL https://raw.githubusercontent.com/vbonk/repo-template/main/.claude/commands/init-template.md \
     -o .claude/commands/init-template.md
   ```
2. Then run the command in Claude Code:
   ```
   /project:init-template
   ```
3. The agent will:
   - Analyze your current structure
   - Add missing template files (CLAUDE.md, CI, etc.)
   - Preserve your existing code and configuration
   - Suggest improvements without overwriting your work

> **Why the extra step?** `/project:init-template` is a Claude Code custom command that must exist in your repo's `.claude/commands/` directory before Claude Code can discover it. Repos created from this template already have it.

**What gets added:**
- AI configuration files (if missing)
- CI/CD workflow (if missing or outdated)
- Issue/PR templates (if missing)
- Security policy (if missing)
- Security hardening script + pre-commit hooks

**What's preserved:**
- Your existing README (agent will suggest improvements)
- Your code and tests
- Your existing CI (agent will compare and recommend)

</details>

<details>
<summary><strong>▶ Workflow F: Fork + Personal Standards</strong></summary>

Best for: Contributing to others' projects with AI assistance

1. Fork the upstream repository
2. Add template files to your fork:
   - `CLAUDE.md` — Your personal AI instructions
   - Optionally: `.github/copilot-instructions.md`
3. **Important:** Add these to `.git/info/exclude` (not `.gitignore`) to avoid polluting upstream PRs:
   ```
   # .git/info/exclude
   CLAUDE.md
   .github/copilot-instructions.md
   ```

This gives you AI assistance without affecting the upstream project.

**Security for forks:** See [docs/FORK-SECURITY.md](docs/FORK-SECURITY.md) for upstream push blocking, fork network data leakage risks, and secure contribution workflows.

</details>

<details>
<summary><strong>▶ Workflow G: Create Organization Template</strong></summary>

Best for: Teams wanting consistent standards across repos

1. Fork or clone repo-template
2. Customize for your organization:
   - Add org-specific CI steps (internal registries, compliance checks)
   - Update SECURITY.md with your security contact
   - Add org branding to README template
   - Create additional slash commands for team workflows
3. Mark as a template repository in GitHub Settings
4. Team members use your org template instead of this one

</details>

<details>
<summary><strong>▶ Workflow H: Multi-Stack Projects</strong></summary>

Best for: Projects with multiple languages (e.g., Python backend + TypeScript frontend)

1. Use Workflow A or B to create the repository
2. In `.github/workflows/ci.yml`, uncomment multiple language sections
3. In `.github/dependabot.yml`, enable multiple ecosystems
4. In `CLAUDE.md`, document all stacks:
   ```markdown
   ## Commands

   ### Backend (Python)
   ```bash
   cd backend && pytest
   ```

   ### Frontend (TypeScript)
   ```bash
   cd frontend && npm test
   ```
   ```

</details>

<details>
<summary><strong>▶ Workflow I: Monorepo</strong></summary>

Best for: Multiple projects in a single repository

1. Apply template at repository root
2. Customize paths in CI and Dependabot:
   ```yaml
   # dependabot.yml
   - package-ecosystem: "npm"
     directory: "/packages/frontend"
   - package-ecosystem: "pip"
     directory: "/packages/backend"
   ```
3. In `CLAUDE.md`, document the monorepo structure and per-package commands

</details>

---

### Workflow Comparison

| Workflow | Starting Point | Best For | AI Required |
|----------|---------------|----------|-------------|
| A: GitHub Template | GitHub UI | Quick start | Recommended |
| B: Local-First | Empty directory | Pre-planned projects | Yes |
| C: Spin-off | Existing session | Breaking out components | Yes |
| D: Manual | Empty GitHub repo | Full control | No |
| E: Retrofit | Existing repo | Upgrading old projects | Recommended |
| F: Fork | Others' repos | Contributing with AI | No |
| G: Org Template | This template | Team standards | No |
| H: Multi-Stack | Any | Polyglot projects | No |
| I: Monorepo | Any | Multi-project repos | No |

---

## What's Next?

After setup, here are some things to try:

| Action | How |
|--------|-----|
| **Add your first feature** | Ask Claude: "Create a basic Express server in src/" |
| **Run CI locally** | `npm test` or your stack's test command |
| **Create an issue** | Try the bug report form — see how structured it is |
| **Enable security features** | Settings → Security → Enable secret scanning |

### First Week Checklist

- [ ] Add your source code to `src/`
- [ ] Write your first test in `tests/`
- [ ] Push a commit and watch CI run
- [ ] Invite collaborators (they'll see CONTRIBUTING.md)
- [ ] Enable GitHub security features (see [Security](#security))

---

## AI Agent Configuration

This template includes instruction files for multiple AI coding assistants:

| File | AI Tool | What It Contains |
|------|---------|------------------|
| `CLAUDE.md` | Claude Code | Project context, commands, code style, structure |
| `.github/copilot-instructions.md` | GitHub Copilot | Code generation guidelines, security rules |
| `AGENTS.md` | Codex, Gemini, Cursor, others | Cross-agent compatibility layer |

**Why this matters:** AI agents perform significantly better when they understand your project's conventions, tech stack, and workflows upfront. Instead of re-explaining your preferences each session, the agent reads these files automatically.

**Custom commands:** The `.claude/commands/` folder contains slash commands:

| Command | What It Does |
|---------|-------------|
| `/project:init-template` | Interactive project setup (Quick or Full mode) |
| `/project:security-audit` | Run security scorecard — checks GitHub settings, pre-commit hooks, forbidden tokens, commit signing. Outputs letter grade (A+ through D). |
| `/project:review` | Code review assistance |

**Proactive security:** All 6 AI agent configs instruct the agent to check if security hardening has been completed on first session. If pre-commit hooks or GitHub protections are missing, the agent will suggest running the setup commands once.

---

## CI/CD

The included workflow (`.github/workflows/ci.yml`) supports multiple languages. Uncomment the section for your stack:

| Stack | What It Runs |
|-------|--------------|
| **Node.js/TypeScript** | npm ci, lint, test, build |
| **Python** | pip install, pytest, ruff |
| **Go** | go build, go test, go vet |
| **Rust** | cargo build, cargo test, cargo clippy |

### Security Features

The CI workflow follows GitHub's security best practices:

- **Actions pinned to SHA** — Prevents supply chain attacks from compromised tags
- **Explicit permissions** — Least-privilege access, not default write-all
- **30-minute timeout** — Prevents runaway jobs from consuming resources
- **Concurrency controls** — Cancels outdated runs when new commits push

---

## Issue Management

This template includes a structured issue tracking system with labels, templates, and automation.

### Issue Templates

| Template | Auto-Labels | Use For |
|----------|-------------|---------|
| Agent Task | `owner:agent`, `task` | Work an AI agent can complete autonomously |
| Human Task | `owner:human`, `task` | ENV vars, accounts, credentials, DNS, decisions |
| External Blocker | `owner:external`, `status:blocked` | Waiting on a client, vendor, or third party |
| Bug Report | `bug` | Something is broken |
| Feature Request | `enhancement` | Suggest a new feature |

### Label Taxonomy

| Category | Labels | Purpose |
|----------|--------|---------|
| Status | `status:planning`, `in-progress`, `done`, `blocked` | Drives automation |
| Owner | `owner:human`, `agent`, `external` | Who does the work |
| Priority | `priority:high`, `medium`, `low` | Urgency |
| Type | `bug`, `enhancement`, `task`, `roadmap`, `idea`, etc. | Classification |

Run `scripts/labels.sh` to create all labels. Idempotent — safe to run multiple times.

### Helper Scripts

```bash
scripts/my-tasks.sh              # Your tasks + blocked issues
scripts/my-tasks.sh agent        # Agent-completable tasks
scripts/my-tasks.sh high         # High priority only
scripts/close-issue.sh 23 "Done" # Close with status:done + comment
```

### Project Board Sync (Optional)

The `sync-status.yml` workflow auto-syncs `status:*` labels to a GitHub Projects v2 board (and optionally Notion). Run `/project:init-template` to configure, or fill in the placeholder IDs manually.

---

## Customization Guide

<details>
<summary><strong>▶ Adding a New Language</strong></summary>

1. Uncomment the relevant section in `.github/workflows/ci.yml`
2. Uncomment the ecosystem in `.github/dependabot.yml`
3. Update `CLAUDE.md` with your specific commands
4. Add language-specific config files (package.json, pyproject.toml, etc.)

</details>

<details>
<summary><strong>▶ Setting Up Pre-commit Hooks</strong></summary>

See [CONTRIBUTING.md](CONTRIBUTING.md#pre-commit-hooks-optional) for instructions on setting up Husky and lint-staged.

</details>

<details>
<summary><strong>▶ Enabling GitHub Security Features</strong></summary>

**Automated (recommended):** Run the hardening script:

```bash
bash scripts/secure-repo.sh
```

This enables Dependabot alerts, automated security fixes, branch protection (block force-push/deletion), tag protection, and delete-branch-on-merge in one command.

**Manual:** In your repository Settings → Security:

1. Enable **Secret scanning** — Detects API keys in commits
2. Enable **Push protection** — Blocks pushes containing secrets
3. Enable **Dependabot alerts** — Notifies of vulnerable dependencies
4. Enable **Code scanning** — Finds vulnerabilities via CodeQL (public repos)

**Pre-commit hooks:** Install the secret scanning hook:

```bash
bash templates/hooks/setup-hooks.sh
```

Blocks commits containing API keys, private keys, credentials, and custom forbidden tokens. Chains safely with existing hooks (husky, lint-staged, etc.).

**Fork security:** See [docs/FORK-SECURITY.md](docs/FORK-SECURITY.md) for fork-specific security guidance (upstream push blocking, fork network data leakage, sync workflow).

</details>

<details>
<summary><strong>▶ Creating Custom Slash Commands</strong></summary>

Add Markdown files to `.claude/commands/`:

```markdown
# .claude/commands/my-command.md

Instructions for Claude when this command is invoked...
```

Then use with `/project:my-command` in Claude Code.

</details>

---

## FAQ

<details>
<summary><strong>▶ I don't use Node.js. Will this work for me?</strong></summary>

Yes. The template is language-agnostic. The CI workflow has commented sections for Python, Go, and Rust. Uncomment the one you need, or add your own. The directory structure (`src/`, `tests/`, etc.) works for any language.

</details>

<details>
<summary><strong>▶ Do I need to use Claude Code?</strong></summary>

No. The template works with any workflow. The AI configuration files (CLAUDE.md, AGENTS.md, copilot-instructions.md) are just text files — they won't affect anything if you don't use AI tools. But if you do use them, your agents will be more effective.

</details>

<details>
<summary><strong>▶ The CI workflow failed. What do I do?</strong></summary>

Common causes:
1. **No package.json/requirements.txt** — The workflow expects dependencies. Comment out the install step or add your dependency file.
2. **No test script** — Add a test script or comment out the test step.
3. **Wrong language section** — Make sure you uncommented the right section.

Check the Actions tab for specific error messages.

</details>

<details>
<summary><strong>▶ How do I update after the template improves?</strong></summary>

Repositories created from templates don't auto-update. To get improvements:
1. Check the [template repo](https://github.com/vbonk/repo-template) for changes
2. Manually copy relevant updates to your project
3. Or use the template again for new projects

</details>

<details>
<summary><strong>▶ I used "Use this template" but also have local customizations. What now?</strong></summary>

If you created a repo via GitHub's template button but also have locally customized files (e.g., from a previous session), you have divergent git histories. Options:

1. **Force push local work** (recommended if local is more complete):
   ```bash
   git push --force origin main
   ```
   This replaces the template files with your customized version.

2. **Discard local and customize template**:
   Clone the GitHub repo and run `/project:init-template` to customize interactively (this command is already included in repos created from the template).

**To avoid this:** Use Workflow B (Local-First) when you have pre-planned customizations, or use Workflow A (GitHub Template) and customize afterward — don't mix both.

</details>

<details>
<summary><strong>▶ Can I add template standards to someone else's repo I forked?</strong></summary>

Yes! See Workflow F. Add your AI configuration files (CLAUDE.md, etc.) and exclude them from git tracking using `.git/info/exclude` so they don't pollute PRs to the upstream project.

</details>

---

<details>
<summary><strong>▶ AI Security</strong></summary>

This template includes prompt injection defenses — a first for GitHub templates:

- **CODEOWNERS** protects AI config files (CLAUDE.md, AGENTS.md, .cursorrules, etc.) — changes require owner review
- **PR body scanner** (opt-in workflow) detects common injection patterns in issue/PR text
- **Hook templates** validate inputs before AI agents process them
- **Documentation** in [docs/AI-SECURITY.md](docs/AI-SECURITY.md) covers attack vectors and best practices

See [docs/AI-SECURITY.md](docs/AI-SECURITY.md) for the full threat model.

</details>

---

## Show Your Support

If you created your repo with this template, add this badge to your README:

```markdown
[![Built with repo-template](https://img.shields.io/badge/Built%20with-repo--template-blue?style=flat-square)](https://github.com/vbonk/repo-template)
```

[![Built with repo-template](https://img.shields.io/badge/Built%20with-repo--template-blue?style=flat-square)](https://github.com/vbonk/repo-template)

---

## Contributing

Contributions to improve this template are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md).

**Ideas for contributions:**
- Language-specific add-on configs
- Additional CI/CD patterns
- Improved documentation
- New custom slash commands

---

## Security

See [SECURITY.md](SECURITY.md) for:
- How to report vulnerabilities
- Security features included in this template
- Recommended GitHub security settings

---

## License

[MIT](LICENSE) — Use freely, attribution appreciated.

---

## Acknowledgments

This template incorporates best practices from:
- [Anthropic's Claude Code documentation](https://www.anthropic.com/engineering/claude-code-best-practices)
- [GitHub Actions security best practices](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- Community feedback and real-world usage

---

<p align="center">
  <sub>Built for developers who'd rather write code than configure repos.</sub>
</p>
