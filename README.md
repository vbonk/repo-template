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
- **⚡ Zero Config** — Works immediately, customize as needed
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

Click **[Use this template](https://github.com/vbonk/repo-template/generate)** → Create a new repo

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

---

## AI Agent Configuration

This template includes instruction files for multiple AI coding assistants:

| File | AI Tool | Purpose |
|------|---------|---------|
| `CLAUDE.md` | Claude Code | Project context, commands, conventions |
| `.github/copilot-instructions.md` | GitHub Copilot | Code generation guidelines |
| `AGENTS.md` | Codex, Gemini, others | Cross-agent compatibility |

**Why this matters:** AI agents perform better when they understand your project's conventions, tech stack, and workflows upfront.

---

## CI/CD

The included workflow (`.github/workflows/ci.yml`) supports multiple languages. Uncomment the section for your stack:

- **Node.js/TypeScript** — npm install, lint, test, build
- **Python** — pip install, pytest, ruff
- **Go** — go build, go test
- **Rust** — cargo build, cargo test

**Security features:**
- Actions pinned to SHA (not tags)
- Explicit least-privilege permissions
- 30-minute timeout
- Concurrency controls

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

1. Enable **Secret scanning**
2. Enable **Push protection**
3. Enable **Dependabot alerts**
4. Enable **Code scanning** (for public repos)

</details>

---

## Contributing

Contributions to improve this template are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md).

**Ideas for contributions:**
- Language-specific add-on configs
- Additional CI/CD patterns
- Improved documentation

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
