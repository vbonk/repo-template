# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- **Six bundled Claude Code skills** (2026-04, migrated to loadable form 2026-08): `cot`, `hibernate`, `repo-docs`, `skill-builder`, `skill-validator`, `task-cleanup` — auto-discovered project capabilities, now documented in README and Getting Started
- `--audit` mode for `secure-repo.sh` — genuinely read-only security scorecard; `/project:security-audit` uses it
- Tag ruleset protecting `v*` releases (replaces the tag-protection API GitHub removed in Aug 2024)
- Required status checks on `main` — direct pushes are now rejected; all changes arrive by PR with passing CI
- `scripts/_lib.sh` — shared capability detection library (require_gh, check_gh_auth, check_gh_repo, has_gh)
- `--local-only` flag for `test-template.sh`; `--dry-run` for `labels.sh`
- Skills layout design-check, functional labels.sh check, and fenced-code-aware link checker in the self-test suite

### Changed

- **Skills migrated from flat `.md` files to `<name>/SKILL.md` directories** — the flat layout was silently ignored by Claude Code (runtime-verified); this is the layout that actually loads
- CODEOWNERS ships with security-critical rules ACTIVE (init-template substitutes your handle)
- update-contributors lands via auto-merged PR instead of pushing to main
- Dependabot auto-merge refuses to arm unless required status checks and repo auto-merge are enabled
- detect-conflicts runs on push/schedule (one PR's checks no longer depend on unrelated PRs)
- Release flow publishes only AFTER cosign signing and SBOM generation complete
- Security docs (AI-SECURITY, BRANCH-PROTECTION, README) claim exactly what is enforced — no more aspirational protection claims
- All scripts use shared `_lib.sh`; ShellCheck `-x --severity=warning`

### Fixed

- `.gitignore` inline comments silently disabled most patterns (including `*.pem`, `*.key`, `credentials.json`)
- `labels.sh` could not run at all (unbound `$1`, broken `--repo` passing); now creates `needs-rebase`/`stale` labels workflows depend on
- Secret scanner republished matched secret content into PR comments — now reports file:line references only
- Pre-commit hook missed single-quoted secrets on macOS (BSD grep `\x27`); 2026 token formats added (fine-grained PATs, Slack, GCP, npm, JWT, Stripe — fixing a Stripe pattern that could never match)
- Compliance audit awarded hardcoded credit for unverified checks; SHA-pin check passed with unpinned actions present
- YAML validation counted a missing PyYAML as "all files invalid"; now fails explicitly as validator-unavailable
- `setup-hooks.sh` printed a self-test command git rejects (`git add /tmp/...`)
- Ruleset scoped to all branches blocked Dependabot rebases for months; scoped to default branch
- Drift check reported zero drift when it couldn't reach the template (now fails closed as inconclusive)

### Removed

- **Support narrowed to Claude Code (primary) and Codex** — removed `GEMINI.md`, `.cursorrules`, `.windsurfrules`, `.aider.conf.yml`, and `.github/copilot-instructions.md`, plus every reference across docs, tests, workflows, and scoring. Rationale: five shallow config stubs were a sync chore that went stale; two files kept genuinely excellent (`CLAUDE.md` + the open `AGENTS.md` standard) serve the supported agents far better — and a self-test gate now fails CI if a removed-agent reference ever resurfaces
- `plan.md` (stale maintainer planning doc; superseded by private maintainer docs)

### Security

- Branch protection reality: required checks live, admin bypass requires PR, tag rulesets active — see docs/BRANCH-PROTECTION.md for the honest out-of-box vs opt-in matrix

## [1.1.0] - 2026-03-30

### Added

- **Claude Code skills + agents directories**: `.claude/skills/` and `.claude/agents/` with README guides and working examples
- **Getting Started guide**: `docs/GETTING-STARTED.md` — 10-minute onboarding with 4 Mermaid diagrams
- **Documentation patterns guide**: `docs/DOCUMENTATION-GUIDE.md` — pattern library for template documentation
- **Production checklist**: `docs/PROD_CHECKLIST.md` — 41-item checklist across 6 categories
- **Sigstore release signing**: Keyless cosign signatures on release assets via GitHub OIDC
- **SBOM generation**: CycloneDX SBOM auto-generated and uploaded as release asset
- **Commitlint config template**: `templates/linting/commitlint.config.js.template` for conventional commits
- **Merge conflict detection workflow**: Auto-labels PRs with `needs-rebase` when conflicts detected
- **Contributor tracking**: `CONTRIBUTORS.md` auto-generated from git history via workflow
- **Inline documentation enrichment**: All config files annotated with "Why" explanations
- **Claude Code commands**: `/project:getting-started` and `/project:update-docs`
- **Compliance audit enhancements**: 6 new features tracked (detect-conflicts, update-contributors, contributors-md, sbom-release, skills-dir, agents-dir)

### Changed

- Workflow count: 16 → 18
- Test suite: 86 → 89 checks (all passing)
- E2E suite: 18 checks (17 pass, 1 warn)
- Pre-commit hook exclusions broadened for config files with legitimate secret pattern references

## [1.0.0] - 2026-03-29

### Added

- **AI agent configuration layer**: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, and `.github/copilot-instructions.md` for multi-agent support
- **Security hardening**: pre-commit hooks, `scripts/secure-repo.sh` scorecard, CODEOWNERS protection for sensitive files
- **AI threat model**: `docs/AI-SECURITY.md` with prompt injection defense, data exfiltration prevention, and agent boundary rules
- **Fork security guide**: `docs/FORK-SECURITY.md` for safely consuming upstream changes
- **Compliance audit**: `audits/repo-compliance.json` with verification of all security and governance controls
- **Pre-commit hooks template**: `templates/hooks/setup-hooks.sh` with secret detection and branch protection
- **Task management scripts**: `scripts/my-tasks.sh`, `scripts/close-issue.sh`, `scripts/labels.sh` for GitHub Issues workflow
- **Architecture documentation**: `docs/ARCHITECTURE.md` template with Mermaid diagrams and ADR tracking
- **GitHub workflows**: CI pipeline, Dependabot, issue templates, and branch protection guidance (`docs/BRANCH-PROTECTION.md`)
- **Devcontainer support**: `.devcontainer/` configuration for GitHub Codespaces
- **Governance and community files**: `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `GOVERNANCE.md`, `SUPPORT.md`, `SECURITY.md`

### Changed

- Enhanced all markdown documentation with GitHub-flavored callouts, Mermaid diagrams, and visual hierarchy

[unreleased]: ../../compare/v1.1.0...HEAD
[1.1.0]: ../../compare/v1.0.0...v1.1.0
[1.0.0]: ../../releases/tag/v1.0.0
