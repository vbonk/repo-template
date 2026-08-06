#!/usr/bin/env bash
# Close a GitHub issue with comment and status:done label
# Usage: ./scripts/close-issue.sh <issue-number> [comment]
# Example: ./scripts/close-issue.sh 23 "Fixed login redirect bug in commit abc123"

set -euo pipefail

# shellcheck source=_lib.sh
# shellcheck disable=SC1091
source "$(dirname "$0")/_lib.sh"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <issue-number> [comment]" >&2
  exit 1
fi

check_gh_repo

ISSUE=$1
COMMENT=${2:-""}

# Add status:done label — status labels are the documented source of truth,
# so a failure here must be VISIBLE, not swallowed (the issue still closes).
if ! gh issue edit "$ISSUE" --repo "$REPO" --add-label "status:done" 2>/dev/null; then
  echo "WARNING: could not add status:done to #$ISSUE (label missing? run scripts/labels.sh)" >&2
fi

# Remove other status labels (label simply not present is the normal case)
for lbl in "status:planning" "status:in-progress" "status:blocked"; do
  gh issue edit "$ISSUE" --repo "$REPO" --remove-label "$lbl" 2>/dev/null || true
done

# Close with optional comment
if [ -n "$COMMENT" ]; then
  gh issue close "$ISSUE" --repo "$REPO" --comment "$COMMENT"
else
  gh issue close "$ISSUE" --repo "$REPO"
fi

echo "Closed #$ISSUE on $REPO"
