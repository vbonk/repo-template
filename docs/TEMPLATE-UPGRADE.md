# Template Upgrade — Downstream Reconciliation SOP

> Canonical, model-neutral procedure for upgrading a repository descended from `vbonk/repo-template` without resetting or overwriting legitimate project evolution.

**Version:** 1.0  
**Current compatibility baseline:** `agent-native-phase0-v1`  
**Applies to:** Claude Code, Codex, and other capable engineering agents working in a repository with confirmed or suspected `repo-template` ancestry.

## Purpose

Phase 0 answers: **How does a fresh template instance become the real project?**

Template Upgrade answers: **How does an existing project adopt later improvements from `repo-template` without becoming the template again?**

These are separate operations. A mature project must not rerun Phase 0 merely because the source template changed.

## Core Principle

**Project evolution is authoritative. Template ancestry is advisory.**

Never make an established repository match current `repo-template` file-for-file. Intentional divergence is expected after Phase 0.

## Repository Router

Determine the path from repository evidence before changing anything.

| State | Indicators | Path |
|---|---|---|
| Source template | Repository is `vbonk/repo-template` | Maintain the template; do not run downstream normalization |
| Fresh current instance | `.repo-template.yaml` exists, generic template README/agent instructions remain, little or no project-specific work | Phase 0 |
| Existing current-derived project | Marker exists and project-specific source/docs/instructions are established | Normal project work; use Template Upgrade only when an upgrade/reconciliation is requested or compatibility is being checked |
| Legacy pristine instance | Marker absent, strong template ancestry evidence, little or no project work | Reconcile to current substrate, add provenance, then Phase 0 |
| Legacy established project | Marker absent, strong template ancestry evidence, substantial project work | Template Upgrade using conservative legacy-baseline inference |
| Uncertain ancestry/state | Evidence conflicts or provenance cannot be established confidently | Preserve project state; perform assessment only until the ambiguity is resolved |

## Non-Negotiable Rules

1. **Inspect before reconciling.** Understand project history, current behavior, and repository controls before proposing template-derived changes.
2. **Preserve project-owned work.** Project source, project-specific docs, workflows, architecture, agent instructions, and intentional removals outrank newer template defaults.
3. **Never use exact file synchronization as the upgrade strategy.** A downstream repository is not expected to remain identical to its template source.
4. **Treat security and repository-integrity improvements as high-priority candidates, not automatic replacements.** Reconcile them with project-specific controls.
5. **Do not infer application architecture, stack, licensing, deployment, or environment configuration from the template.**
6. **Do not change `.repo-template.yaml` to the new baseline until reconciliation and validation are complete.** The marker represents completed compatibility work, not intent.
7. **Use the repository's normal branch/PR/validation policy.** Do not bypass project governance because the change originates from the template.
8. **Keep the operation explainable.** The final diff and report must distinguish template-derived improvements from project-specific edits.

## Step 1 — Establish Repository and Ancestry Evidence

Collect, where available:

- repository full name, visibility, default branch, current HEAD, and working-tree state;
- recent commits and the earliest accessible project commits;
- open PRs/issues relevant to repository maintenance;
- `.repo-template.yaml`;
- `CLAUDE.md`, `AGENTS.md`, root README, `.claude/`, `.github/`, security scripts, and template-era documentation;
- references to `vbonk/repo-template`, old `/project:init-template`, template badges, template workflows, or historical template paths.

### Marker-present repositories

If `.repo-template.yaml` exists, treat its `baseline_id` as the declared last reconciled compatibility generation. Confirm that the repository's history and content are consistent with that ancestry.

### Legacy repositories without the marker

Infer ancestry conservatively from multiple signals. Useful evidence includes:

- a first commit/tree closely matching a historical `repo-template` snapshot;
- old template README/agent text;
- template-specific workflows, scripts, commands, labels, or docs;
- commit timing relative to known template releases;
- explicit references to `vbonk/repo-template`.

Classify confidence as:

- **CONFIRMED** — history/tree evidence establishes the baseline reliably;
- **LIKELY** — multiple independent signals support ancestry but the exact baseline is uncertain;
- **UNKNOWN** — evidence is insufficient or contradictory.

Do not pretend an UNKNOWN baseline is exact.

## Step 2 — Classify Project Maturity

Classify the repository independently from ancestry confidence.

### PRISTINE

No meaningful project work beyond inherited template material or trivial metadata changes.

### LIGHTLY_CUSTOMIZED

Some project-specific changes exist, but much of the inherited substrate remains recognizable and structurally close to the template.

### PROJECT_MATURE

The repository contains substantial project-specific source, documentation, architecture, automation, operational history, or agent instructions. Template content is ancestry, not current design.

### AMBIGUOUS

The repository has mixed or unclear state. Default to preservation and assessment rather than broad replacement.

## Step 3 — Build the Three-Way Model

Reason about three conceptual states:

- **A — Historical template baseline:** what the project originally inherited or was last reconciled against;
- **B — Current project:** the repository as it exists now;
- **C — Current template:** the current `vbonk/repo-template` baseline and its downstream-relevant changes.

The goal is not to merge C into B mechanically. Compare:

- **A → B:** what the project intentionally changed, removed, or added;
- **A → C:** what the template learned, fixed, or added since the baseline.

Then decide which parts of A → C are useful to B.

When exact A is unavailable, use the best-supported historical approximation and lower confidence accordingly.

## Step 4 — Classify Template Changes by Downstream Value

Before applying anything from the current template, classify each candidate change.

| Class | Default treatment |
|---|---|
| Critical security correction | Highest-priority review; normally adopt or implement an equivalent/stronger project-specific control |
| Agent safety / agent-routing correction | Strongly prefer adoption where the project uses the affected agent surface |
| Repository integrity / governance | Prefer when compatible with project workflow |
| CI / dependency / automation improvement | Evaluate against the project's actual stack and existing automation |
| Documentation standard | Adopt selectively where it improves project truth/navigation |
| Convenience tooling | Optional |
| Source-template maintenance machinery | Do not propagate unless the downstream project has an independent need |
| Marketing, examples, tutorial scaffolding | Do not propagate |
| Stack-specific example configuration | Do not propagate unless independently justified by the project |

## Step 5 — Reconcile Each Candidate Against Project Ownership

Use these rules:

| Current project state for the affected area | Reconciliation behavior |
|---|---|
| Still essentially unchanged from historical template | Usually safe to adopt the newer template behavior after validation |
| Project customized it | Preserve project intent; semantically integrate only the relevant improvement |
| Project removed it | Presume the removal was intentional; do not restore automatically |
| Current template introduces a new capability | Evaluate relevance; absence in the project is not itself a defect |
| Project already has equivalent or stronger behavior | Keep the project implementation; record that the template change is satisfied by equivalence |
| Conflict cannot be resolved confidently | Leave project behavior unchanged and report the unresolved reconciliation item |

A missing template file in a mature project is not automatically drift.

## Step 6 — Apply the Correct Upgrade Path

### Path A — PRISTINE legacy instance

When ancestry is confirmed and no meaningful project work exists, the inherited substrate can be refreshed to the current template generation. Preserve repository identity and GitHub history/settings. After the refreshed substrate is validated, add/update `.repo-template.yaml` and continue through Phase 0 for real project intake.

There is normally no reason to delete and recreate the GitHub repository.

### Path B — LIGHTLY_CUSTOMIZED project

Use the three-way comparison aggressively enough to distinguish inherited material from real project edits. Update inherited infrastructure where safe, preserve custom edits, and avoid restoring template-only material that the project has already discarded.

### Path C — PROJECT_MATURE

Treat `repo-template` as an upstream knowledge source, not a filesystem authority. Selectively adopt high-value improvements. Do not replace the project's README, architecture, application CI, agent instructions, or source structure with current template versions.

The mature project's existing Definition of Done and validation suite remain authoritative.

### Path D — AMBIGUOUS / UNKNOWN

Produce a reconciliation assessment first. Avoid broad changes until project ownership and ancestry are understood. Security-critical gaps may still be surfaced immediately, but uncertainty must be explicit.

## Step 7 — Preserve Cross-Agent Upgrade Routing

If `.repo-template.yaml` remains in the project, project-specific `CLAUDE.md` and `AGENTS.md` should retain a concise **Template Ancestry** rule equivalent to:

> This project descends from `vbonk/repo-template`. `.repo-template.yaml` records the last reconciled compatibility baseline. Do not rerun Phase 0 for normal project work. When a template upgrade or compatibility review is requested, follow the canonical `docs/TEMPLATE-UPGRADE.md` referenced by the marker and reconcile semantically rather than synchronizing files.

This routing rule is intentionally small. It allows future agents to choose the correct path without carrying the source template's generic project instructions.

For Claude Code, the bundled `template-upgrade` skill may assist automatically when upgrade/reconciliation intent is detected. Codex and other agents must not depend on that skill; this document remains the model-neutral source of truth.

## Step 8 — Repository Controls and Non-Transferred State

Template file reconciliation and GitHub repository configuration are separate concerns.

When relevant, verify that project controls still reflect the intended policy, including:

- branch/ruleset protection;
- required CI checks;
- CODEOWNERS ownership and protected paths;
- local hook installation for active developer/agent environments;
- labels/task taxonomy if the project uses it;
- dependency/security automation appropriate to the actual project.

Do not assume repository settings were inherited from the original template or updated merely because files changed.

## Step 9 — Provenance Update

Only after reconciliation and validation succeed:

- retain `source_repository: vbonk/repo-template`;
- set `baseline_id` to the current compatibility baseline;
- retain the canonical upgrade-spec reference;
- add the marker to legacy repositories that have now been successfully reconciled.

The marker records template ancestry and completed compatibility. It is not application lifecycle state and must not become a dumping ground for project metadata.

The reconciliation PR/commit history should explain the previous baseline or legacy inference and what was adopted, adapted, considered equivalent, or intentionally skipped.

## Step 10 — Validation

Validation is project-specific plus template-reconciliation-specific.

At minimum verify:

### Project preservation

- project source and project-specific documentation remain intact;
- project commands, architecture, deployment, and environment documentation remain truthful;
- intentional project removals were not casually restored.

### Adopted capabilities

- every adopted template capability actually works in this repository;
- equivalent project controls are documented as equivalent rather than overwritten;
- new workflows/configurations target real project ecosystems only.

### Agent behavior

- `CLAUDE.md` and `AGENTS.md` remain project-specific;
- if the provenance marker remains, the Template Ancestry routing rule remains discoverable;
- Phase 0 is not presented as the normal path for a mature project.

### Security and governance

- security controls were not weakened as a side effect of reconciliation;
- no credentials or unrelated private data were introduced;
- repository settings required by adopted controls are actually present or explicitly listed as follow-up work.

### Diff review

Review the complete diff and ask:

- Did this improve the project, or merely make it look more like the template?
- Did any project-owned decision get overwritten?
- Did any source-template-only mechanism leak downstream?
- Is every changed file justified by a concrete compatibility improvement?
- Would a future agent understand both the project and its template ancestry?

## Final Report

Report:

- repository and branch/PR;
- ancestry confidence and historical baseline evidence;
- maturity classification;
- previous and current compatibility baseline;
- candidate template changes reviewed;
- changes adopted, adapted, satisfied by equivalent controls, skipped, or unresolved;
- validation performed and results;
- repository-setting follow-ups, if any;
- final provenance-marker state.

## Definition of Done

Template reconciliation is complete only when:

- ancestry and repository maturity were assessed before broad changes;
- project-owned work remained authoritative;
- current template changes were classified by downstream relevance;
- reconciliation used the A/B/C model rather than exact synchronization;
- security/agent/integrity improvements received appropriate priority;
- project-specific agent instructions retained upgrade routing when provenance remains;
- repository controls were verified where relevant;
- the complete diff was reviewed;
- project validation passed or limitations were explicitly documented;
- `.repo-template.yaml` was updated only after successful reconciliation;
- the final report makes adopted and intentionally skipped changes auditable.

## Future Template Evolution

`baseline_id` is a compatibility-generation identifier, not a release number and not a Git commit SHA.

Bump the baseline when a future `repo-template` change materially alters downstream bootstrap, agent-routing, security/governance expectations, provenance, or reconciliation behavior. Routine source-template maintenance that does not change downstream compatibility does not require a new baseline.

Older marked baselines and legacy unmarked repositories must remain supported by this SOP. A future template revision must not assume every downstream repository was created from the newest baseline.

---

**Referenced by:** `.repo-template.yaml`, `CLAUDE.md`, `AGENTS.md`, `.claude/commands/upgrade-template.md`, `.claude/skills/template-upgrade/SKILL.md`  
**See also:** [Phase 0](PHASE-0.md) | [ADR 007](decisions/007-template-upgrade-reconciliation.md) | [AI Security](AI-SECURITY.md)
