#!/usr/bin/env bash
# secure-repo.sh — Automated GitHub repository security hardening
# Usage: ./scripts/secure-repo.sh [--audit] [--repo owner/repo] [--skip-wiki] [--skip-projects]
#   --audit  Read-only mode: reports current security posture and the exact
#            command each fix would run. Makes ZERO changes (GET requests only).
#   (no flag) Applies hardening (PUT/POST/PATCH mutations).
# If no --repo specified, auto-detects from git remote.
# Requires: gh CLI authenticated (admin access needed for hardening mode).
set -euo pipefail

# shellcheck source=_lib.sh
# shellcheck disable=SC1091
source "$(dirname "$0")/_lib.sh"

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

REPO=""
SKIP_WIKI=false
SKIP_PROJECTS=false
AUDIT=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --audit) AUDIT=true; shift ;;
    --repo)
      # Validate strictly: REPO is interpolated into eval'd commands below,
      # so a metacharacter-bearing value would execute under your gh auth.
      if [[ ! "${2:-}" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]]; then
        echo "Error: --repo must be owner/repo" >&2
        exit 1
      fi
      REPO="$2"; shift 2 ;;
    --skip-wiki) SKIP_WIKI=true; shift ;;
    --skip-projects) SKIP_PROJECTS=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [[ -z "$REPO" ]]; then
  check_gh_repo
fi

echo "============================================"
if $AUDIT; then
  echo "  Repository Security Audit (read-only)"
else
  echo "  Repository Security Hardening"
fi
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

# audit_check: READ-ONLY posture check. $2 must be a GET/read command that
# succeeds only when the protection is configured. $3 is the remediation.
audit_check() {
  local name="$1" cmd="$2" fix="$3"
  if eval "$cmd" >/dev/null 2>&1; then
    echo -e "  ${GREEN}[PASS]${NC} $name"
    PASS=$((PASS + 1))
  else
    echo -e "  ${YELLOW}[WARN]${NC} $name — not configured"
    echo "         Fix: $fix"
    WARN=$((WARN + 1))
  fi
}

DEFAULT_BRANCH=$(gh repo view "$REPO" --json defaultBranchRef -q '.defaultBranchRef.name' 2>/dev/null || echo "main")

if $AUDIT; then
  # ---------- READ-ONLY AUDIT (GET requests only, zero mutations) ----------
  echo "Security Features:"
  audit_check "Dependabot vulnerability alerts" \
    "gh api repos/$REPO/vulnerability-alerts" \
    "bash scripts/secure-repo.sh   (hardening mode)"
  audit_check "Automated security fixes" \
    "gh api repos/$REPO/automated-security-fixes --jq '.enabled' | grep -q true" \
    "bash scripts/secure-repo.sh"

  echo ""
  echo "Branch Protection (${DEFAULT_BRANCH}):"
  audit_check "Force-push blocked" \
    "gh api repos/$REPO/rules/branches/$DEFAULT_BRANCH --jq '[.[].type]' | grep -q non_fast_forward" \
    "bash scripts/secure-repo.sh, or see docs/BRANCH-PROTECTION.md for rulesets"
  audit_check "Branch deletion blocked" \
    "gh api repos/$REPO/rules/branches/$DEFAULT_BRANCH --jq '[.[].type]' | grep -q '\"deletion\"'" \
    "bash scripts/secure-repo.sh"
  audit_check "Required status checks" \
    "gh api repos/$REPO/rules/branches/$DEFAULT_BRANCH --jq '[.[].type]' | grep -q required_status_checks" \
    "see docs/BRANCH-PROTECTION.md (ruleset recipe with your CI job names)"

  echo ""
  echo "Tag Protection:"
  audit_check "v* tag ruleset active" \
    "gh api repos/$REPO/rulesets --jq '[.[] | select(.target==\"tag\" and .enforcement==\"active\")] | length' | grep -qv '^0$'" \
    "see docs/BRANCH-PROTECTION.md §Protected Tags"

  echo ""
  echo "Repository Settings:"
  audit_check "Delete-branch-on-merge enabled" \
    "gh api repos/$REPO --jq '.delete_branch_on_merge' | grep -q true" \
    "gh repo edit $REPO --delete-branch-on-merge"
  audit_check "Wiki disabled" \
    "gh api repos/$REPO --jq '.has_wiki' | grep -q false" \
    "gh repo edit $REPO --enable-wiki=false   (skip if you use the wiki)"
  audit_check "Projects disabled" \
    "gh api repos/$REPO --jq '.has_projects' | grep -q false" \
    "gh repo edit $REPO --enable-projects=false   (skip if you use Projects)"

  echo ""
  echo "Actions Permissions:"
  audit_check "Default workflow permissions: read" \
    "gh api repos/$REPO/actions/permissions/workflow --jq '.default_workflow_permissions' | grep -q read" \
    "bash scripts/secure-repo.sh"

  echo ""
  echo "Platform Hardening (2025-26 features):"
  audit_check "Auto-merge enabled" \
    "gh api repos/$REPO --jq '.allow_auto_merge' | grep -q true" \
    "bash scripts/secure-repo.sh"
  audit_check "Actions SHA-pinning platform-enforced" \
    "gh api repos/$REPO/actions/permissions --jq '.sha_pinning_required' | grep -q true" \
    "bash scripts/secure-repo.sh"
  audit_check "Immutable releases" \
    "gh api repos/$REPO/immutable-releases --jq '.enabled' | grep -q true" \
    "bash scripts/secure-repo.sh"
  audit_check "Secret-scanning validity checks (plan-gated: Secret Protection add-on)" \
    "gh api repos/$REPO --jq '.security_and_analysis.secret_scanning_validity_checks.status' | grep -q enabled" \
    "requires GitHub Secret Protection; scanning + push protection work without it"
else
  # ---------- HARDENING (mutations) ----------
  # --- Dependabot Vulnerability Alerts ---
  echo "Security Features:"
  run_check "Dependabot vulnerability alerts" \
    "gh api -X PUT repos/$REPO/vulnerability-alerts" \
    "May require admin access or GitHub Advanced Security"

  run_check "Automated security fixes" \
    "gh api -X PUT repos/$REPO/automated-security-fixes" \
    "May require admin access"

  # --- Branch Protection (rulesets — GitHub's current mechanism) ---
  # create-or-update by ruleset NAME so re-runs are idempotent.
  # shellcheck disable=SC2329  # invoked indirectly via run_check eval
  upsert_ruleset() {
    local name="$1" payload="$2" existing_id
    existing_id=$(gh api "repos/$REPO/rulesets" --jq \
      ".[] | select(.name == \"$name\") | .id" 2>/dev/null | head -1)
    if [[ -n "$existing_id" ]]; then
      printf '%s' "$payload" | gh api -X PUT "repos/$REPO/rulesets/$existing_id" --input - --silent
    else
      printf '%s' "$payload" | gh api -X POST "repos/$REPO/rulesets" --input - --silent
    fi
  }

  # shellcheck disable=SC2329  # invoked indirectly via run_check eval
  harden_main_ruleset() {
    # Required status checks default to this template's CI job names; adjust
    # the contexts below to YOUR job names after enabling your stack.
    upsert_ruleset "Protect Main" '{
      "name": "Protect Main",
      "target": "branch",
      "enforcement": "active",
      "conditions": { "ref_name": { "include": ["~DEFAULT_BRANCH"], "exclude": [] } },
      "rules": [
        { "type": "deletion" },
        { "type": "non_fast_forward" },
        { "type": "required_status_checks",
          "parameters": { "strict_required_status_checks_policy": false,
            "required_status_checks": [ { "context": "build" }, { "context": "validate" } ] } }
      ],
      "bypass_actors": [ { "actor_id": 5, "actor_type": "RepositoryRole", "bypass_mode": "pull_request" } ]
    }'
  }

  # shellcheck disable=SC2329  # invoked indirectly via run_check eval
  harden_tag_ruleset() {
    upsert_ruleset "Protect Release Tags" '{
      "name": "Protect Release Tags",
      "target": "tag",
      "enforcement": "active",
      "conditions": { "ref_name": { "include": ["refs/tags/v*"], "exclude": [] } },
      "rules": [ { "type": "deletion" }, { "type": "non_fast_forward" }, { "type": "update" } ],
      "bypass_actors": []
    }'
  }

  echo ""
  echo "Branch Protection (${DEFAULT_BRANCH}):"
  run_check "Ruleset: block force-push/deletion + require status checks (build, validate)" \
    "harden_main_ruleset" \
    "Rulesets may require Pro plan for private repos; see docs/BRANCH-PROTECTION.md"
  echo -e "  ${YELLOW}[NOTE]${NC} Required check contexts default to 'build' and 'validate' — edit harden_main_ruleset in this script if your CI job names differ"

  echo ""
  echo "Tag Protection:"
  run_check "Ruleset: protect v* release tags (no delete/move/update)" \
    "harden_tag_ruleset" \
    "Tag rulesets may require Pro plan for private repos"

  # --- 2025-26 platform hardening ---
  echo ""
  echo "Platform Hardening:"
  run_check "Auto-merge enabled (pairs with required checks for gated Dependabot merges)" \
    "gh api -X PATCH repos/$REPO -F allow_auto_merge=true --silent"

  run_check "Actions SHA-pinning required (platform-enforced)" \
    "gh api -X PUT repos/$REPO/actions/permissions --input - <<'SPEOF'
{\"enabled\": true, \"allowed_actions\": \"all\", \"sha_pinning_required\": true}
SPEOF" \
    "Requires admin; older GHES versions lack this policy"

  run_check "Immutable releases (assets and tags locked after publish)" \
    "gh api -X PUT repos/$REPO/immutable-releases --silent" \
    "Requires admin access"

  run_check "Secret-scanning validity checks" \
    "gh api -X PATCH repos/$REPO --silent --input - <<'VCEOF'
{\"security_and_analysis\": {\"secret_scanning_validity_checks\": {\"status\": \"enabled\"}}}
VCEOF
     gh api repos/$REPO --jq '.security_and_analysis.secret_scanning_validity_checks.status' | grep -q enabled" \
    "Plan-gated: needs GitHub Secret Protection (paid add-on) — scanning + push protection remain active without it"

  run_check "Secret-scanning non-provider patterns" \
    "gh api -X PATCH repos/$REPO --silent --input - <<'NPEOF'
{\"security_and_analysis\": {\"secret_scanning_non_provider_patterns\": {\"status\": \"enabled\"}}}
NPEOF
     gh api repos/$REPO --jq '.security_and_analysis.secret_scanning_non_provider_patterns.status' | grep -q enabled" \
    "Plan-gated: needs GitHub Secret Protection (paid add-on)"

  echo -e "  ${YELLOW}[NOTE]${NC} Push rulesets (server-side path blocks for .env/.pem/keys) are org-owned-repo only — if this repo moves to an org, add one; see docs/BRANCH-PROTECTION.md"

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
  # NOTE: this is the /workflow sub-endpoint. The parent /actions/permissions
  # endpoint doesn't own this field — and PUTting the parent here would clobber
  # sha_pinning_required set above.
  run_check "Set default Actions permissions to read" \
    "gh api -X PUT repos/$REPO/actions/permissions/workflow --input - <<'APEOF'
{\"default_workflow_permissions\": \"read\"}
APEOF" \
    "May require org-level override"
fi

# --- Local Protections Check (read-only) ---
echo ""
echo "Local Protections:"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"

if [[ -x "$REPO_ROOT/.git/hooks/pre-commit" ]]; then
  echo -e "  ${GREEN}[PASS]${NC} Pre-commit hook installed"
  PASS=$((PASS + 1))
else
  echo -e "  ${YELLOW}[WARN]${NC} No pre-commit hook — run: bash templates/hooks/setup-hooks.sh"
  WARN=$((WARN + 1))
fi

if [[ -f "$REPO_ROOT/.git/hooks/forbidden-tokens.txt" ]]; then
  TOKEN_COUNT=$(grep -cv '^[[:space:]]*#\|^[[:space:]]*$' "$REPO_ROOT/.git/hooks/forbidden-tokens.txt" 2>/dev/null || echo 0)
  echo -e "  ${GREEN}[PASS]${NC} Forbidden tokens file ($TOKEN_COUNT tokens)"
  PASS=$((PASS + 1))
else
  echo -e "  ${YELLOW}[WARN]${NC} No forbidden-tokens.txt — run: bash templates/hooks/setup-hooks.sh"
  WARN=$((WARN + 1))
fi

if [[ -f "$REPO_ROOT/.gitattributes" ]]; then
  echo -e "  ${GREEN}[PASS]${NC} .gitattributes present"
  PASS=$((PASS + 1))
else
  echo -e "  ${YELLOW}[WARN]${NC} No .gitattributes"
  WARN=$((WARN + 1))
fi

SIGNING=$(git config --get commit.gpgsign 2>/dev/null || echo "false")
if [[ "$SIGNING" == "true" ]]; then
  echo -e "  ${GREEN}[PASS]${NC} Commit signing enabled"
  PASS=$((PASS + 1))
else
  echo -e "  ${YELLOW}[WARN]${NC} Commit signing not configured (see docs/BRANCH-PROTECTION.md)"
  WARN=$((WARN + 1))
fi

# --- Scorecard ---
if [[ $FAIL -eq 0 && $WARN -eq 0 ]]; then
  GRADE="A+"
elif [[ $FAIL -eq 0 && $WARN -le 2 ]]; then
  GRADE="A"
elif [[ $FAIL -eq 0 ]]; then
  GRADE="B"
elif [[ $FAIL -le 1 ]]; then
  GRADE="C"
else
  GRADE="D"
fi

echo ""
echo "============================================"
echo -e "  SECURITY SCORECARD: $GRADE"
echo -e "  ${GREEN}$PASS pass${NC} | ${YELLOW}$WARN warn${NC} | ${RED}$FAIL fail${NC}"
echo "============================================"

if [[ $WARN -gt 0 || $FAIL -gt 0 ]]; then
  echo ""
  echo "Next steps:"
  [[ ! -x "$REPO_ROOT/.git/hooks/pre-commit" ]] && echo "  - Install hooks: bash templates/hooks/setup-hooks.sh"
  [[ "$SIGNING" != "true" ]] && echo "  - Set up commit signing: see docs/BRANCH-PROTECTION.md"
  echo "  - Enable CodeQL (recommended: default setup): gh api -X PATCH repos/OWNER/REPO/code-scanning/default-setup -f state=configured"
fi
echo ""

if [[ $FAIL -gt 0 ]]; then
  exit 1
fi
exit 0
