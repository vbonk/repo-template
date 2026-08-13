#!/usr/bin/env bash
# test-e2e.sh — End-to-end template validation (Layer 5)
# Usage: bash scripts/test-e2e.sh [--keep] [--skip-cleanup]
#
# Creates one real repository from repo-template, verifies the first-agent,
# provenance, reconciliation, and security contracts, then deletes it on success.
# Requires: gh CLI authenticated with repo create/delete permissions.
set -uo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

PASS=0
FAIL=0
WARN=0
KEEP=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --keep) KEEP=true; shift ;;
    --skip-cleanup) KEEP=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

OWNER=$(gh api user --jq '.login' 2>/dev/null)
if [[ -z "$OWNER" ]]; then
  echo -e "${RED}ERROR: gh CLI not authenticated${NC}"
  exit 1
fi

TEMPLATE_REPO="$OWNER/repo-template"
TIMESTAMP=$(date +%s)
TEST_REPO="${OWNER}/e2e-test-template-${TIMESTAMP}"
REPO_NAME="e2e-test-template-${TIMESTAMP}"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
WORK_DIR=$(mktemp -d)

REPOS_TO_DELETE=()
DIRS_TO_DELETE=("$WORK_DIR")

# shellcheck disable=SC2317,SC2329
cleanup() {
  if $KEEP; then
    echo ""
    echo -e "${YELLOW}--keep flag set. Preserving test resources:${NC}"
    for r in "${REPOS_TO_DELETE[@]}"; do
      echo "  https://github.com/$r"
    done
    echo "  Local: $WORK_DIR"
    return
  fi

  echo ""
  echo "Cleaning up..."
  for r in "${REPOS_TO_DELETE[@]}"; do
    gh repo delete "$r" --yes 2>/dev/null && echo "  Deleted: $r" || echo "  Failed to delete: $r"
  done
  for d in "${DIRS_TO_DELETE[@]}"; do
    rm -rf "$d" 2>/dev/null
  done
}
trap cleanup EXIT

pass() { echo -e "  ${GREEN}PASS${NC}  $1"; PASS=$((PASS + 1)); }
fail() { echo -e "  ${RED}FAIL${NC}  $1"; FAIL=$((FAIL + 1)); }
warn() { echo -e "  ${YELLOW}WARN${NC}  $1"; WARN=$((WARN + 1)); }
header() { echo ""; echo -e "${CYAN}=== $1 ===${NC}"; }

echo ""
echo "============================================"
echo "  repo-template E2E Test Suite (Layer 5)"
echo "  Owner: $OWNER"
echo "  Template: $TEMPLATE_REPO"
echo "  Work dir: $WORK_DIR"
echo "  $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "============================================"

# ============================================================
# TEST 5.1: Create from Template → First-Agent Contract
# ============================================================
header "5.1: Create from Template — First-Agent Contract"

echo "  Creating repository from template..."
if gh repo create "$TEST_REPO" --template "$TEMPLATE_REPO" --public >/dev/null 2>&1 && \
   sleep 3 && \
   git clone "https://github.com/$TEST_REPO.git" "$WORK_DIR/$REPO_NAME" >/dev/null 2>&1; then
  pass "Repository created from template: $TEST_REPO"
  REPOS_TO_DELETE+=("$TEST_REPO")
else
  fail "Failed to create repository from template"
  TEST_REPO_SKIP=true
fi

if [[ "${TEST_REPO_SKIP:-}" != "true" ]]; then
  cd "$WORK_DIR/$REPO_NAME" || { fail "Failed to enter cloned repository"; exit 1; }

  essential_ok=true
  for f in README.md CLAUDE.md AGENTS.md .repo-template.yaml \
           docs/PHASE-0.md docs/TEMPLATE-UPGRADE.md \
           .claude/commands/bootstrap.md .claude/commands/upgrade-template.md \
           .gitattributes .gitignore scripts/secure-repo.sh \
           templates/hooks/setup-hooks.sh templates/hooks/pre-commit-secrets.sh.template; do
    if [[ ! -f "$f" ]]; then
      fail "Missing after template creation: $f"
      essential_ok=false
    fi
  done
  if $essential_ok; then
    pass "First-agent, provenance, reconciliation, and security files transfer"
  fi

  if grep -q 'Derived-repository mode' CLAUDE.md && \
     grep -q 'Derived-repository mode' AGENTS.md; then
    pass "Claude and Codex entry files detect derived-repository mode"
  else
    fail "Derived-repository mode missing from agent entry files"
  fi

  if grep -q 'KEEP / ADAPT / REMOVE / DEFER' docs/PHASE-0.md && \
     grep -q 'Current-session context is project input' docs/PHASE-0.md; then
    pass "Phase 0 carries classification and session-intake contracts"
  else
    fail "Phase 0 contract is incomplete"
  fi

  if grep -q '^baseline_id: agent-native-phase0-v1$' .repo-template.yaml && \
     grep -q 'strategy: semantic-reconciliation' .repo-template.yaml; then
    pass "Template provenance marker carries the current reconciliation baseline"
  else
    fail "Template provenance marker is missing or incorrect"
  fi

  if grep -q 'three-way model' docs/TEMPLATE-UPGRADE.md && \
     grep -q 'docs/TEMPLATE-UPGRADE.md' .claude/commands/upgrade-template.md; then
    pass "Template upgrade guidance and Claude entrypoint transfer"
  else
    fail "Template upgrade reconciliation contract is incomplete"
  fi

  if grep -q 'docs/PHASE-0.md' .claude/commands/bootstrap.md && \
     grep -q 'docs/PHASE-0.md' .claude/commands/init-template.md && \
     ! grep -qE 'Quick setup|Gather Project Information|Ask for project name' .claude/commands/init-template.md; then
    pass "Bootstrap is canonical and legacy initializer is compatibility-only"
  else
    fail "Legacy interactive initializer behavior is still active"
  fi

  if grep -qE 'Client.*API Server|npm run dev|DATABASE_URL|NODE_ENV|Production.*main branch' \
      CLAUDE.md AGENTS.md .env.example; then
    fail "Speculative application defaults exist in first-agent surfaces"
  else
    pass "First-agent surfaces remain stack- and architecture-neutral"
  fi

  if [[ ! -f .git/hooks/pre-commit ]]; then
    pass "Local hooks correctly do not transfer through GitHub templates"
  else
    warn "Unexpected pre-commit hook exists in fresh clone"
  fi

  cd "$REPO_ROOT" || exit 1
fi

# ============================================================
# TEST 5.2: Security Baseline on a Fresh Derived Repository
# ============================================================
header "5.2: Security Baseline"

if [[ "${TEST_REPO_SKIP:-}" != "true" ]]; then
  cd "$WORK_DIR/$REPO_NAME" || exit 1

  echo "  Running secure-repo.sh..."
  secure_output=$(bash scripts/secure-repo.sh 2>&1) || true
  if echo "$secure_output" | grep -q 'SCORECARD'; then
    pass "secure-repo.sh produces a scorecard on a fresh derived repo"
  else
    fail "secure-repo.sh did not produce a scorecard"
  fi

  echo "  Running setup-hooks.sh..."
  if bash templates/hooks/setup-hooks.sh >/dev/null 2>&1 && [[ -x .git/hooks/pre-commit ]]; then
    pass "setup-hooks.sh installs an executable pre-commit hook"
  else
    fail "setup-hooks.sh did not install a working pre-commit hook"
  fi

  echo "const key = 'sk-ant-e2etest123456789';" > test-e2e-secret.js
  git add -f test-e2e-secret.js >/dev/null 2>&1
  if bash .git/hooks/pre-commit >/dev/null 2>&1; then
    fail "Pre-commit hook should block the secret fixture"
  else
    pass "Pre-commit hook blocks the secret fixture"
  fi
  git reset HEAD test-e2e-secret.js >/dev/null 2>&1
  rm -f test-e2e-secret.js

  echo "const hello = 'world';" > test-e2e-clean.js
  git add -f test-e2e-clean.js >/dev/null 2>&1
  if bash .git/hooks/pre-commit >/dev/null 2>&1; then
    pass "Pre-commit hook allows a clean fixture"
  else
    fail "Pre-commit hook incorrectly blocked a clean fixture"
  fi
  git reset HEAD test-e2e-clean.js >/dev/null 2>&1
  rm -f test-e2e-clean.js

  labels_output=$(bash scripts/labels.sh 2>&1) || true
  if echo "$labels_output" | grep -qi 'label'; then
    pass "labels.sh remains usable before project intake"
  else
    warn "labels.sh produced no recognizable output"
  fi

  cd "$REPO_ROOT" || exit 1
fi

# ============================================================
# TEST 5.3: Template Truthfulness Before Project Intake
# ============================================================
header "5.3: Pre-Intake Truthfulness"

if [[ "${TEST_REPO_SKIP:-}" != "true" ]]; then
  cd "$WORK_DIR/$REPO_NAME" || exit 1

  if grep -q 'The Golden Path' README.md && \
     grep -q 'Agent inside a repository created from this template' README.md; then
    pass "README identifies the derived-repository golden path"
  else
    fail "README does not expose the first-agent golden path"
  fi

  if grep -q 'repo-template source' docs/ARCHITECTURE.md && \
     ! grep -q 'Client.*API Server' docs/ARCHITECTURE.md; then
    pass "Architecture document describes the template, not a fictitious app"
  else
    fail "Architecture document contains misleading application architecture"
  fi

  if grep -q 'intentionally empty' .env.example && \
     ! grep -qE 'DATABASE_URL|API_KEY|NODE_ENV|PORT=' .env.example; then
    pass ".env.example is intentionally stack-neutral"
  else
    fail ".env.example implies project-specific variables before intake"
  fi

  cd "$REPO_ROOT" || exit 1
fi

# ============================================================
# TEST 5.4: Template Baseline Compatibility
# ============================================================
header "5.4: Template Baseline Compatibility"

if [[ "${TEST_REPO_SKIP:-}" != "true" ]]; then
  cd "$WORK_DIR/$REPO_NAME" || exit 1

  local_baseline=$(awk -F': *' '$1 == "baseline_id" {print $2; exit}' .repo-template.yaml)
  template_baseline=$(gh api -H 'Accept: application/vnd.github.raw+json' \
    "repos/$TEMPLATE_REPO/contents/.repo-template.yaml" 2>/dev/null | \
    awk -F': *' '$1 == "baseline_id" {print $2; exit}')

  if [[ -n "$local_baseline" && "$local_baseline" = "$template_baseline" ]]; then
    pass "Fresh derived repository records the current template baseline"
  else
    fail "Fresh derived repository baseline does not match the source template"
  fi

  if grep -q 'Template baseline is current' .github/workflows/check-template-drift.yml && \
     ! grep -q 'git hash-object' .github/workflows/check-template-drift.yml; then
    pass "Compatibility workflow checks baseline provenance, not exact project file hashes"
  else
    fail "Compatibility workflow still assumes downstream files should match the template"
  fi

  cd "$REPO_ROOT" || exit 1
fi

# ============================================================
# TEST 5.5: Cross-Repo Compliance Audit
# ============================================================
header "5.5: Cross-Repo Compliance Audit"

echo "  Auditing $OWNER/repo-template-example..."
audit_output=$(bash scripts/audit-compliance.sh "$OWNER/repo-template-example" 2>/dev/null) || true

if echo "$audit_output" | python3 -c "
import sys, json
d = json.load(sys.stdin)
r = d['repos'][0]
score = r['compliance_score']
grade = r['grade']
print(f'  Score: {score}% ({grade})')
sys.exit(0 if score >= 70 else 1)
" 2>/dev/null; then
  pass "repo-template-example compliance score is at least 70%"
else
  example_exists=$(gh repo view "$OWNER/repo-template-example" --json name 2>/dev/null || echo "")
  if [[ -z "$example_exists" ]]; then
    warn "repo-template-example does not exist (skipping)"
  else
    fail "repo-template-example scored below 70%"
  fi
fi

echo "  Auditing $TEMPLATE_REPO (self)..."
self_output=$(bash scripts/audit-compliance.sh "$TEMPLATE_REPO" 2>/dev/null) || true

if echo "$self_output" | python3 -c "
import sys, json
d = json.load(sys.stdin)
r = d['repos'][0]
score = r['compliance_score']
grade = r['grade']
print(f'  Score: {score}% ({grade})')
sys.exit(0 if score >= 95 else 1)
" 2>/dev/null; then
  pass "repo-template self-audit is at least 95%"
else
  warn "repo-template self-audit is below 95%"
fi

# ============================================================
# SUMMARY
# ============================================================

echo ""
echo "============================================"
TOTAL=$((PASS + FAIL + WARN))
echo -e "  Results: ${GREEN}$PASS pass${NC} | ${RED}$FAIL fail${NC} | ${YELLOW}$WARN warn${NC}"
echo "  Total: $TOTAL checks"

if [[ $FAIL -eq 0 ]]; then
  echo -e "  ${GREEN}ALL E2E TESTS PASSED${NC}"
else
  echo -e "  ${RED}$FAIL FAILURE(S)${NC}"
fi
echo "============================================"
echo ""

exit "$FAIL"
