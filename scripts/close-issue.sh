#!/usr/bin/env bash
# Close a GitHub issue with comment and status:done label
# Usage: ./scripts/close-issue.sh <issue-number> [comment]
# Example: ./scripts/close-issue.sh 23 "Fixed login redirect bug in commit abc123"

set -euo pipefail

# shellcheck source=_lib.sh
source "$(dirname "$0")/_lib.sh"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <issue-number> [comment]" >&2
  exit 1
fi

check_gh_repo

ISSUE=$1
COMMENT=${2:-""}

# Add status:done label
gh issue edit "$ISSUE" --repo "$REPO" --add-label "status:done" 2>/dev/null || true

# Remove other status labels
gh issue edit "$ISSUE" --repo "$REPO" --remove-label "status:planning" 2>/dev/null || true
gh issue edit "$ISSUE" --repo "$REPO" --remove-label "status:in-progress" 2>/dev/null || true
gh issue edit "$ISSUE" --repo "$REPO" --remove-label "status:blocked" 2>/dev/null || true

# Close with optional comment
if [ -n "$COMMENT" ]; then
  gh issue close "$ISSUE" --repo "$REPO" --comment "$COMMENT"
else
  gh issue close "$ISSUE" --repo "$REPO"
fi

echo "Closed #$ISSUE on $REPO"
