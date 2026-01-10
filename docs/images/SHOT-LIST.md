# Screenshot Shot List

Recommended screenshots for README and article. Capture these manually and save to this directory.

## Required Screenshots

### 1. `template-button.png`
**What:** The "Use this template" button on GitHub
**Where:** Top of the repo-template repository page
**Why:** Shows how easy it is to get started
**Dimensions:** ~800x200px crop

### 2. `issue-template-form.png`
**What:** The bug report YAML form in action
**Where:** Create new issue → Select "Bug Report"
**Why:** Demonstrates structured issue templates
**Dimensions:** ~800x600px

### 3. `ci-workflow-running.png`
**What:** GitHub Actions workflow executing
**Where:** Actions tab → Click on a workflow run
**Why:** Shows CI is real and working
**Dimensions:** ~800x400px

### 4. `repo-structure-github.png`
**What:** The repository file tree on GitHub
**Where:** Main repo page, file browser
**Why:** Visual alternative to ASCII diagram
**Dimensions:** ~400x600px

### 5. `claude-reading-project.png` (for article)
**What:** Claude Code showing it understands the project
**Where:** Claude Code CLI after opening the repo
**Why:** Proves AI-first design works
**Dimensions:** ~800x400px

## Optional Screenshots

### 6. `dependabot-pr.png`
**What:** A Dependabot pull request
**Where:** Pull requests tab
**Why:** Shows automatic dependency updates

### 7. `security-settings.png`
**What:** GitHub security settings page
**Where:** Settings → Security
**Why:** Guide for enabling features

### 8. `pr-template-filled.png`
**What:** PR template with checkboxes
**Where:** Create a new PR
**Why:** Shows structured PR process

## Capture Tips

1. Use browser at 100% zoom
2. Light mode preferred (better for articles)
3. Crop tightly around the relevant area
4. Save as PNG for quality
5. Consider adding subtle highlights/arrows in post

## File Naming Convention

```
docs/images/
├── template-button.png
├── issue-template-form.png
├── ci-workflow-running.png
├── repo-structure-github.png
├── claude-reading-project.png
├── dependabot-pr.png
├── security-settings.png
└── pr-template-filled.png
```

## Usage in README

```markdown
![Issue Template Form](docs/images/issue-template-form.png)
```

Or with sizing:
```html
<img src="docs/images/issue-template-form.png" alt="Issue Template Form" width="600">
```
