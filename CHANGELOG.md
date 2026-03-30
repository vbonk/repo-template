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

[unreleased]: ../../compare/v1.0.0...HEAD
[1.0.0]: ../../releases/tag/v1.0.0
