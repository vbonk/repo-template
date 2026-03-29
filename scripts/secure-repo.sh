#!/usr/bin/env bash
# secure-repo.sh — Automated GitHub repository security hardening
# Usage: ./scripts/secure-repo.sh [--repo owner/repo] [--skip-wiki] [--skip-projects]
# If no --repo specified, auto-detects from git remote.
# Requires: gh CLI authenticated with admin access.
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

REPO=""
SKIP_WIKI=false
SKIP_PROJECTS=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --repo) REPO="$2"; shift 2 ;;
    --skip-wiki) SKIP_WIKI=true; shift ;;
    --skip-projects) SKIP_PROJECTS=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [[ -z "$REPO" ]]; then
  REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner' 2>/dev/null || true)
  if [[ -z "$REPO" ]]; then
    echo -e "${RED}Could not detect repository. Use --repo owner/repo${NC}"
    exit 1
  fi
fi

echo "============================================"
echo "  Repository Security Hardening"
echo "  Repo: $REPO"
echo "============================================"
echo ""

PASS=0
WARN=0
FAIL=0

run_check() {
  local name="$1"
  local cmd="$2"
  local on_fail="${3:-}"

  if eval "$cmd" >/dev/null 2>&1; then
    echo -e "  ${GREEN}[DONE]${NC} $name"
    PASS=$((PASS + 1))
  else
    if [[ -n "$on_fail" ]]; then
      echo -e "  ${YELLOW}[WARN]${NC} $name — $on_fail"
      WARN=$((WARN + 1))
    else
      echo -e "  ${RED}[FAIL]${NC} $name"
      FAIL=$((FAIL + 1))
    fi
  fi
}

# --- Dependabot Vulnerability Alerts ---
echo "Security Features:"
run_check "Dependabot vulnerability alerts" \
  "gh api -X PUT repos/$REPO/vulnerability-alerts" \
  "May require admin access or GitHub Advanced Security"

run_check "Automated security fixes" \
  "gh api -X PUT repos/$REPO/automated-security-fixes" \
  "May require admin access"

# --- Branch Protection ---
DEFAULT_BRANCH=$(gh repo view "$REPO" --json defaultBranchRef -q '.defaultBranchRef.name' 2>/dev/null || echo "main")
echo ""
echo "Branch Protection (${DEFAULT_BRANCH}):"
run_check "Block force-push and branch deletion" \
  "gh api -X PUT repos/$REPO/branches/$DEFAULT_BRANCH/protection --silent --input - <<'BPEOF'
{
  \"required_status_checks\": null,
  \"enforce_admins\": false,
  \"required_pull_request_reviews\": null,
  \"restrictions\": null,
  \"allow_force_pushes\": false,
  \"allow_deletions\": false
}
BPEOF" \
  "Branch protection may require Pro plan for private repos"

# --- Tag Protection ---
echo ""
echo "Tag Protection:"
run_check "Protect v* release tags" \
  "gh api repos/$REPO/tags/protection --method POST -f pattern='v*' --silent" \
  "Tag protection may already exist or require Pro plan"

# --- Repository Settings ---
echo ""
echo "Repository Settings:"
run_check "Enable delete-branch-on-merge" \
  "gh repo edit $REPO --delete-branch-on-merge"

if [[ "$SKIP_WIKI" != "true" ]]; then
  run_check "Disable Wiki" \
    "gh repo edit $REPO --enable-wiki=false"
fi

if [[ "$SKIP_PROJECTS" != "true" ]]; then
  run_check "Disable Projects" \
    "gh repo edit $REPO --enable-projects=false"
fi

# --- Actions Permissions ---
echo ""
echo "Actions Permissions:"
ACTIONS_INFO=$(gh api "repos/$REPO/actions/permissions" 2>/dev/null || echo '{}')
ACTIONS_ENABLED=$(echo "$ACTIONS_INFO" | python3 -c "import sys,json; print(json.load(sys.stdin).get('enabled', 'unknown'))" 2>/dev/null || echo "unknown")

if [[ "$ACTIONS_ENABLED" == "True" || "$ACTIONS_ENABLED" == "true" ]]; then
  echo -e "  ${GREEN}[INFO]${NC} Actions: enabled (SHA-pinning is the supply chain defense)"
else
  echo -e "  ${YELLOW}[INFO]${NC} Actions: $ACTIONS_ENABLED"
fi

# --- Default Actions Permissions ---
run_check "Set default Actions permissions to read" \
  "gh api -X PUT repos/$REPO/actions/permissions --input - <<'APEOF'
{\"default_workflow_permissions\": \"read\"}
APEOF" \
  "May require org-level override"

# --- Summary ---
echo ""
echo "============================================"
echo "  Results: ${GREEN}$PASS done${NC} | ${YELLOW}$WARN warnings${NC} | ${RED}$FAIL failed${NC}"
echo "============================================"
echo ""
echo "Next steps:"
echo "  1. Install pre-commit hooks: bash templates/hooks/setup-hooks.sh"
echo "  2. Set up commit signing (see docs/BRANCH-PROTECTION.md)"
echo "  3. Configure CodeQL language in .github/workflows/codeql.yml"
echo ""

if [[ $FAIL -gt 0 ]]; then
  exit 1
fi
exit 0
