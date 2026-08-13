# Documentation

> Navigation hub for `repo-template` documentation. Fresh template-derived repositories begin with Phase 0; existing projects use Template Upgrade when reconciling a newer baseline.

**Last Updated:** 2026-08-13

## Start Here

| Document | Purpose |
|---|---|
| [PHASE-0.md](PHASE-0.md) | Canonical first-agent normalization and project-intake SOP for fresh template-derived repositories |
| [TEMPLATE-UPGRADE.md](TEMPLATE-UPGRADE.md) | Semantic reconciliation for existing repositories derived from older template baselines |
| [GETTING-STARTED.md](GETTING-STARTED.md) | Short agent-first usage guide |
| [AI-SECURITY.md](AI-SECURITY.md) | Prompt-injection threat model and agent security boundaries |
| [DOCUMENTATION-GUIDE.md](DOCUMENTATION-GUIDE.md) | Documentation quality standard and pattern library |

## Security and Operations

| Document | Purpose |
|---|---|
| [BRANCH-PROTECTION.md](BRANCH-PROTECTION.md) | Branch/ruleset protection and repository hardening |
| [FORK-SECURITY.md](FORK-SECURITY.md) | Secure fork workflows and data-leakage considerations |
| [GITHUB-ENVIRONMENTS.md](GITHUB-ENVIRONMENTS.md) | Deployment environments and approval gates |
| [PROD_CHECKLIST.md](PROD_CHECKLIST.md) | Production-readiness checklist |

## Architecture and Decisions

| Document | Purpose |
|---|---|
| [ARCHITECTURE.md](ARCHITECTURE.md) | Architecture of the `repo-template` source project |
| [decisions/](decisions/) | Architecture Decision Records, including first-agent and downstream reconciliation decisions |

## Root-Level Project Docs

| Document | Purpose |
|---|---|
| [README.md](../README.md) | Source template overview and golden path |
| [CLAUDE.md](../CLAUDE.md) | Claude Code source/derived repository entry rules |
| [AGENTS.md](../AGENTS.md) | Codex source/derived repository entry rules |
| [.repo-template.yaml](../.repo-template.yaml) | Stable template provenance/reconciliation baseline |
| [SECURITY.md](../SECURITY.md) | Security policy and vulnerability reporting |
| [CONTRIBUTING.md](../CONTRIBUTING.md) | Contribution guidelines for the source template |
| [GOVERNANCE.md](../GOVERNANCE.md) | Source-template governance |
| [CHANGELOG.md](../CHANGELOG.md) | Version history |

> [!IMPORTANT]
> Source-template documentation is inherited reference material in a fresh derived repository. Phase 0 determines which parts remain relevant, while `.repo-template.yaml` remains as the small provenance anchor for future reconciliation.
