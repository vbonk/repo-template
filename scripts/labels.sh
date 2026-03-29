#!/usr/bin/env bash
# Unified GitHub Issues — Core Label Setup
# Usage: ./labels.sh [--repo owner/repo]
# Creates/updates all core labels. Idempotent via --force.

set -euo pipefail

REPO="${1:---repo $(gh repo view --json nameWithOwner -q '.nameWithOwner')}"
if [[ "$1" == "--repo" ]]; then
  REPO="--repo $2"
fi

echo "Creating core labels on ${REPO}..."

# Status labels (drive automation)
gh label create "status:planning"    --color "C2E0C6" --description "Task is in planning"              --force "$REPO"
gh label create "status:in-progress" --color "0075CA" --description "Actively being worked on"         --force "$REPO"
gh label create "status:done"        --color "0E8A16" --description "Task is complete"                 --force "$REPO"
gh label create "status:blocked"     --color "B60205" --description "Task is blocked"                  --force "$REPO"

# Owner labels (who does the work)
gh label create "owner:human"        --color "D93F0B" --description "Requires human action"            --force "$REPO"
gh label create "owner:agent"        --color "0E8A16" --description "Agent can complete autonomously"  --force "$REPO"
gh label create "owner:external"     --color "E99695" --description "Waiting on external party"        --force "$REPO"

# Priority labels
gh label create "priority:high"      --color "B60205" --description "High priority"                    --force "$REPO"
gh label create "priority:medium"    --color "FBCA04" --description "Medium priority"                  --force "$REPO"
gh label create "priority:low"       --color "006B75" --description "Low priority"                     --force "$REPO"

# Type labels
gh label create "bug"                --color "D73A4A" --description "Something is broken"              --force "$REPO"
gh label create "enhancement"        --color "A2EEEF" --description "New feature or improvement"       --force "$REPO"
gh label create "task"               --color "E4E669" --description "Actionable work item"             --force "$REPO"
gh label create "roadmap"            --color "0052CC" --description "Future planning"                  --force "$REPO"
gh label create "idea"               --color "C2E0C6" --description "Idea to explore"                  --force "$REPO"
gh label create "decision"           --color "FBCA04" --description "Needs a decision"                 --force "$REPO"
gh label create "documentation"      --color "0075CA" --description "Documentation changes"            --force "$REPO"
gh label create "dependencies"       --color "0366D6" --description "Dependency updates"               --force "$REPO"
gh label create "ci"                 --color "EDEDED" --description "CI/CD changes"                    --force "$REPO"

# Size labels (for PR size labeler)
gh label create "size/xs"  --color "0E8A16" --description "Extra small PR (≤10 lines)"  --force "$REPO"
gh label create "size/s"   --color "0075CA" --description "Small PR (≤50 lines)"         --force "$REPO"
gh label create "size/m"   --color "FBCA04" --description "Medium PR (≤200 lines)"       --force "$REPO"
gh label create "size/l"   --color "D93F0B" --description "Large PR (≤500 lines)"        --force "$REPO"
gh label create "size/xl"  --color "B60205" --description "Extra large PR (>500 lines)"  --force "$REPO"

# Deferred label
gh label create "deferred"  --color "CCCCCC" --description "Planned for future — not in current milestone" --force "$REPO"

echo "Done. $(gh label list "$REPO" --json name --jq 'length') labels total."
