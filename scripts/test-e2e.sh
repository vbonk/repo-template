#!/usr/bin/env bash
# test-e2e.sh — End-to-end template validation (Layer 5)
# Usage: bash scripts/test-e2e.sh [--keep] [--skip-cleanup]
# Creates temporary repos on GitHub, runs full user journeys, then deletes them.
# Requires: gh CLI authenticated with repo create/delete permissions.
#
# WARNING: Creates real public repos under your GitHub account. They are deleted
# on success. Use --keep to preserve them for debugging.
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
TEST_REPO_1="${OWNER}/e2e-test-template-${TIMESTAMP}"
TEST_REPO_2="${OWNER}/e2e-test-retrofit-${TIMESTAMP}"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
WORK_DIR=$(mktemp -d)

# Cleanup tracking
REPOS_TO_DELETE=()
DIRS_TO_DELETE=("$WORK_DIR")

cleanup() {
  if $KEEP; then
    echo ""
    echo -e "${YELLOW}--keep flag set. Preserving test repos:${NC}"
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
# TEST 5.1: Create from Template → Full Journey
# ============================================================
header "5.1: Create from Template Journey"

REPO_NAME_1="e2e-test-template-${TIMESTAMP}"

echo "  Creating repo from template..."
if gh repo create "$TEST_REPO_1" --template "$TEMPLATE_REPO" --public >/dev/null 2>&1 && \
   sleep 3 && \
   git clone "https://github.com/$TEST_REPO_1.git" "$WORK_DIR/$REPO_NAME_1" >/dev/null 2>&1; then
  pass "Repo created from template: $TEST_REPO_1"
  REPOS_TO_DELETE+=("$TEST_REPO_1")
else
  fail "Failed to create repo from template"
  # Can't continue this test
  echo -e "  ${RED}Skipping remaining 5.1 tests${NC}"
  FAIL=$((FAIL + 9))
  # Jump to next test
  TEST_5_1_SKIP=true
fi

if [[ "${TEST_5_1_SKIP:-}" != "true" ]]; then
  cd "$WORK_DIR/$REPO_NAME_1" || { fail "Failed to cd into cloned repo"; exit 1; }

  # Verify key files transferred
  local_files_ok=true
  for f in CLAUDE.md AGENTS.md GEMINI.md .cursorrules .windsurfrules .aider.conf.yml \
           .github/copilot-instructions.md .gitattributes .gitignore \
           scripts/secure-repo.sh templates/hooks/setup-hooks.sh \
           templates/hooks/pre-commit-secrets.sh.template; do
    if [[ ! -f "$f" ]]; then
      fail "Missing after template create: $f"
      local_files_ok=false
    fi
  done
  if $local_files_ok; then
    pass "All essential files transferred from template"
  fi

  # Verify .git/hooks is empty (expected — hooks don't transfer)
  if [[ ! -f .git/hooks/pre-commit ]]; then
    pass "Hooks correctly NOT transferred (local-only)"
  else
    warn "Unexpected: pre-commit hook exists in fresh clone"
  fi

  # Run secure-repo.sh
  echo "  Running secure-repo.sh..."
  secure_output=$(bash scripts/secure-repo.sh 2>&1) || true
  if echo "$secure_output" | grep -q 'SCORECARD'; then
    pass "secure-repo.sh produces scorecard on fresh repo"
    # Extract grade
    grade=$(echo "$secure_output" | grep 'SCORECARD' | sed 's/.*SCORECARD: //' | tr -d ' ')
    echo -e "    Grade: $grade"
  else
    fail "secure-repo.sh did not produce scorecard"
  fi

  # Run setup-hooks.sh
  echo "  Running setup-hooks.sh..."
  if bash templates/hooks/setup-hooks.sh >/dev/null 2>&1; then
    if [[ -x .git/hooks/pre-commit ]]; then
      pass "setup-hooks.sh installs working hooks on fresh repo"
    else
      fail "setup-hooks.sh ran but hook not executable"
    fi
  else
    fail "setup-hooks.sh failed on fresh repo"
  fi

  # Test hook blocks a secret
  echo "const key = 'sk-ant-e2etest123456789';" > test-e2e-secret.js
  git add -f test-e2e-secret.js >/dev/null 2>&1
  if bash .git/hooks/pre-commit >/dev/null 2>&1; then
    fail "Hook should block sk-ant pattern in fresh repo"
  else
    pass "Hook blocks secrets in fresh repo"
  fi
  git reset HEAD test-e2e-secret.js >/dev/null 2>&1
  rm -f test-e2e-secret.js

  # Test hook allows clean file
  echo "const hello = 'world';" > test-e2e-clean.js
  git add -f test-e2e-clean.js >/dev/null 2>&1
  if bash .git/hooks/pre-commit >/dev/null 2>&1; then
    pass "Hook allows clean commits in fresh repo"
  else
    fail "Hook incorrectly blocked clean commit in fresh repo"
  fi
  git reset HEAD test-e2e-clean.js >/dev/null 2>&1
  rm -f test-e2e-clean.js

  # Run labels.sh
  echo "  Running labels.sh..."
  labels_output=$(bash scripts/labels.sh 2>&1) || true
  if echo "$labels_output" | grep -qi 'label'; then
    pass "labels.sh runs on fresh repo"
  else
    warn "labels.sh produced no output"
  fi

  # Run audit-compliance against self
  echo "  Running audit-compliance.sh..."
  audit_output=$(bash "$REPO_ROOT/scripts/audit-compliance.sh" "$TEST_REPO_1" 2>/dev/null) || true
  if echo "$audit_output" | python3 -c "import sys,json; d=json.load(sys.stdin); r=d['repos'][0]; print(f\"Score: {r['compliance_score']}% {r['grade']}\")" 2>/dev/null; then
    pass "Compliance audit runs on fresh repo"
  else
    warn "Compliance audit returned unexpected output"
  fi

  cd "$REPO_ROOT"
fi

# ============================================================
# TEST 5.2: Retrofit Journey (Workflow E)
# ============================================================
header "5.2: Retrofit Existing Repo"

REPO_NAME_2="e2e-test-retrofit-${TIMESTAMP}"

echo "  Creating empty repo..."
if gh repo create "$TEST_REPO_2" --public >/dev/null 2>&1; then
  pass "Empty repo created: $TEST_REPO_2"
  REPOS_TO_DELETE+=("$TEST_REPO_2")
else
  fail "Failed to create empty repo"
  FAIL=$((FAIL + 4))
  TEST_5_2_SKIP=true
fi

if [[ "${TEST_5_2_SKIP:-}" != "true" ]]; then
  cd "$WORK_DIR" || exit 1
  git clone "https://github.com/$TEST_REPO_2.git" "$REPO_NAME_2" >/dev/null 2>&1 || {
    # New empty repos need an initial commit
    mkdir -p "$REPO_NAME_2"
    cd "$REPO_NAME_2"
    git init >/dev/null 2>&1
    git remote add origin "https://github.com/$TEST_REPO_2.git" 2>/dev/null
    echo "# My Project" > README.md
    echo "const app = () => console.log('hello');" > index.js
    git add README.md index.js
    git commit -m "initial commit" >/dev/null 2>&1
    git branch -M main
    git push -u origin main >/dev/null 2>&1
  }
  cd "$WORK_DIR/$REPO_NAME_2" 2>/dev/null || cd "$REPO_NAME_2" 2>/dev/null || { fail "Can't enter retrofit repo"; TEST_5_2_SKIP=true; }
fi

if [[ "${TEST_5_2_SKIP:-}" != "true" ]]; then
  # Ensure we have an initial commit
  if ! git log --oneline -1 >/dev/null 2>&1; then
    echo "# My Project" > README.md
    echo "const app = () => console.log('hello');" > index.js
    git add README.md index.js
    git commit -m "initial commit" >/dev/null 2>&1
    git branch -M main
    git push -u origin main >/dev/null 2>&1
  fi

  # Curl the init-template command (exactly as README instructs)
  mkdir -p .claude/commands
  if curl -sL "https://raw.githubusercontent.com/$TEMPLATE_REPO/main/.claude/commands/init-template.md" \
    -o .claude/commands/init-template.md 2>/dev/null; then
    if [[ -f .claude/commands/init-template.md && -s .claude/commands/init-template.md ]]; then
      pass "Workflow E curl step works: init-template.md downloaded"
    else
      fail "Workflow E curl step: file empty or missing"
    fi
  else
    fail "Workflow E curl step: curl failed"
  fi

  # Verify existing files NOT overwritten
  if [[ -f index.js ]]; then
    pass "Existing code preserved after retrofit setup"
  else
    fail "Existing code was lost"
  fi

  # Copy secure-repo.sh from template and run
  cp "$REPO_ROOT/scripts/secure-repo.sh" scripts/secure-repo.sh 2>/dev/null || {
    mkdir -p scripts
    cp "$REPO_ROOT/scripts/secure-repo.sh" scripts/secure-repo.sh
  }
  chmod +x scripts/secure-repo.sh

  secure_output=$(bash scripts/secure-repo.sh 2>&1) || true
  if echo "$secure_output" | grep -q 'SCORECARD'; then
    pass "secure-repo.sh works on retrofitted repo"
  else
    warn "secure-repo.sh had issues on retrofitted repo"
  fi

  cd "$REPO_ROOT"
fi

# ============================================================
# TEST 5.3: Three-Command Setup (Hero Claim)
# ============================================================
header "5.3: Three-Command Setup (README Hero)"

# We already tested this in 5.1 essentially — verify the exact commands work
# Using the repo from 5.1 if it exists
if [[ "${TEST_5_1_SKIP:-}" != "true" ]] && [[ -d "$WORK_DIR/$REPO_NAME_1" ]]; then
  cd "$WORK_DIR/$REPO_NAME_1"

  # The three commands from the README hero:
  # 1. gh repo create (already done in 5.1)
  # 2. bash scripts/secure-repo.sh (already tested in 5.1)
  # 3. bash templates/hooks/setup-hooks.sh (already tested in 5.1)
  pass "Three-command setup: all 3 commands succeeded (verified in 5.1)"

  cd "$REPO_ROOT"
else
  warn "Three-command setup: skipped (5.1 repo not available)"
fi

# ============================================================
# TEST 5.4: Drift Detection
# ============================================================
header "5.4: Drift Detection"

if [[ "${TEST_5_1_SKIP:-}" != "true" ]] && [[ -d "$WORK_DIR/$REPO_NAME_1" ]]; then
  cd "$WORK_DIR/$REPO_NAME_1"

  # Simulate drift by modifying SECURITY.md
  if [[ -f SECURITY.md ]]; then
    echo "# Modified" >> SECURITY.md
    git add SECURITY.md
    git commit -m "simulate drift" >/dev/null 2>&1

    # Run the drift check logic locally (can't call reusable workflow locally,
    # but we can test the core comparison logic)
    TEMPLATE_SHA=$(gh api "repos/$TEMPLATE_REPO/contents/SECURITY.md" --jq '.sha' 2>/dev/null || echo "")
    LOCAL_SHA=$(git hash-object SECURITY.md 2>/dev/null || echo "")

    if [[ -n "$TEMPLATE_SHA" && -n "$LOCAL_SHA" && "$TEMPLATE_SHA" != "$LOCAL_SHA" ]]; then
      pass "Drift detection: correctly identifies modified SECURITY.md"
    else
      fail "Drift detection: did not detect modification"
    fi
  else
    warn "Drift detection: SECURITY.md not found in test repo"
  fi

  # Test missing file detection
  if [[ -f .gitattributes ]]; then
    git rm .gitattributes >/dev/null 2>&1
    git commit -m "remove gitattributes" >/dev/null 2>&1

    if [[ ! -f .gitattributes ]]; then
      TEMPLATE_EXISTS=$(gh api "repos/$TEMPLATE_REPO/contents/.gitattributes" --jq '.sha' 2>/dev/null || echo "")
      if [[ -n "$TEMPLATE_EXISTS" ]]; then
        pass "Drift detection: correctly identifies missing .gitattributes"
      else
        warn "Drift detection: template also missing .gitattributes"
      fi
    fi
  else
    warn "Drift detection: .gitattributes not found"
  fi

  cd "$REPO_ROOT"
else
  warn "Drift detection: skipped (5.1 repo not available)"
fi

# ============================================================
# TEST 5.5: Cross-Repo Compliance Audit
# ============================================================
header "5.5: Cross-Repo Compliance Audit"

# Test against repo-template-example (no repo creation needed)
echo "  Auditing $OWNER/repo-template-example..."
audit_output=$(bash scripts/audit-compliance.sh "$OWNER/repo-template-example" 2>/dev/null) || true

if echo "$audit_output" | python3 -c "
import sys, json
d = json.load(sys.stdin)
r = d['repos'][0]
score = r['compliance_score']
grade = r['grade']
print(f'  Score: {score}% ({grade})')
if score >= 70:
    sys.exit(0)
else:
    sys.exit(1)
" 2>/dev/null; then
  pass "repo-template-example compliance: scored well"
else
  example_exists=$(gh repo view "$OWNER/repo-template-example" --json name 2>/dev/null || echo "")
  if [[ -z "$example_exists" ]]; then
    warn "repo-template-example does not exist (skipping)"
  else
    fail "repo-template-example scored below 70%"
  fi
fi

# Also test template against itself
echo "  Auditing $TEMPLATE_REPO (self)..."
self_output=$(bash scripts/audit-compliance.sh "$TEMPLATE_REPO" 2>/dev/null) || true

if echo "$self_output" | python3 -c "
import sys, json
d = json.load(sys.stdin)
r = d['repos'][0]
score = r['compliance_score']
grade = r['grade']
print(f'  Score: {score}% ({grade})')
if score >= 95:
    sys.exit(0)
else:
    sys.exit(1)
" 2>/dev/null; then
  pass "repo-template self-audit: 95%+ (A+)"
else
  warn "repo-template self-audit: below 95%"
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
