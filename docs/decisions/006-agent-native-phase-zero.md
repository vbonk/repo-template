# ADR 006: Agent-Native Phase 0 for Derived Repositories

> Establish a canonical first-agent normalization step so repositories created from `repo-template` stop behaving like copies of the template before project-specific work begins.

**Status:** Accepted  
**Date:** 2026-08-13

## Context

GitHub template creation copies the source repository's files into every derived repository. That is useful for reusable security and governance infrastructure, but it also copies source-template marketing, examples, optional workflows, generic documentation, and placeholder project assumptions.

The dominant operating model for this template is agentic:

1. a repository is created from `vbonk/repo-template`;
2. a Claude Code or Codex session may already contain substantial project context, source, schemas, requirements, ADRs, PRDs, research, or other artifacts;
3. the agent is pointed at the newly created repository;
4. the agent should organize and publish the real project without requiring the user to explain how `repo-template` works.

The previous initialization model was interactive and stack-first. It asked for project identity, language, and tooling, then enabled template capabilities. This produced three problems:

- the first agent could mistake inherited examples for project truth;
- users had to repeat information already available in the active session;
- setup decisions were made before the template substrate had been normalized.

## Decision

Introduce a canonical **Phase 0** first-agent workflow for derived repositories.

### Repository-mode detection

`CLAUDE.md` and `AGENTS.md` must first distinguish:

- **source-template mode** — repository is `vbonk/repo-template`; and
- **derived-repository mode** — repository is another repo that still carries generic template instructions.

Derived repositories execute Phase 0 before application work.

### Phase 0 responsibilities

The first agent must:

1. verify repository state and preserve existing custom work;
2. inspect project context already available in the current session and artifacts;
3. classify inherited template material as **KEEP / ADAPT / REMOVE / DEFER**;
4. remove unsupported assumptions before introducing implementation;
5. preserve useful security and repository hygiene;
6. integrate real project material immediately when it is already available;
7. otherwise leave a truthful, minimal intake-ready substrate;
8. validate the resulting repository before publishing.

### No mandatory intermediate state machinery

Phase 0 is a workflow, not a persistent lifecycle database. The repository does not require a new state engine or mandatory intermediate commit.

When project material is already present, normalization and project intake should occur in the same coherent workflow.

### No speculative defaults

Root agent instructions and environment templates must not claim a runtime, framework, database, deployment target, commands, or environment variables before project evidence exists.

## Consequences

### Positive

- first-agent behavior is deterministic;
- users no longer need to explain template cleanup repeatedly;
- current-session project context becomes a first-class intake source;
- speculative architecture/configuration is less likely to become accidental project truth;
- template security controls can be retained deliberately rather than discarded indiscriminately;
- derived repositories become project-specific more quickly and with less context waste.

### Trade-offs

- source-template files still copy into derived repositories because GitHub templates have no per-file exclusion mechanism;
- Phase 0 must therefore distinguish source-template reference material from downstream requirements;
- some optional template capabilities may be discarded during downstream normalization and reintroduced later when justified by project needs.

## Rejected Alternatives

### Keep the interactive initializer as the primary path

Rejected because it requires repeated user input and tends to select project configuration before fully understanding incoming project material.

### Make the source repository itself extremely minimal

Rejected as the sole solution because `repo-template` is also a maintained public project with real security, validation, documentation, and release needs. Agent entry behavior can separate source-template concerns from downstream project concerns without discarding all source capabilities.

### Add a repository lifecycle state database

Deferred. A separate `state.yaml` or lifecycle engine is unnecessary while repository identity plus project-specific replacement of the generic entry files provides a sufficient transition signal.

## Implementation

- `docs/PHASE-0.md` is the canonical SOP.
- `CLAUDE.md` and `AGENTS.md` invoke Phase 0 automatically for derived repositories.
- root README and Getting Started documentation present the agent-first golden path.
- generic root configuration avoids fictitious application assumptions.
- regression tests should prevent speculative project defaults from reappearing in the root agent entry surfaces.

---

**See also:** [Phase 0](../PHASE-0.md) | [ADR 004: Two-Agent Focus](004-two-agent-focus.md) | [AI Security](../AI-SECURITY.md)
