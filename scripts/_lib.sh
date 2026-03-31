#!/usr/bin/env bash
# _lib.sh — Shared utility functions for repo-template scripts
# Source this file: source "$(dirname "$0")/_lib.sh"
#
# Provides:
#   require_gh        — exit with remediation if gh CLI not found
#   check_gh_auth     — exit with remediation if gh not authenticated
#   check_gh_repo     — exit with remediation if not in a GitHub repo context
#   has_gh            — return 0 if gh is available and authed (no exit)
#   print_prereq_skip — print a standardized skip message

# Colors (only if terminal supports them)
if [[ -t 1 ]]; then
  _RED='\033[0;31m'
  _GREEN='\033[0;32m'
  _YELLOW='\033[0;33m'
  _CYAN='\033[0;36m'
  _NC='\033[0m'
else
  _RED='' _GREEN='' _YELLOW='' _CYAN='' _NC=''
fi

# Check if gh CLI is installed. Exits with remediation if not.
require_gh() {
  if ! command -v gh &>/dev/null; then
    echo -e "${_RED}Error: GitHub CLI (gh) is not installed.${_NC}" >&2
    echo "" >&2
    echo "  Install it:" >&2
    echo "    macOS:   brew install gh" >&2
    echo "    Linux:   https://github.com/cli/cli/blob/trunk/docs/install_linux.md" >&2
    echo "    Windows: winget install GitHub.cli" >&2
    echo "" >&2
    echo "  Then authenticate: gh auth login" >&2
    exit 1
  fi
}

# Check if gh is authenticated. Exits with remediation if not.
check_gh_auth() {
  require_gh
  if ! gh auth status &>/dev/null; then
    echo -e "${_RED}Error: GitHub CLI is not authenticated.${_NC}" >&2
    echo "" >&2
    echo "  Run: gh auth login" >&2
    echo "  Then retry this command." >&2
    exit 1
  fi
}

# Check if we're in a GitHub repo context. Exits with remediation if not.
# Sets REPO variable to owner/repo if successful.
check_gh_repo() {
  check_gh_auth
  REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner' 2>/dev/null || true)
  if [[ -z "$REPO" ]]; then
    echo -e "${_RED}Error: Not in a GitHub repository, or repository not found on GitHub.${_NC}" >&2
    echo "" >&2
    echo "  Make sure you're in a git repo with a GitHub remote:" >&2
    echo "    git remote -v" >&2
    echo "" >&2
    echo "  Or specify the repo explicitly:" >&2
    echo "    $0 --repo owner/repo" >&2
    exit 1
  fi
  export REPO
}

# Non-fatal check: returns 0 if gh is available and authenticated, 1 otherwise.
# Use this for optional gh-dependent checks that should skip gracefully.
has_gh() {
  command -v gh &>/dev/null && gh auth status &>/dev/null
}

# Print a standardized skip message for gh-dependent checks.
# Usage: print_prereq_skip "feature name" "what's needed"
print_prereq_skip() {
  local feature="$1"
  local prereq="${2:-gh CLI}"
  echo -e "${_YELLOW}SKIP${_NC}  $feature (requires $prereq)" >&2
}
