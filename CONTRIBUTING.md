# Contributing

Thank you for your interest in contributing!

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a feature branch: `git checkout -b feature/your-feature`
4. Make your changes
5. Push to your fork
6. Open a Pull Request

## Development Workflow

### Setting Up

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/REPO_NAME.git
cd REPO_NAME

# Install dependencies (adapt to your stack)
npm install        # Node.js
pip install -r requirements.txt  # Python
go mod download    # Go
```

### Making Changes

1. Write clear, focused commits
2. Follow existing code patterns
3. Add tests for new functionality
4. Update documentation as needed

### Running Tests

```bash
# Adapt to your stack
npm test           # Node.js
pytest             # Python
go test ./...      # Go
```

### Commit Messages

We use [Conventional Commits](https://www.conventionalcommits.org/):

| Prefix | Purpose |
|--------|---------|
| `feat:` | New feature |
| `fix:` | Bug fix |
| `docs:` | Documentation changes |
| `test:` | Adding/updating tests |
| `refactor:` | Code refactoring |
| `chore:` | Maintenance tasks |

Example: `feat: add user authentication`

## Code Style

- Follow existing patterns in the codebase
- Keep functions small and focused
- Write self-documenting code
- Add comments for complex logic only

## Pre-commit Hooks (Optional)

For JavaScript/TypeScript projects, you can set up pre-commit hooks:

```bash
# Install husky and lint-staged
npm install -D husky lint-staged

# Initialize husky
npx husky init

# Add pre-commit hook
echo "npx lint-staged" > .husky/pre-commit
```

Create `.lintstagedrc.json`:

```json
{
  "*.{js,ts,jsx,tsx}": ["eslint --fix", "prettier --write"],
  "*.{json,md,yml}": ["prettier --write"]
}
```

For Python projects:

```bash
# Install pre-commit
pip install pre-commit

# Create .pre-commit-config.yaml and run
pre-commit install
```

## Pull Requests

- Fill out the PR template completely
- Reference related issues
- Keep PRs focused and reasonably sized
- Ensure CI passes before requesting review

## Questions?

Open an issue if you have questions or need help.
