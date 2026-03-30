# Documentation

> Navigation hub for all project documentation. Start here to find what you need.

---

## Docs Reference

| Document | Description | Key Topics |
|----------|-------------|------------|
| [GETTING-STARTED.md](GETTING-STARTED.md) | Setup guide from zero to production-grade | Security, AI agents, workflow protection, automation |
| [DOCUMENTATION-GUIDE.md](DOCUMENTATION-GUIDE.md) | Pattern library for professional documentation | README structure, Mermaid diagrams, callouts, progressive disclosure |
| [ARCHITECTURE.md](ARCHITECTURE.md) | System design and technical decisions | Components, data flow, technology choices, ADRs |
| [AI-SECURITY.md](AI-SECURITY.md) | Prompt injection threat model and defenses | 6-layer defense, attack vectors, protected files, hook templates |
| [BRANCH-PROTECTION.md](BRANCH-PROTECTION.md) | Branch protection setup with `gh` CLI scripts | PR reviews, status checks, signed commits, tag protection |
| [FORK-SECURITY.md](FORK-SECURITY.md) | Secure fork workflows and data leakage risks | Fork network, upstream push blocking, secret rotation |
| [GITHUB-ENVIRONMENTS.md](GITHUB-ENVIRONMENTS.md) | Deployment environments and approval gates | Secret scoping, staging/production pipeline, wait timers |
| [PROD_CHECKLIST.md](PROD_CHECKLIST.md) | Production readiness checklist | Security, performance, monitoring, infrastructure, legal compliance |
| [decisions/](decisions/) | Architecture Decision Records (ADRs) | Individual design decisions with context and rationale |

## Root-Level Docs

| Document | Description | Key Topics |
|----------|-------------|------------|
| [README.md](../README.md) | Project overview and quick start | Setup, features, usage |
| [CONTRIBUTING.md](../CONTRIBUTING.md) | Contribution guidelines | PR process, code style, testing |
| [SECURITY.md](../SECURITY.md) | Security policy and vulnerability reporting | Incident response, responsible disclosure |
| [CODE_OF_CONDUCT.md](../CODE_OF_CONDUCT.md) | Community standards | Expected behavior, enforcement |
| [GOVERNANCE.md](../GOVERNANCE.md) | Project governance | Decision-making, roles, maintainership |
| [SUPPORT.md](../SUPPORT.md) | How to get help | Issue templates, discussion channels |
| [CHANGELOG.md](../CHANGELOG.md) | Version history | Releases, breaking changes |

## AI Agent Configuration

| File | Agent | Purpose |
|------|-------|---------|
| [CLAUDE.md](../CLAUDE.md) | Claude Code | Primary agent instructions and project context |
| [AGENTS.md](../AGENTS.md) | Cross-agent (Codex, Cursor, etc.) | Shared rules for all AI agents |
| [GEMINI.md](../GEMINI.md) | Google Gemini CLI | Gemini-specific configuration |
| [.cursorrules](../.cursorrules) | Cursor IDE | Cursor agent behavior rules |
| [.windsurfrules](../.windsurfrules) | Windsurf / Codeium | Windsurf agent behavior rules |
| [copilot-instructions.md](../.github/copilot-instructions.md) | GitHub Copilot | Copilot custom instructions |
