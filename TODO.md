# TODO

## Current Workflow Support Status

| Workflow | Status | Notes |
|----------|--------|-------|
| A: GitHub Template | Supported | README documents this path |
| B: Local-First | Supported | Added to README workflows section |
| C: Spin-off | Partial | Needs init-template enhancements |
| D: Empty GitHub + Manual | Supported | Documented in README |
| E: Retrofit Existing | Partial | Needs dedicated guide and command |
| F: Fork + Standards | Documented | FAQ added to README |
| G: Org Template | Documented | Guidance in README |
| H: Multi-Stack | Partial | CI examples needed |
| I: Monorepo | Partial | Dedicated guide needed |

---

## Immediate Documentation Updates

### High Priority

- [ ] Create `docs/WORKFLOWS.md` - Decision tree for all 9 scenarios
- [ ] Create `docs/RETROFIT-GUIDE.md` - Step-by-step for upgrading existing repos
- [ ] Create `.claude/commands/retrofit.md` - Command for retrofitting existing repos
- [ ] Update `AGENTS.md` with workflow-specific sections
- [ ] Update `init-template.md` with conditional logic for existing repos

### Medium Priority

- [ ] Create `docs/MONOREPO-SETUP.md` - CI and Dependabot patterns for monorepos
- [ ] Create `docs/MULTI-STACK.md` - Configuring for multiple languages
- [ ] Create `docs/TEAM-ROLLOUT.md` - Batch adoption strategies
- [ ] Add Rust section to `.github/workflows/ci.yml`
- [ ] Update `CLAUDE.md` with workflow context

### Low Priority

- [ ] Create `docs/CREATE-VARIANT.md` - Creating organization-specific templates
- [ ] Create `docs/LANGUAGE-CONFIGS/` directory with per-language guides
- [ ] Update `CONTRIBUTING.md` with workflow testing requirements
- [ ] Expand `.claude/commands/review.md` with examples

---

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
- Prerequisite: Complete the "Immediate Documentation Updates" above first
