---
name: hibernate
description: Hibernate or un-hibernate a GitHub repo. Disables Actions, Dependabot, Issues, Projects, Pages, and webhooks to stop all resource consumption and charges. Optionally archives (read-only). Fully reversible. Use when shutting down, pausing, or reactivating a repo. Triggers on "hibernate", "shut down repo", "pause repo", "deactivate repo", "un-hibernate", "reactivate repo", "wake up repo".
---

# Hibernate Repo Skill

Safely put a GitHub repository into a dormant state (or bring it back). Stops all automated processes, prevents charges, and preserves the repo for future use.

## When to Use

- Shutting down a repo you're no longer actively developing
- Pausing a project temporarily
- Reducing GitHub Actions/Dependabot resource consumption
- Reactivating a previously hibernated repo
- Checking if a repo is already hibernated

## Modes

| Mode | Trigger Phrases |
|------|----------------|
| **Hibernate** | "hibernate this repo", "shut down this repo", "pause this repo", "deactivate" |
| **Un-hibernate** | "un-hibernate", "reactivate this repo", "wake up this repo", "resume this repo" |
| **Status check** | "is this repo hibernated?", "check hibernate status" |

## Hibernate Procedure

### Step 1: Detect Current Repo

Determine the repo from the current working directory:

```bash
REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner' 2>/dev/null)
```

If not in a git repo or no remote, ask the user for the repo name (owner/repo format).

### Step 2: Check Current State

Gather the current state of all features:

```bash
# Actions enabled?
gh api repos/$REPO/actions/permissions --jq '.enabled'

# Issues, Projects, Wiki, Pages
gh api repos/$REPO --jq '{issues: .has_issues, projects: .has_projects, wiki: .has_wiki, pages: .has_pages, archived: .archived}'

# Vulnerability alerts (Dependabot)
gh api repos/$REPO/vulnerability-alerts 2>&1
# 204 = enabled, 404 = disabled

# Active webhooks
gh api repos/$REPO/hooks --jq '.[].config.url'

# Active workflows
gh api repos/$REPO/actions/workflows --jq '.workflows[] | .name + " (" + .state + ")"'

# GitHub Pages
gh api repos/$REPO/pages --jq '.status' 2>&1
# 404 = no pages
```

### Step 3: If Already Hibernated

If Actions disabled AND vulnerability alerts disabled AND issues disabled:
- Report: "This repo is already hibernated."
- If also archived: "This repo is hibernated AND archived (read-only)."
- Ask: "Would you like to un-hibernate it?"
- If user says no, stop.
- If user says yes, proceed to Un-hibernate Procedure.

### Step 4: Show Current State and Confirm

Display a table of what will be changed:

```
## Hibernate Plan for {REPO}

| Feature | Current | Will Be |
|---------|---------|---------|
| Actions | enabled | DISABLED |
| Dependabot alerts | enabled | DISABLED |
| Issues | enabled | DISABLED |
| Projects | enabled | DISABLED |
| Wiki | disabled | (no change) |
| Pages | none | (no change) |
| Webhooks | 2 active | (see below) |
| Archive | no | (optional) |
```

Use AskUserQuestion:
> "This will disable Actions, Dependabot, Issues, and Projects on {REPO}. The repo remains writable and can be un-hibernated anytime. Proceed?"

If webhooks are detected, also ask:
> "Found {N} webhook(s): {urls}. These will continue to fire unless removed or the repo is archived. Want to also archive the repo (makes it read-only, stops all webhook delivery)?"

### Step 5: Execute Hibernate

Run these commands in order:

```bash
# 1. Disable GitHub Actions
gh api -X PUT repos/$REPO/actions/permissions -F enabled=false

# 2. Disable vulnerability alerts (Dependabot alerts)
gh api -X DELETE repos/$REPO/vulnerability-alerts

# 3. Disable automated security fixes (Dependabot PRs)
# Only works if vulnerability alerts were enabled — ignore errors
gh api -X DELETE repos/$REPO/automated-security-fixes 2>/dev/null

# 4. Disable Issues
gh api -X PATCH repos/$REPO -F has_issues=false

# 5. Disable Projects
gh api -X PATCH repos/$REPO -F has_projects=false

# 6. Disable Wiki (if enabled)
gh api -X PATCH repos/$REPO -F has_wiki=false

# 7. Disable Pages (if enabled)
# gh api -X DELETE repos/$REPO/pages  # Only if pages exist

# 8. OPTIONAL: Archive (if user confirmed)
# gh repo archive $REPO --yes
```

### Step 6: Verify

Re-run the state checks from Step 2 and display results:

```
## Hibernate Complete: {REPO}

| Feature | Status |
|---------|--------|
| Actions | DISABLED |
| Dependabot | DISABLED |
| Issues | DISABLED |
| Projects | DISABLED |
| Wiki | DISABLED |
| Archived | yes/no |

The repo is now dormant. No workflows will run, no Dependabot PRs will be created,
no resource consumption or charges will accrue.

To reactivate: run /hibernate on this repo and choose un-hibernate.
```

## Un-hibernate Procedure

### Step 1: Check Current State

Same as Hibernate Step 2. Confirm the repo IS hibernated.

### Step 2: If Not Hibernated

Report: "This repo is not hibernated — all features are active." Stop.

### Step 3: If Archived

Use AskUserQuestion:
> "This repo is archived (read-only). Un-archiving will make it writable again. Proceed?"

If yes:
```bash
gh repo unarchive $REPO --yes
```

### Step 4: Confirm Re-enable Scope

Use AskUserQuestion:
> "Which features should be re-enabled? (Default: Actions + Dependabot + Issues)
> 1. Standard (Actions, Dependabot, Issues) — recommended
> 2. Minimal (Actions only — just enough to run CI)
> 3. Full (Actions, Dependabot, Issues, Projects, Wiki)
> 4. Custom — I'll tell you which ones"

### Step 5: Execute Un-hibernate

Based on user's choice:

```bash
# Re-enable Actions
gh api -X PUT repos/$REPO/actions/permissions -F enabled=true -f allowed_actions=all

# Re-enable vulnerability alerts
gh api -X PUT repos/$REPO/vulnerability-alerts

# Re-enable Issues
gh api -X PATCH repos/$REPO -F has_issues=true

# Re-enable Projects (if requested)
gh api -X PATCH repos/$REPO -F has_projects=true

# Re-enable Wiki (if requested)
gh api -X PATCH repos/$REPO -F has_wiki=true
```

### Step 6: Verify and Report

Same verification pattern as Hibernate Step 6, showing what was re-enabled.

## Important Notes

- **Hibernation is fully reversible** — nothing is deleted, just disabled
- **Archiving is also reversible** — `gh repo unarchive` makes it writable again
- **Webhooks survive hibernation** unless the repo is archived — mention this to the user
- **Vercel/Netlify connections** — if the repo is connected to a deployment platform, mention that auto-deploys will stop but existing deployments remain live
- **GitHub free tier** — Actions minutes and Dependabot are free for public repos, but still worth disabling to prevent noise. Private repos have minute limits.
- **Dependabot security fixes** can only be disabled while vulnerability alerts are enabled — disable alerts first, then fixes become moot
- **Always verify after changes** — the API can silently fail on some operations
