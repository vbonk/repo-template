# TODO

## Global Skill: Repository Manager

Create a global Claude Code skill that can be invoked from any location on the dev machine to manage repositories using repo-template standards.

### Commands

#### 1. Create New Repository (`/repo:create`)
- Interactive prompts using `askUserQuestion` to gather:
  - Repository name and description
  - Target tech stack (Python, Node.js, Go, Rust, etc.)
  - Project objectives and use cases
  - Visibility (public/private)
  - Additional features needed (CI/CD, docs, etc.)
- Generate optimized repository structure based on user objectives
- Auto-configure CLAUDE.md, AGENTS.md, and CI/CD for the selected stack
- Create repository on GitHub and push initial commit

#### 2. Audit Existing Repository (`/repo:audit`)
- Scan user's GitHub account (public and private repositories)
- List repositories with metadata (last updated, language, size)
- Let user select a repository to audit
- Analyze against repo-template best practices:
  - AI agent configuration files present?
  - CI/CD configured with security best practices?
  - Dependabot enabled?
  - Issue/PR templates present?
  - Security policy defined?
- Generate actionable recommendations report

#### 3. Update Existing Repository (`/repo:update`)
- Intelligent guided update to latest repo-template standards
- Diff current repo against template
- Interactive selection of updates to apply
- Preserve existing customizations while adding new features
- Options:
  - Add missing AI configuration files
  - Update CI/CD to latest secure patterns
  - Add/update issue and PR templates
  - Configure Dependabot
  - Add security policy

### Implementation Notes

- Global skill location: `~/.claude/commands/` or similar
- Requires GitHub CLI (`gh`) for repository operations
- Should work across different project types and languages
- Maintain backwards compatibility when updating existing repos
