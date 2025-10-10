# CLAUDE.md

This file provides guidance to GitHub Copilot when working with code in this repository.

## Project Overview

**Project Name:** [Replace with actual project name]

Brief description of the project and its purpose.

## Tech Stack

- [List languages, frameworks, etc.]

## Development Workflow

As a solo developer repository:

1. **Code Review:** Use Copilot Chat for triage and remediation before commits.
   - Ask: "Review this function for bugs/security issues."
   - Ask: "Suggest improvements to this code."

2. **Commits:** Write clear commit messages. Use Copilot to draft them.

3. **CI/CD:** Actions will run linting, tests, and builds on pushes. No PR reviews required.

## Common Commands

```bash
# Development
npm run dev          # Start dev server
npm run build        # Build project
npm test             # Run tests
npm run lint         # Lint code

# Git
git add .
git commit -m "feat: add new feature"  # Use Copilot to help write messages
git push origin main
```

## Best Practices

- Use Copilot for code suggestions and debugging.
- Keep commits atomic and well-described.
- Run local tests before pushing.
- Use Copilot to explain complex code or APIs.

## Recent Updates

- [Add recent changes here]