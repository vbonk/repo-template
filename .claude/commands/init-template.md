# Initialize Template

Customize this repository template for your project.

## Instructions

Guide the user through template customization interactively.

### 1. Gather Project Information

Ask for:
- **Project name** (e.g., "my-awesome-app")
- **One-line description**
- **Tech stack** (e.g., "TypeScript, Node.js, PostgreSQL")
- **Primary language**: Node.js/TypeScript, Python, Go, Rust, or other
- **Security contact email**

### 2. Update Files

| File | Changes |
|------|---------|
| `README.md` | Title, description, update badges with correct repo |
| `CLAUDE.md` | Project name, tech stack, commands |
| `AGENTS.md` | Mirror CLAUDE.md changes |
| `.github/workflows/ci.yml` | Uncomment relevant language section |
| `.github/dependabot.yml` | Uncomment relevant ecosystem |
| `SECURITY.md` | Add security contact email |

### 3. Language-Specific Setup

Offer to create starter configs:

**Node.js/TypeScript:**
```json
// package.json with dev, build, test, lint scripts
// tsconfig.json if TypeScript
```

**Python:**
```toml
# pyproject.toml with pytest, ruff
```

**Go:**
```go
// go.mod with module path
```

**Rust:**
```toml
# Cargo.toml with project name
```

### 4. Cleanup

- Remove addressed `<!-- TODO -->` comments
- Offer initial commit: `chore: Initialize project from template`

### 5. Summary

Report what was changed and suggest:
- Add code to `src/`
- Write tests in `tests/`
- Enable GitHub security features in Settings
