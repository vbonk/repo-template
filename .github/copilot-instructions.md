# GitHub Copilot Instructions

> Instructions for GitHub Copilot when working in this repository.

## Project Context

This is a template repository optimized for AI-assisted development. When generating code:

## Code Style

- Follow existing patterns in the codebase
- Use clear, descriptive variable and function names
- Prefer explicit over implicit
- Keep functions small and focused

## Security Requirements

- Never generate hardcoded secrets, API keys, or passwords
- Use environment variables for sensitive configuration
- Validate all user inputs
- Escape outputs appropriately (HTML, SQL, shell)

## Testing

- Generate tests alongside new functionality
- Follow existing test patterns in `tests/` directory
- Aim for meaningful test coverage, not just line coverage

## Documentation

- Add JSDoc/docstrings for public APIs
- Update README if adding new features
- Keep comments focused on "why", not "what"

## Commit Messages

Use conventional commit format:
- `feat:` new features
- `fix:` bug fixes
- `docs:` documentation changes
- `test:` test additions/changes
- `refactor:` code refactoring
- `chore:` maintenance tasks

## Language-Specific Notes

Adapt to the project's tech stack:
- **JavaScript/TypeScript**: ESM imports, async/await, TypeScript strict mode
- **Python**: Type hints, f-strings, pathlib for paths
- **Go**: Effective Go conventions, error handling patterns
