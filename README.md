# repo-template

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![AI-Optimized](https://img.shields.io/badge/AI--Optimized-Claude%20%7C%20Copilot%20%7C%20Codex-blue)](https://github.com/vbonk/repo-template)
[![GitHub last commit](https://img.shields.io/github/last-commit/vbonk/repo-template)](https://github.com/vbonk/repo-template/commits)

**A GitHub repository template optimized for AI-assisted development.**

Stop wasting time on boilerplate. Start every project with security best practices, CI/CD, and AI agent configurations already in place.

<p align="center">
  <a href="https://github.com/vbonk/repo-template/generate">
    <img src="https://img.shields.io/badge/Use%20This%20Template-238636?style=for-the-badge&logo=github&logoColor=white" alt="Use this template">
  </a>
</p>

---

<details>
<summary><strong>Table of Contents</strong></summary>

- [Who Is This For?](#who-is-this-for)
- [Why This Template?](#why-this-template)
- [Features](#features)
- [What's Included](#whats-included)
- [Quick Start](#quick-start)
- [What's Next?](#whats-next)
- [AI Agent Configuration](#ai-agent-configuration)
- [CI/CD](#cicd)
- [Customization Guide](#customization-guide)
- [FAQ](#faq)
- [Contributing](#contributing)
- [Security](#security)
- [License](#license)

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

- **🤖 AI-Agent Ready** — Pre-configured for Claude Code, GitHub Copilot, and Codex
- **🔒 Secure by Default** — Secrets protection, SHA-pinned Actions, Dependabot
- **⚡ Minimal Setup** — Works immediately, customize in minutes
- **📝 Template-Friendly** — Clear TODOs, easy find-and-replace
- **🔄 CI/CD Included** — GitHub Actions workflow ready to uncomment
- **📋 Issue Templates** — Structured YAML forms for bugs and features

---

## What's Included

```
┌─────────────────────────────────────────────────────────────┐
│  repo-template                                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  📁 .github/                                                │
│     ├── workflows/ci.yml      → CI pipeline (multi-stack)  │
│     ├── ISSUE_TEMPLATE/       → Bug & feature forms        │
│     ├── PULL_REQUEST_TEMPLATE → PR checklist               │
│     ├── dependabot.yml        → Dependency updates         │
│     └── copilot-instructions  → GitHub Copilot config      │
│                                                             │
│  📁 .claude/                                                │
│     └── commands/             → Custom slash commands       │
│                                                             │
│  📁 src/                      → Your source code            │
│  📁 tests/                    → Your tests                  │
│  📁 docs/                     → Documentation               │
│  📁 scripts/                  → Automation scripts          │
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

## Quick Start

### 1. Create Your Repository

Click **[Use this template](https://github.com/vbonk/repo-template/generate)** → Name your repo → Create

### 2. Clone and Open

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO
```

### 3. Customize (2 options)

**Option A: AI-Assisted (recommended)**

Open with Claude Code and run:
```
/project:init-template
```
The AI will ask for your project details and update all files automatically.

**Option B: Manual**

Find and update `TODO` comments:
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

### 4. Start Building

Your AI coding assistant now understands your project structure and conventions from the first prompt.

```mermaid
flowchart LR
    A[🎯 Use Template] --> B[📥 Clone Repo]
    B --> C[🤖 Run /init-template]
    C --> D[💬 Answer Questions]
    D --> E[✨ Files Auto-Updated]
    E --> F[🚀 Start Coding]

    style A fill:#238636,color:#fff
    style F fill:#238636,color:#fff
```

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

**Custom commands:** The `.claude/commands/` folder contains slash commands like `/project:init-template`. You can add your own for repetitive tasks.

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

## Customization Guide

<details>
<summary><strong>Adding a New Language</strong></summary>

1. Uncomment the relevant section in `.github/workflows/ci.yml`
2. Uncomment the ecosystem in `.github/dependabot.yml`
3. Update `CLAUDE.md` with your specific commands
4. Add language-specific config files (package.json, pyproject.toml, etc.)

</details>

<details>
<summary><strong>Setting Up Pre-commit Hooks</strong></summary>

See [CONTRIBUTING.md](CONTRIBUTING.md#pre-commit-hooks-optional) for instructions on setting up Husky and lint-staged.

</details>

<details>
<summary><strong>Enabling GitHub Security Features</strong></summary>

In your repository Settings → Security:

1. Enable **Secret scanning** — Detects API keys in commits
2. Enable **Push protection** — Blocks pushes containing secrets
3. Enable **Dependabot alerts** — Notifies of vulnerable dependencies
4. Enable **Code scanning** — Finds vulnerabilities via CodeQL (public repos)

</details>

<details>
<summary><strong>Creating Custom Slash Commands</strong></summary>

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
<summary><strong>I don't use Node.js. Will this work for me?</strong></summary>

Yes. The template is language-agnostic. The CI workflow has commented sections for Python, Go, and Rust. Uncomment the one you need, or add your own. The directory structure (`src/`, `tests/`, etc.) works for any language.

</details>

<details>
<summary><strong>Do I need to use Claude Code?</strong></summary>

No. The template works with any workflow. The AI configuration files (CLAUDE.md, AGENTS.md, copilot-instructions.md) are just text files — they won't affect anything if you don't use AI tools. But if you do use them, your agents will be more effective.

</details>

<details>
<summary><strong>The CI workflow failed. What do I do?</strong></summary>

Common causes:
1. **No package.json/requirements.txt** — The workflow expects dependencies. Comment out the install step or add your dependency file.
2. **No test script** — Add a test script or comment out the test step.
3. **Wrong language section** — Make sure you uncommented the right section.

Check the Actions tab for specific error messages.

</details>

<details>
<summary><strong>How do I update after the template improves?</strong></summary>

Repositories created from templates don't auto-update. To get improvements:
1. Check the [template repo](https://github.com/vbonk/repo-template) for changes
2. Manually copy relevant updates to your project
3. Or use the template again for new projects

</details>

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
