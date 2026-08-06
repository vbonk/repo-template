#!/usr/bin/env bash
# Unified GitHub Issues — Core Label Setup
# Usage: ./labels.sh [--repo owner/repo] [--dry-run]
# Creates/updates all core labels. Idempotent via --force.
# --dry-run prints the gh commands without executing (used by the self-test).

set -euo pipefail

REPO_ARGS=()
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --repo)
      if [[ $# -lt 2 || ! "$2" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]]; then
        echo "Error: --repo requires owner/repo" >&2
        exit 1
      fi
      REPO_ARGS=(--repo "$2")
      shift 2
      ;;
    --dry-run) DRY_RUN=true; shift ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

if [[ ${#REPO_ARGS[@]} -eq 0 ]]; then
  DETECTED=$(gh repo view --json nameWithOwner -q '.nameWithOwner' 2>/dev/null || true)
  if [[ -z "$DETECTED" ]]; then
    echo "Error: not in a GitHub repo and no --repo given" >&2
    exit 1
  fi
  REPO_ARGS=(--repo "$DETECTED")
fi

# make_label NAME COLOR DESCRIPTION — one line per label so the self-test
# can count and dry-run can print exactly what would execute.
make_label() {
  if $DRY_RUN; then
    printf 'gh label create %q --color %q --description %q --force %q %q\n' \
      "$1" "$2" "$3" "${REPO_ARGS[0]}" "${REPO_ARGS[1]}"
  else
    gh label create "$1" --color "$2" --description "$3" --force "${REPO_ARGS[@]}"
  fi
}

echo "Creating core labels on ${REPO_ARGS[1]}..."

# Status labels (drive automation)
make_label "status:planning"    "C2E0C6" "Task is in planning"
make_label "status:in-progress" "0075CA" "Actively being worked on"
make_label "status:done"        "0E8A16" "Task is complete"
make_label "status:blocked"     "B60205" "Task is blocked"

# Owner labels (who does the work)
make_label "owner:human"        "D93F0B" "Requires human action"
make_label "owner:agent"        "0E8A16" "Agent can complete autonomously"
make_label "owner:external"     "E99695" "Waiting on external party"

# Priority labels
make_label "priority:high"      "B60205" "High priority"
make_label "priority:medium"    "FBCA04" "Medium priority"
make_label "priority:low"       "006B75" "Low priority"

# Type labels
make_label "bug"                "D73A4A" "Something is broken"
make_label "enhancement"        "A2EEEF" "New feature or improvement"
make_label "task"               "E4E669" "Actionable work item"
make_label "roadmap"            "0052CC" "Future planning"
make_label "idea"               "C2E0C6" "Idea to explore"
make_label "decision"           "FBCA04" "Needs a decision"
make_label "documentation"      "0075CA" "Documentation changes"
make_label "dependencies"       "0366D6" "Dependency updates"
make_label "ci"                 "EDEDED" "CI/CD changes"

# Size labels (for PR size labeler)
make_label "size/xs"  "0E8A16" "Extra small PR (≤10 lines)"
make_label "size/s"   "0075CA" "Small PR (≤50 lines)"
make_label "size/m"   "FBCA04" "Medium PR (≤200 lines)"
make_label "size/l"   "D93F0B" "Large PR (≤500 lines)"
make_label "size/xl"  "B60205" "Extra large PR (>500 lines)"

# Workflow-required labels (detect-conflicts.yml, stale.yml depend on these)
make_label "needs-rebase" "D93F0B" "PR has merge conflicts and needs a rebase"
make_label "stale"        "795548" "No recent activity"

# Deferred label
make_label "deferred"  "CCCCCC" "Planned for future — not in current milestone"

if $DRY_RUN; then
  echo "Dry run complete — no labels were created."
else
  echo "Done. $(gh label list "${REPO_ARGS[@]}" --json name --jq 'length') labels total."
fi
