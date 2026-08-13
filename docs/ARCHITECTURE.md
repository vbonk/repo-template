# Architecture

> Architecture of the `vbonk/repo-template` source project. In a template-derived repository, Phase 0 treats this as source-template reference material and reconciles it against the real incoming project.

**Last Updated:** 2026-08-13

## System Purpose

`repo-template` is an agent-native repository substrate, not an application framework. It provides a secure GitHub baseline, Claude Code/Codex entry instructions, first-agent normalization, optional automation, and verification tooling.

## Architecture

```mermaid
graph TD
    T[repo-template source] --> G[GitHub template instance]
    G --> E[Agent entry: CLAUDE.md / AGENTS.md]
    E --> P[Phase 0 normalization]
    P --> Q{Project material available?}
    Q -->|Yes| R[Project-specific repository]
    Q -->|No| S[Intake-ready substrate]

    T --> A[.claude toolkit]
    T --> H[Security and governance]
    T --> V[Validation and audits]
    T --> D[Source-template documentation]

    H --> G
    V --> T
    D --> E
```

## Components

| Component | Purpose | Primary locations |
|---|---|---|
| Agent entry | Distinguish source-template and derived-repository behavior | `CLAUDE.md`, `AGENTS.md` |
| Phase 0 | Normalize inherited template material before project implementation | `docs/PHASE-0.md` |
| Claude toolkit | Commands, skills, hooks, and specialized agents | `.claude/` |
| GitHub governance | PR/issue policy, CODEOWNERS, dependency and workflow configuration | `.github/` |
| Security baseline | Secret protection, repository hardening, AI threat model | `templates/hooks/`, `scripts/secure-repo.sh`, `docs/AI-SECURITY.md` |
| Verification | Template regression, E2E, compliance, and CI checks | `scripts/test-template.sh`, `scripts/test-e2e.sh`, `scripts/audit-compliance.sh`, `.github/workflows/` |
| Documentation | Source-template operation, security, architecture, and decisions | `README.md`, `docs/`, `docs/decisions/` |

## Derived-Repository Flow

```mermaid
sequenceDiagram
    participant U as User / Existing Session
    participant R as Derived Repository
    participant A as Claude or Codex
    participant P as Phase 0

    U->>A: Organize/publish existing project to repo
    A->>R: Inspect repository identity and state
    R-->>A: Generic template instance
    A->>P: Follow canonical normalization SOP
    P->>A: KEEP / ADAPT / REMOVE / DEFER
    A->>A: Reuse current-session project context
    A->>R: Materialize project-specific repository
    A->>R: Validate and publish through normal workflow
```

## Design Constraints

- **GitHub template copying is whole-repository copying.** Source-template files are inherited by derived repositories; agent entry behavior must distinguish reference material from project requirements.
- **No application stack assumption.** The substrate must remain valid before a runtime/framework is known.
- **Security before convenience.** Normalization may simplify tooling but must not casually weaken proven safeguards.
- **Two-agent focus.** Claude Code is primary and Codex is supported through `AGENTS.md`.
- **Truth over placeholders.** Root agent/documentation surfaces must describe the template project itself rather than fictitious example systems.
- **No mandatory lifecycle engine.** Repository identity plus project-specific replacement of generic entry files is sufficient for the current Phase 0 transition.

## Decision Records

Material architecture decisions are recorded in [docs/decisions/](decisions/).

| ADR | Decision |
|---|---|
| [001](decisions/001-sha-pinned-actions.md) | SHA-pin GitHub Actions |
| [002](decisions/002-rulesets-over-classic-protection.md) | Prefer rulesets over classic branch protection |
| [003](decisions/003-skills-directory-format.md) | Use runtime-supported skill directory format |
| [004](decisions/004-two-agent-focus.md) | Focus on Claude Code + Codex |
| [005](decisions/005-drift-severity-and-fail-closed.md) | Severity-aware, fail-closed drift verification |
| [006](decisions/006-agent-native-phase-zero.md) | Agent-native Phase 0 for derived repositories |

---

**Referenced by:** [README.md](../README.md), [CLAUDE.md](../CLAUDE.md), [AGENTS.md](../AGENTS.md)  
**See also:** [Phase 0](PHASE-0.md) | [AI Security](AI-SECURITY.md) | [ADRs](decisions/)
