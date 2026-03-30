# repo-template Execution Plan

> Generated: 2026-03-30 | Author: Anthony Velte (@vbonk)
> Status: APPROVED — ready for execution
> Test baseline: 100 checks passing (82 unit + 18 E2E)

## Project Context

repo-template is a production-ready GitHub template repository with 7 AI agent configs, 16 workflows, 6-layer security, and 100 automated tests. v1.0.0 is released. This plan covers the path from v1.0.0 to v1.1.0 based on 4 research reports analyzing the competitive landscape, OSSF scorecard, top 50 templates, and scaffolding UX patterns.

## Research-Driven Priorities

| Source | Finding | Impact | Effort | Milestone |
|--------|---------|--------|--------|-----------|
| R2 | OSSF Scorecard ~5.8/10 | High | Medium | M1 |
| R2 | Sigstore release signing | High | Low | M1 |
| R2 | SBOM generation in releases | High | Low | M1 |
| R2 | OpenSSF Best Practices badge | High | Low | M1 |
| R3 | PROD_CHECKLIST.md | High | Low | M1 |
| R3 | CONTRIBUTORS.md + auto-gen | Medium | Low | M1 |
| R1 | .claude/skills/ + .claude/agents/ dirs | High | Low | M1 |
| R3 | Commitlint config template | Medium | Low | M1 |
| R3 | Conflict detection workflow | Medium | Low | M1 |
| R2 | Strengthen branch protection docs | High | Low | M1 |
| R4 | "Recommended defaults" meta-prompt | Medium | Medium | M2 |
| R4 | Non-interactive flag mode | Medium | Medium | M2 |
| R1 | Scratchpad/working memory | Low | Low | M2 |
| — | CLI tool (npx create-repo-template) | High | High | M3 |
| — | Monorepo variant template | Medium | High | M3 |

---

## Milestone 1: OSSF + Research Quick Wins (v1.1.0)

**Goal:** Raise OSSF Scorecard from ~5.8 to ~8.0, implement all research quick wins.
**Estimated effort:** 8-10 issues, 2-3 hours agent time
**Release:** v1.1.0

### Issue 1.1: Sigstore Release Signing

**Objective:** Sign releases with Sigstore cosign so OSSF Signed-Releases check passes.

**Pre-Read:**
- `_admin/research/r2-ossf-scorecard.md` (Tier 1 fixes section)
- `.github/workflows/release.yml` (current release workflow)

**Tasks:**
- [ ] Add `sigstore/cosign-installer` action to release.yml (SHA-pinned)
- [ ] Add step: `cosign sign-blob` on release artifacts
- [ ] Upload `.sigstore.json` bundle as release asset
- [ ] Add `id-token: write` to workflow permissions

**Definition of Done:**
- [ ] release.yml updated with Sigstore signing
- [ ] ShellCheck / YAML validation passes
- [ ] Actions are SHA-pinned (verify with `grep`)
- [ ] `permissions:` includes `id-token: write`
- [ ] test-template.sh Layer 2 still passes
- [ ] Manual verification: push a test tag, check release has `.sigstore` asset

**Agent Prompt:**
```
Read _admin/research/r2-ossf-scorecard.md for context. Then read .github/workflows/release.yml.
Add Sigstore cosign signing to the release workflow. Use sigstore/cosign-installer (SHA-pinned).
Add a step after the release is created that signs the release artifacts with cosign sign-blob.
Upload .sigstore.json bundles as release assets. Add id-token: write to permissions.
Verify: all actions SHA-pinned, YAML valid, test-template.sh --layer 2 passes.
```

**Testing:** `bash scripts/test-template.sh --layer 2`

---

### Issue 1.2: SBOM Generation in Releases

**Objective:** Generate Software Bill of Materials on each release for OSSF SBOM check.

**Pre-Read:**
- `_admin/research/r2-ossf-scorecard.md`
- `.github/workflows/release.yml`

**Tasks:**
- [ ] Add `anchore/sbom-action` to release.yml (SHA-pinned)
- [ ] Generate CycloneDX SBOM from repo contents
- [ ] Upload as release asset (`sbom.cyclonedx.json`)

**Definition of Done:**
- [ ] SBOM step added to release.yml
- [ ] Action is SHA-pinned
- [ ] test-template.sh --layer 2 passes
- [ ] Manual: push tag, verify SBOM in release assets

**Agent Prompt:**
```
Read _admin/research/r2-ossf-scorecard.md section on SBOM. Then read .github/workflows/release.yml.
Add anchore/sbom-action (SHA-pinned) to generate a CycloneDX SBOM and upload as release asset.
Run: bash scripts/test-template.sh --layer 2 to verify.
```

**Testing:** `bash scripts/test-template.sh --layer 2`

---

### Issue 1.3: OpenSSF Best Practices Badge

**Objective:** Register project at bestpractices.coreinfrastructure.org and add badge to README.

**Pre-Read:**
- `_admin/research/r2-ossf-scorecard.md`
- `README.md` (badges section)

**Tasks:**
- [ ] Register at https://www.bestpractices.dev/en/projects/new
- [ ] Complete questionnaire (most answers are "Met" given our setup)
- [ ] Add badge to README.md badges section
- [ ] Update test-template.sh to check for badge

**Note:** This requires human interaction (web form). Agent prepares the answers, human submits.

**Definition of Done:**
- [ ] Badge URL obtained
- [ ] Badge added to README
- [ ] Questionnaire answers documented in `_admin/ossf-badge-answers.md`

---

### Issue 1.4: PROD_CHECKLIST.md

**Objective:** Production readiness checklist template (from R3: hackathon-starter pattern, 35K stars).

**Pre-Read:**
- `_admin/research/r3-top-templates.md` (hackathon-starter section)

**Tasks:**
- [ ] Create `docs/PROD_CHECKLIST.md` with categorized checklist
- [ ] Categories: Security, Performance, Monitoring, Documentation, Legal, Infrastructure
- [ ] Each item is a checkbox with brief explanation
- [ ] Add reference in README customization guide
- [ ] Add to audit-compliance.sh FEATURES list
- [ ] Add to test-template.sh essential files check

**Definition of Done:**
- [ ] docs/PROD_CHECKLIST.md exists with 20+ checklist items
- [ ] README references it
- [ ] audit-compliance.sh includes it
- [ ] test-template.sh --layer 1 and --layer 2 pass

**Agent Prompt:**
```
Create docs/PROD_CHECKLIST.md — a production readiness checklist template.
Categories: Security (SSL, secrets, scanning), Performance (caching, CDN, load testing),
Monitoring (logging, alerts, uptime), Documentation (API docs, runbook, architecture),
Legal (license, privacy, terms), Infrastructure (backups, scaling, disaster recovery).
Each item: checkbox + 1-line explanation. Use GitHub callouts for critical items.
Add to scripts/audit-compliance.sh FEATURES list. Add to test-template.sh essential files.
Run: bash scripts/test-template.sh to verify.
```

**Testing:** `bash scripts/test-template.sh`

---

### Issue 1.5: CONTRIBUTORS.md + Auto-Generation Workflow

**Objective:** Contributor recognition (from R3: found in 5/50 top repos).

**Tasks:**
- [ ] Create `CONTRIBUTORS.md` template
- [ ] Create `.github/workflows/update-contributors.yml` — regenerates from git log on push to main
- [ ] SHA-pin all actions

**Definition of Done:**
- [ ] CONTRIBUTORS.md exists
- [ ] Workflow generates it from git history
- [ ] test-template.sh passes

**Agent Prompt:**
```
Create CONTRIBUTORS.md with a header explaining it's auto-generated.
Create .github/workflows/update-contributors.yml that runs on push to main,
extracts unique authors from git log, formats as a markdown table, and commits
the update. SHA-pin all actions. Use permissions: contents: write.
Run: bash scripts/test-template.sh --layer 2 to verify YAML + SHA pins.
```

---

### Issue 1.6: .claude/skills/ and .claude/agents/ Directories

**Objective:** Add standard Claude Code directories (from R1: found in serious Claude setups).

**Tasks:**
- [ ] Create `.claude/skills/README.md` — explains what skills are, how to add them
- [ ] Create `.claude/agents/README.md` — explains what agents are, how to add them
- [ ] Add to CODEOWNERS (security-sensitive)
- [ ] Reference in CLAUDE.md

**Definition of Done:**
- [ ] Both directories exist with README.md
- [ ] CODEOWNERS updated
- [ ] test-template.sh passes

**Agent Prompt:**
```
Create .claude/skills/README.md explaining Claude Code skills: what they are,
where to find community skills, how to create custom skills for the project.
Create .claude/agents/README.md explaining Claude Code agents: what they are,
when to use them, how to create project-specific agents.
Add both directories to .github/CODEOWNERS under the AI security section.
Reference in CLAUDE.md under Custom Commands section.
Run: bash scripts/test-template.sh to verify.
```

---

### Issue 1.7: Commitlint Config Template

**Objective:** Conventional commit enforcement (from R3: ixartz pattern).

**Tasks:**
- [ ] Create `templates/linting/commitlint.config.js.template`
- [ ] Reference in CONTRIBUTING.md commit conventions section

**Definition of Done:**
- [ ] Template file exists
- [ ] CONTRIBUTING.md references it
- [ ] test-template.sh passes

---

### Issue 1.8: Conflict Detection Workflow

**Objective:** Auto-label PRs with merge conflicts (from R3: fastapi pattern).

**Tasks:**
- [ ] Create `.github/workflows/detect-conflicts.yml`
- [ ] Runs on push to main, checks all open PRs for conflicts
- [ ] Adds `needs-rebase` label to conflicting PRs
- [ ] SHA-pin all actions, explicit permissions

**Definition of Done:**
- [ ] Workflow exists and is valid YAML
- [ ] Actions SHA-pinned
- [ ] test-template.sh --layer 2 passes

---

### Issue 1.9: Update Audit + Test Counts

**Objective:** After all M1 changes, update test assertions and audit features.

**Tasks:**
- [ ] Update workflow count in README (16 → new count)
- [ ] Update test-template.sh assertions to match new counts
- [ ] Update audit-compliance.sh FEATURES list with all new files
- [ ] Run full test suite: `bash scripts/test-template.sh && bash scripts/test-e2e.sh`

**Definition of Done:**
- [ ] test-template.sh: 0 failures
- [ ] test-e2e.sh: 0 failures
- [ ] audit-compliance.sh self-score: 100% A+

---

### Issue 1.10: Documentation + Memory Checkpoint

**Objective:** Update all docs, save to MCP memory, update CHANGELOG.

**Tasks:**
- [ ] Update CHANGELOG.md with v1.1.0 entries
- [ ] Update _admin/ROADMAP.md — move M1 items to completed
- [ ] Save to MCP memory: v1.1.0 features, OSSF score improvement
- [ ] Update local MEMORY.md
- [ ] Create v1.1.0 release on GitHub
- [ ] Run audit-compliance.sh, save to audits/repo-compliance.json

**Definition of Done:**
- [ ] CHANGELOG updated
- [ ] MCP memory saved
- [ ] v1.1.0 release published
- [ ] Compliance audit saved

---

## Milestone 2: Init UX + Claude Integration (v1.2.0)

**Goal:** Improve scaffolding UX based on R4 research. Non-interactive mode. Enhanced Claude integration.
**Estimated effort:** 5-6 issues, 3-4 hours

### Issue 2.1: "Recommended Defaults" Meta-Prompt

**Objective:** Add a 1-question shortcut to init-template that collapses Quick Mode.

**Tasks:**
- [ ] Update .claude/commands/init-template.md
- [ ] First question: "Quick setup with recommended defaults? (Y/n)"
- [ ] If Y: auto-fill with Node.js/TypeScript defaults, run secure-repo.sh + hooks
- [ ] If n: proceed with current interactive flow

### Issue 2.2: Non-Interactive Flag Mode

**Objective:** Support fully non-interactive scaffolding for CI/automation.

**Tasks:**
- [ ] Create `scripts/init-project.sh` — CLI wrapper for init-template
- [ ] Flags: `--name`, `--stack`, `--description`, `--no-interactive`
- [ ] Calls secure-repo.sh and setup-hooks.sh automatically

### Issue 2.3: Scratchpad / Working Memory

**Objective:** Add `.claude/scratchpad.md` pattern (from R1: devin.cursorrules).

**Tasks:**
- [ ] Create `.claude/scratchpad.md` template
- [ ] Reference in CLAUDE.md
- [ ] Add to .gitignore (working memory is local-only)

### Issue 2.4: Update Audit + Test + Release

- Same as 1.9/1.10 pattern

---

## Milestone 3: Distribution (v2.0.0)

**Goal:** CLI tool + monorepo variant.
**Issues:** #75 (CLI), #79 (Monorepo)
**Estimated effort:** Significant — separate planning needed

---

## Execution Strategy

### Parallel Execution Plan

```
Batch A (parallel — no file conflicts):
  Issue 1.1 (Sigstore)     → modifies: release.yml
  Issue 1.4 (PROD_CHECKLIST) → creates: docs/PROD_CHECKLIST.md
  Issue 1.6 (.claude dirs)  → creates: .claude/skills/, .claude/agents/
  Issue 1.7 (Commitlint)    → creates: templates/linting/commitlint.config.js.template

Batch B (parallel — no file conflicts):
  Issue 1.2 (SBOM)          → modifies: release.yml (AFTER 1.1 merges)
  Issue 1.5 (CONTRIBUTORS)  → creates: CONTRIBUTORS.md, new workflow
  Issue 1.8 (Conflicts)     → creates: new workflow

Batch C (sequential — touches shared files):
  Issue 1.3 (OSSF Badge)    → modifies: README.md (human step)
  Issue 1.9 (Counts)        → modifies: test-template.sh, audit-compliance.sh, README.md
  Issue 1.10 (Docs)         → modifies: CHANGELOG.md, memory, release
```

### Testing Strategy

Each issue runs: `bash scripts/test-template.sh`
After each batch: `bash scripts/test-template.sh && bash scripts/test-e2e.sh`
Before release: Full E2E including repo creation

### Documentation Checkpoints

| After | Update |
|-------|--------|
| Batch A complete | Commit, update CHANGELOG draft |
| Batch B complete | Commit, run compliance audit |
| Batch C complete | Full docs pass, MCP memory, release |

---

## Quality Gates

Every issue must pass before closing:

1. **Code quality:** ShellCheck passes, YAML valid, Actions SHA-pinned
2. **Tests pass:** `bash scripts/test-template.sh` — 0 failures
3. **DOD verified:** Every checkbox in the issue's Definition of Done checked
4. **No regressions:** Existing test count doesn't decrease
5. **Docs updated:** README, CHANGELOG, relevant docs reflect changes

---

## Session Preparation Checklist

Before starting execution:

- [x] Plan saved to `plan.md` in repo root
- [ ] All M1 issues created on GitHub with DOD + agent prompts
- [ ] Labels applied: `milestone:v1.1.0`, `status:planning`
- [ ] Existing issues (#75, #79) updated with milestone:v2.0.0 label
- [ ] MCP memory saved with plan reference
- [ ] MEMORY.md updated
