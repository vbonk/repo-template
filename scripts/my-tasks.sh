#!/usr/bin/env bash
# Quick filtered views of GitHub Issues
# Usage: ./scripts/my-tasks.sh [filter]
#   mine       Human tasks + blocked (default)
#   agent      Agent-completable tasks
#   high       High priority
#   blocked    Blocked issues
#   external   Waiting on external party
#   planning   In planning
#   progress   In progress
#   all        Everything open

set -euo pipefail

REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner' 2>/dev/null) || {
  echo "Error: not in a GitHub repo or gh not authenticated" >&2
  exit 1
}

FILTER=${1:-mine}

case "$FILTER" in
  high)      gh issue list --repo "$REPO" --label "priority:high" --limit 50 ;;
  agent)     gh issue list --repo "$REPO" --label "owner:agent" --limit 50 ;;
  blocked)   gh issue list --repo "$REPO" --label "status:blocked" --limit 50 ;;
  external)  gh issue list --repo "$REPO" --label "owner:external" --limit 50 ;;
  planning)  gh issue list --repo "$REPO" --label "status:planning" --limit 50 ;;
  progress)  gh issue list --repo "$REPO" --label "status:in-progress" --limit 50 ;;
  all)       gh issue list --repo "$REPO" --state open --limit 100 ;;
  mine|*)
    echo "=== YOUR TASKS (owner:human) ==="
    gh issue list --repo "$REPO" --label "owner:human" --limit 50
    echo ""
    echo "=== BLOCKED ==="
    gh issue list --repo "$REPO" --label "status:blocked" --limit 50
    ;;
esac

echo ""
TOTAL=$(gh issue list --repo "$REPO" --state open --limit 500 --json number --jq 'length' 2>/dev/null || echo "?")
echo "Total open: $TOTAL"
