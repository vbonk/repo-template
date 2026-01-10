# AGENTS.md

> Cross-agent instructions for AI coding assistants.
> This file is recognized by multiple AI tools including Claude Code, Cursor, and others.

## Template Initialization

**New repo from template?** Help the user customize by:
1. Asking for project name, description, and tech stack
2. Updating CLAUDE.md, AGENTS.md, README.md with their answers
3. Uncommenting the relevant language section in `.github/workflows/ci.yml`
4. Uncommenting the relevant ecosystem in `.github/dependabot.yml`
5. Adding security contact to SECURITY.md

See `.claude/commands/init-template.md` for detailed steps.

## Project Overview

**Project Name:** <!-- TODO: Replace with project name -->

<!-- TODO: Brief description of the project -->

## Repository Structure

```
├── src/           # Source code
├── tests/         # Test files
├── docs/          # Documentation
├── scripts/       # Automation scripts
└── .github/       # GitHub configuration (workflows, templates)
```

## Commands

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server |
| `npm run build` | Production build |
| `npm test` | Run tests |
| `npm run lint` | Lint and format code |

> Adapt commands to your tech stack (Python: pytest, pip; Go: go test, go build; etc.)

## Code Conventions

- Write clear, self-documenting code
- Follow existing patterns in the codebase
- Include tests for new functionality
- Keep functions focused and small

## Workflow

1. Make changes in feature branches
2. Run tests locally before pushing
3. CI will run automatically on push
4. Keep commits atomic and well-described

## Security

- Never commit secrets, API keys, or credentials
- Use environment variables for sensitive configuration
- See SECURITY.md for vulnerability reporting

## Additional Context

For tool-specific instructions:
- **Claude Code**: See `CLAUDE.md`
- **GitHub Copilot**: See `.github/copilot-instructions.md`
