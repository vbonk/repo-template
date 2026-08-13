# Phase 0 — First-Agent Repository Normalization

> Canonical SOP for the first Claude Code or Codex agent entering a repository created from `vbonk/repo-template`. Phase 0 prepares the repository substrate before project-specific implementation, while immediately ingesting real project material when it is already available.

**Last Updated:** 2026-08-13

## Trigger

Run Phase 0 when all of the following are true:

- the repository is **not** `vbonk/repo-template` itself;
- the repository still contains the generic `repo-template` README and/or generic root agent instructions;
- the repository has not already been clearly converted into a project-specific repository.

Do not require the user to invoke a command. `CLAUDE.md` and `AGENTS.md` make this the default first-agent behavior.

> [!CAUTION]
> Never run destructive Phase 0 cleanup against the canonical `vbonk/repo-template` source repository.

## Objective

Transform a fresh template instance into one of two truthful outcomes:

1. **Project-specific repository** — when real project material is already available in the current session, supplied artifacts, local workspace, or repository; or
2. **Clean intake-ready substrate** — when the actual project has not yet been provided.

Phase 0 is repository preparation. It must not invent the future application.

## Governing Principles

1. **Read before modifying.** Understand repository state before deleting inherited material.
2. **Preserve user work.** Template-looking files may have been edited after repository creation.
3. **Remove assumptions before adding implementation.** No speculative stack, architecture, commands, dependencies, services, or deployment targets.
4. **Current-session context is project input.** Do not ask the user to repeat information the agent already has.
5. **Security is not clutter.** Preserve useful safeguards unless they are irrelevant or replaced by equivalent or stronger controls.
6. **Configuration must be truthful.** A file that appears configured but is not is worse than no file.
7. **Minimal interruption.** Ask only when a material decision cannot be inferred safely.
8. **No ceremonial intermediate state.** If the project is already available, normalize and integrate it in one coherent workflow.
9. **Preserve upgrade provenance.** `.repo-template.yaml` is intentionally durable ancestry metadata, not template clutter.

## Phase 1 — Detect and Verify

Establish:

- repository full name, visibility, default branch, and current HEAD;
- recent commit history;
- branches, open PRs, and open issues when accessible;
- whether files differ from the inherited template;
- whether project-specific source, docs, assets, configuration, or instructions already exist.

The user may believe the repository is pristine. Verify that assumption.

If user-authored or project-specific work exists, preserve it. Do not classify content as disposable solely because its path also exists in the template.

## Phase 2 — Discover Project Payload

Before asking setup questions, inspect all project context already available to you, including:

- the current conversation/session;
- files and artifacts already produced in the session;
- existing source code;
- PRDs, ARDs, ADRs, schemas, specifications, diagrams, research, prompts, and knowledge structures;
- relevant repository files and GitHub metadata.

Determine whether meaningful project material is already available.

### If project material exists

Treat it as the payload to be organized and materialized. Infer what is well-supported; surface only consequential unknowns that cannot safely be resolved.

### If project material does not exist

Do not invent it. Prepare a minimal intake-ready substrate and stop after validation.

## Phase 3 — Classify Inherited Artifacts

Classify each material template artifact as **KEEP / ADAPT / REMOVE / DEFER**.

### KEEP

Retain stack-neutral infrastructure that has current value. Typical candidates:

- `.gitignore`;
- `.gitattributes`;
- `.editorconfig`;
- `.repo-template.yaml` template-provenance marker;
- useful security policy/boundaries;
- secret-protection mechanisms;
- valid CODEOWNERS protections;
- concise PR/issue governance that matches the project;
- root agent entry files until they are replaced with project-specific versions;
- baseline-compatibility signaling when the project wants automated notice that a newer template compatibility generation exists.

KEEP is not automatic. Confirm that retained material is accurate for the derived repository.

### ADAPT

Useful concepts that carry template-specific identity or assumptions. Typical candidates:

- `README.md`;
- `CLAUDE.md`;
- `AGENTS.md`;
- `SECURITY.md`;
- `.github/CODEOWNERS`;
- PR and issue templates;
- CI;
- Dependabot;
- `.env.example`;
- documentation indexes.

### REMOVE

Material that exists for the template project or demonstrates optional capabilities but has no present project purpose. Common candidates include:

- template marketing and source-template badges;
- `CHANGELOG.md`, governance/community files, funding, or contributor automation when they do not fit the project;
- legacy exact-file drift/synchronization checks that treat intentional project divergence as a defect;
- source-template release/package-publishing workflows;
- stale/lock/welcome maintenance automation that is not wanted;
- example agents and example skills;
- tutorial commands that do not serve the project;
- unused devcontainer/IDE recommendations;
- unused linting, coverage, Docker, or language templates;
- placeholder `src/` and `tests/` content;
- template-only audit outputs;
- documentation describing how to choose or create a repo from `repo-template`.

Do not blindly delete this list. Inspect first.

### DEFER

Do not create or configure these until supported by real project requirements:

- application source structure;
- framework/runtime/package manager;
- package manifests and lockfiles;
- application build/test/lint/typecheck commands;
- dependency ecosystem configuration;
- deployment or hosting configuration;
- database, CMS, authentication, analytics, or observability choices;
- real environment variable inventory;
- project architecture documents when architecture is not yet known.

## Phase 4 — Normalize the Repository

Remove the template's identity from the derived repository.

At minimum resolve:

- `repo-template` title/marketing in the root README;
- source-template badges and links that imply the derived repo is the template project;
- “Use this template” and repository-creation instructions that are now upstream history;
- generic TODOs and placeholders that can be mistaken for requirements;
- example architecture, commands, services, and environment variables;
- references to removed files or commands.

The resulting repository must not pretend that example content is real project design.

Do not treat `.repo-template.yaml`, its source-repository reference, or the canonical Template Upgrade reference as stale template identity. Those are intentional provenance and future-maintenance metadata.

## Phase 5A — Project Material Is Already Available

When the current session already contains the project, proceed directly from normalization into project materialization.

1. Inventory the durable artifacts worth publishing.
2. Organize them into a coherent repository structure appropriate to the project rather than the template.
3. Preserve distinctions among requirements, architecture, decisions, research, schemas, implementation, operations, and supporting material.
4. Replace the transitional README with the real project README.
5. Replace `CLAUDE.md` and `AGENTS.md` with concise project-specific operating instructions. If `.repo-template.yaml` remains, include a small **Template Ancestry** rule that says normal project work does not rerun Phase 0 and future template-upgrade/compatibility requests use the canonical `docs/TEMPLATE-UPGRADE.md` referenced by the marker.
6. Configure CI, dependency tooling, environment documentation, and other capabilities only where the project provides evidence for them.
7. Capture material architectural decisions as ADRs when they are real decisions, not placeholders.
8. Reconcile links, indexes, and source-of-truth relationships.

Do **not** create an intermediate “substrate” commit merely for ceremony. One coherent normalization + project-intake change is preferable when the project is already known.

## Phase 5B — No Project Material Yet

Leave a deliberately small, truthful repository that says it is awaiting project intake.

The root README should state:

- the repository is prepared for project intake;
- application implementation and architecture have not yet been introduced;
- Claude Code uses `CLAUDE.md` and Codex uses `AGENTS.md`;
- no agent should scaffold a stack merely because the repo is empty;
- project-specific instructions will replace the transitional files at intake.

Retain `.repo-template.yaml`. Transitional `CLAUDE.md` and `AGENTS.md` should continue to expose the distinction between Phase 0 and Template Upgrade until real project-specific instructions replace them.

Create `docs/PROJECT_INTAKE.md` only when it is useful as a landing-zone schema. It should identify unresolved categories, not fabricate answers. Suggested categories:

- project identity, purpose, users, business objective;
- existing source/specifications/designs/assets;
- runtime/framework/package manager and real commands;
- architecture, persistence, integrations, authentication, analytics, observability;
- deployment and environment requirements;
- security/privacy constraints;
- source-of-truth documents and Definition of Done.

Create `docs/decisions/README.md` only if an ADR landing zone is useful. Do not fabricate ADRs.

## Phase 6 — GitHub and Automation

### CODEOWNERS

Retain only valid owners/patterns. Protect high-impact agent/security/workflow files when appropriate.

### Issue and PR templates

Keep the smallest useful set. Remove template-specific categories or checklists that do not match the project.

### CI

CI must describe checks that actually exist.

- If no application stack exists, retain only truthful repository-integrity/security checks or remove application CI until intake.
- Once the project is known, configure real build/test/lint/typecheck commands from project evidence.

### Dependabot and dependency automation

Do not configure ecosystems that do not exist. Enable them after the package ecosystem is known.

### Template compatibility signaling

The source template's historical drift workflow is now baseline-aware rather than exact-file-sync aware. If the project wants automated notice of a newer `baseline_id`, retain or adapt that capability. It should compare compatibility generations, not require the mature project to match template files.

If the project does not want automated compatibility checks, the provenance marker still preserves the upgrade route for an agent when a user requests reconciliation later.

### Release/package automation

Do not inherit release or package-publishing behavior merely because the template source uses it.

## Phase 7 — Licensing and Attribution

Do not treat the template's MIT license as an automatic licensing decision for the downstream application.

- Determine the intended project license only from explicit project/user evidence.
- A private or proprietary project may choose not to grant a public project license.
- Preserve notices/attribution required for MIT-licensed template material that remains in the repository.
- If the project license is consequential and cannot be inferred safely, surface it as a genuine open decision rather than guessing.

## Phase 8 — Global Cleanup

Search the resulting repository for stale template residue, including:

- source-template marketing references that are no longer operationally relevant;
- `/project:init-template` or obsolete initialization language;
- source-template badges;
- deleted paths and removed commands;
- generic TODOs and placeholders;
- example architecture/services/environment variables;
- unused scripts/configuration;
- broken relative links.

Intentional provenance references are allowed and should remain clearly scoped: `.repo-template.yaml`, the canonical Template Upgrade specification, required license/attribution notices, and any explicit historical documentation.

## Phase 9 — Validation

Before declaring Phase 0 complete, verify:

### Repository integrity

- user/project work was preserved;
- remaining files have a known purpose;
- no empty placeholder app source remains unless intentionally retained;
- no stack was selected without evidence;
- `.repo-template.yaml` still truthfully records template ancestry when the project remains template-derived.

### Documentation

- README accurately describes the current repository;
- agent instructions accurately describe the current repository;
- project-specific agent instructions retain the Template Ancestry upgrade route when provenance remains;
- links resolve;
- no fake commands, architecture, deployment targets, or environment variables remain.

### Automation

- CI only runs real checks;
- dependency automation targets real ecosystems;
- release/package automation is intentional;
- CODEOWNERS entries are valid;
- any retained template-compatibility check is baseline-aware and does not treat intentional project file divergence as failure.

### Security

- repository hygiene still protects sensitive local material;
- useful template safeguards were not removed without reason;
- no sensitive project data was introduced into public files.

### Diff review

Review the complete change set and ask:

- Did I remove template assumptions, or merely replace them with my own?
- Can the next agent understand this repository quickly?
- Can the real project proceed without fighting inherited scaffolding?
- Is every remaining template-derived capability intentional?
- Can a future agent tell how to handle a later `repo-template` compatibility upgrade without rerunning Phase 0?

Remediate any “no” answer before completion.

## Phase 10 — Commit and Handoff

Use the repository's normal branch/PR policy. Do not bypass protection merely because this is bootstrap work.

A suitable commit message is:

```text
chore: prepare repository for project intake
```

When project material was integrated at the same time, use a commit/PR description that reflects the actual broader scope.

Final report should state:

- repository/branch/final commit;
- major categories kept, adapted, removed, and deferred;
- whether project material was ingested;
- validation performed;
- whether template provenance and future upgrade routing were retained;
- genuine remaining decisions only;
- next action.

## Definition of Done

Phase 0 is complete only when:

- repository state was inspected before cleanup;
- custom work was preserved;
- inherited material was consciously classified;
- template identity and misleading defaults are gone from the derived project;
- no stack or architecture was invented;
- agent instructions reflect the real current state;
- `.repo-template.yaml` remains truthful template ancestry metadata;
- project-specific agent instructions retain future Template Upgrade routing when provenance remains;
- automation is truthful;
- any retained compatibility signal is baseline-aware rather than exact-sync based;
- licensing was not silently inferred from the template;
- security basics remain intact;
- stale references and broken links were resolved;
- the full diff was reviewed;
- the repository is either project-specific or genuinely intake-ready.

---

**Referenced by:** `README.md`, `CLAUDE.md`, `AGENTS.md`, `.claude/commands/bootstrap.md`  
**See also:** [Template Upgrade](TEMPLATE-UPGRADE.md) | [AI Security](AI-SECURITY.md) | [Documentation Guide](DOCUMENTATION-GUIDE.md) | [ADRs](decisions/)
