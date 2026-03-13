# CLAUDE.md

> Instructions for Claude Code when working in this repository.

## Quick Start

**New repo from template?** Run `/project:init-template` to customize interactively.

## Project

**Name:** <!-- TODO: Replace with project name -->
**Stack:** <!-- TODO: e.g., TypeScript, Node.js, React -->

## Commands

```bash
npm run dev       # Start dev server
npm run build     # Production build
npm test          # Run tests
npm run lint      # Lint code
```

> Adapt to your stack: Python (pytest, ruff), Go (go test), etc.

## Code Style

- Follow existing patterns in the codebase
- Keep functions small and focused
- Prefer explicit over implicit

## Workflow

- Run tests before committing
- Use conventional commits (feat:, fix:, docs:, etc.)
- CI runs automatically on push

## Project Structure

```
src/      # Source code
tests/    # Test files
docs/     # Documentation
scripts/  # Automation
```

## Security

- Never commit secrets or credentials
- Use environment variables for config
- See SECURITY.md for reporting vulnerabilities

## Task Management

GitHub Issues is the task tracker. Use `status:*` labels as the source of truth.

```bash
scripts/my-tasks.sh           # Your tasks + blocked issues
scripts/my-tasks.sh agent     # Agent-completable tasks
scripts/my-tasks.sh high      # High priority
scripts/close-issue.sh 23 "Fixed in commit abc123"  # Close with comment
scripts/labels.sh             # Create/update labels (idempotent)
```

## Custom Commands

- `/project:init-template` — Initialize this template for your project
- `/project:review` — Code review assistance
