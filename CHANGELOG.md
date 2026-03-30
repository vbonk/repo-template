# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

-

### Changed

-

### Fixed

-

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
- **Compliance audit**: `audits/compliance-checklist.md` with verification of all security and governance controls
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
