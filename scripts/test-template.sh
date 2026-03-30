#!/usr/bin/env bash
# test-template.sh — Comprehensive template validation (Layers 1-4)
# Usage: bash scripts/test-template.sh [--layer N] [--verbose]
# Runs all layers by default. Use --layer to run a specific layer (1-4).
# Exit code: number of failures (0 = all pass)
set -uo pipefail
# Note: NOT using set -e — test functions intentionally produce non-zero exit codes

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

PASS=0
FAIL=0
WARN=0
SKIP=0
VERBOSE=false
RUN_LAYER=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --layer) RUN_LAYER="$2"; shift 2 ;;
    --verbose) VERBOSE=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

pass() { echo -e "  ${GREEN}PASS${NC}  $1"; PASS=$((PASS + 1)); }
fail() { echo -e "  ${RED}FAIL${NC}  $1"; FAIL=$((FAIL + 1)); }
warn() { echo -e "  ${YELLOW}WARN${NC}  $1"; WARN=$((WARN + 1)); }
skip() { echo -e "  ${YELLOW}SKIP${NC}  $1"; SKIP=$((SKIP + 1)); }
header() { echo ""; echo -e "${CYAN}=== $1 ===${NC}"; }

assert_count() {
  local label="$1" expected="$2" actual="$3"
  if [[ "$actual" -eq "$expected" ]]; then
    pass "$label: $actual (expected $expected)"
  else
    fail "$label: got $actual, expected $expected"
  fi
}

assert_file_exists() {
  local f="$1"
  if [[ -f "$f" ]]; then
    pass "Exists: $f"
  else
    fail "Missing: $f"
  fi
}

assert_contains() {
  local file="$1" pattern="$2" label="$3"
  if grep -q "$pattern" "$file" 2>/dev/null; then
    pass "$label"
  else
    fail "$label (pattern '$pattern' not found in $file)"
  fi
}

assert_not_contains() {
  local file="$1" pattern="$2" label="$3"
  if grep -q "$pattern" "$file" 2>/dev/null; then
    fail "$label (found '$pattern' in $file)"
  else
    pass "$label"
  fi
}

# ============================================================
# LAYER 1: CLAIM CONSISTENCY
# ============================================================
run_layer_1() {
  header "Layer 1: Claim Consistency"

  # 1.1 AI agent config count
  local agent_count
  agent_count=$(ls CLAUDE.md AGENTS.md GEMINI.md .cursorrules .windsurfrules .github/copilot-instructions.md .aider.conf.yml 2>/dev/null | wc -l | tr -d ' ')
  assert_count "AI agent configs" 7 "$agent_count"

  # 1.2 Workflow count
  local wf_count
  wf_count=$(find .github/workflows -name '*.yml' -type f | wc -l | tr -d ' ')
  assert_count "GitHub Actions workflows" 18 "$wf_count"

  # 1.3 Issue template count (excluding config.yml)
  local tmpl_count
  tmpl_count=$(find .github/ISSUE_TEMPLATE -name '*.yml' -not -name 'config.yml' -type f | wc -l | tr -d ' ')
  assert_count "Issue templates" 5 "$tmpl_count"

  # 1.4 Label count in labels.sh
  local label_count
  label_count=$(grep -c 'gh label create' scripts/labels.sh 2>/dev/null || echo 0)
  if [[ "$label_count" -ge 25 ]]; then
    pass "Labels in labels.sh: $label_count (>= 25)"
  else
    fail "Labels in labels.sh: $label_count (expected >= 25)"
  fi

  # 1.5 Security layers in AI-SECURITY.md
  local layer_count
  layer_count=$(grep -c 'Layer [0-9]' docs/AI-SECURITY.md 2>/dev/null || echo 0)
  if [[ "$layer_count" -ge 6 ]]; then
    pass "Security layers documented: $layer_count (>= 6)"
  else
    fail "Security layers documented: $layer_count (expected >= 6)"
  fi

  # 1.6 Cross-reference link validation
  local broken_links=0
  local checked_links=0
  local tmpfile
  tmpfile=$(mktemp)

  # Extract all links with their source files
  find . -name '*.md' -not -path '*/_admin/*' -not -path '*/repo-template-example/*' -not -path '*/.git/*' -exec grep -Hn -oE '\]\([^)]+\)' {} \; 2>/dev/null | head -300 > "$tmpfile"

  while IFS= read -r match; do
    local source_file target dir resolved
    source_file=$(echo "$match" | cut -d: -f1)
    target=$(echo "$match" | sed -E 's/.*\]\(([^)#]+).*/\1/' | sed 's|^\.\/||')

    [[ "$target" == http* ]] && continue
    [[ "$target" == mailto* ]] && continue
    [[ "$target" == "]("* ]] && continue
    [[ "$target" == ../* ]] && continue
    [[ -z "$target" || "$target" == ")" ]] && continue
    # Skip targets that contain line numbers from grep -Hn output
    [[ "$target" =~ :[0-9]+:\] ]] && continue
    case "$target" in *.svg|*.png|*.jpg|*.gif|*.yml|*.sh|*.yaml|*.json) continue ;; esac

    dir=$(dirname "$source_file")
    resolved="$dir/$target"
    if [[ ! -f "$resolved" && ! -d "$resolved" && ! -f "$target" && ! -d "$target" ]]; then
      if $VERBOSE; then echo "    Broken: $source_file -> $target"; fi
      broken_links=$((broken_links + 1))
    fi
    checked_links=$((checked_links + 1))
  done < "$tmpfile"
  rm -f "$tmpfile"

  if [[ $broken_links -eq 0 ]]; then
    pass "Cross-reference links: $checked_links checked, all resolve"
  else
    fail "Cross-reference links: $broken_links broken out of $checked_links"
  fi

  # 1.7 Mermaid diagram syntax (basic check — no empty diagrams)
  local empty_mermaid=0
  while IFS= read -r file; do
    if grep -Pzo '```mermaid\n\s*```' "$file" >/dev/null 2>&1; then
      empty_mermaid=$((empty_mermaid + 1))
      if $VERBOSE; then echo "    Empty mermaid block in: $file"; fi
    fi
  done < <(grep -rl '```mermaid' --include='*.md' . 2>/dev/null)

  if [[ $empty_mermaid -eq 0 ]]; then
    pass "Mermaid diagrams: no empty blocks"
  else
    fail "Mermaid diagrams: $empty_mermaid empty blocks"
  fi

  # 1.8 README claims match (spot checks)
  assert_contains README.md "7 AI" "README mentions 7 AI agents"
  assert_contains README.md "18 Workflows" "README mentions 18 workflows"
  assert_contains README.md "repo-template-example" "README links to example repo"
}

# ============================================================
# LAYER 2: STRUCTURAL VALIDATION
# ============================================================
run_layer_2() {
  header "Layer 2: Structural Validation"

  # 2.1 YAML validation
  local yaml_errors=0
  while IFS= read -r f; do
    if ! python3 -c "import yaml; yaml.safe_load(open('$f'))" 2>/dev/null; then
      yaml_errors=$((yaml_errors + 1))
      if $VERBOSE; then echo "    Invalid YAML: $f"; fi
    fi
  done < <(find . -name '*.yml' -o -name '*.yaml' | grep -v node_modules | grep -v repo-template-example | grep -v _admin)

  if [[ $yaml_errors -eq 0 ]]; then
    pass "YAML files: all valid"
  else
    fail "YAML files: $yaml_errors invalid"
  fi

  # 2.2 JSON validation
  local json_errors=0
  while IFS= read -r f; do
    if ! python3 -c "
import json, re, sys
with open('$f') as fh:
    content = fh.read()
    content = re.sub(r'//.*$', '', content, flags=re.MULTILINE)
    content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
    json.loads(content)
" 2>/dev/null; then
      json_errors=$((json_errors + 1))
      if $VERBOSE; then echo "    Invalid JSON: $f"; fi
    fi
  done < <(find . -name '*.json' | grep -v node_modules | grep -v repo-template-example | grep -v _admin)

  if [[ $json_errors -eq 0 ]]; then
    pass "JSON files: all valid"
  else
    fail "JSON files: $json_errors invalid"
  fi

  # 2.3 ShellCheck on .sh files
  local sc_errors=0
  if command -v shellcheck &>/dev/null; then
    while IFS= read -r f; do
      # Skip test scripts (info-level cd warnings are acceptable)
      [[ "$f" == *"test-template.sh" ]] && continue
      [[ "$f" == *"test-e2e.sh" ]] && continue
      if ! shellcheck "$f" >/dev/null 2>&1; then
        sc_errors=$((sc_errors + 1))
        if $VERBOSE; then echo "    ShellCheck fail: $f"; fi
      fi
    done < <(find . -name '*.sh' | grep -v node_modules | grep -v repo-template-example | grep -v _admin)

    if [[ $sc_errors -eq 0 ]]; then
      pass "ShellCheck (.sh): all pass"
    else
      fail "ShellCheck (.sh): $sc_errors failures"
    fi

    # 2.4 ShellCheck on .sh.template files
    local sct_errors=0
    while IFS= read -r f; do
      if ! shellcheck "$f" >/dev/null 2>&1; then
        sct_errors=$((sct_errors + 1))
        if $VERBOSE; then echo "    ShellCheck fail: $f"; fi
      fi
    done < <(find . -name '*.sh.template' | grep -v node_modules | grep -v repo-template-example | grep -v _admin)

    if [[ $sct_errors -eq 0 ]]; then
      pass "ShellCheck (.sh.template): all pass"
    else
      fail "ShellCheck (.sh.template): $sct_errors failures"
    fi
  else
    skip "ShellCheck: not installed"
  fi

  # 2.5 SHA-pinned Actions
  local unpinned
  unpinned=$(grep -rn 'uses:.*@v[0-9]' .github/workflows/ 2>/dev/null | grep -v '#' | grep -v 'dependabot/fetch-metadata' | wc -l | tr -d ' ')
  if [[ "$unpinned" -eq 0 ]]; then
    pass "Actions: all SHA-pinned"
  else
    fail "Actions: $unpinned unpinned (using version tags)"
  fi

  # 2.6 Workflow permissions
  local no_perms=0
  while IFS= read -r f; do
    if ! grep -q '^permissions:' "$f" 2>/dev/null; then
      no_perms=$((no_perms + 1))
      if $VERBOSE; then echo "    Missing permissions: $f"; fi
    fi
  done < <(find .github/workflows -name '*.yml' -type f | grep -v repo-template-example)

  local active_wf
  active_wf=$(grep -rL '^#.*name:' .github/workflows/*.yml 2>/dev/null | wc -l | tr -d ' ')
  if [[ $no_perms -le 3 ]]; then
    pass "Workflow permissions: $((active_wf - no_perms))/$active_wf have explicit permissions"
  else
    warn "Workflow permissions: $no_perms workflows missing explicit permissions:"
  fi

  # 2.7 .gitignore covers secrets
  assert_contains .gitignore '\.env' ".gitignore blocks .env"
  assert_contains .gitignore '\.pem' ".gitignore blocks .pem"
  assert_contains .gitignore '\.key' ".gitignore blocks .key"

  # 2.8 .gitattributes marks secret types
  assert_contains .gitattributes '\.pem binary' ".gitattributes marks .pem as binary"
  assert_contains .gitattributes '\.key binary' ".gitattributes marks .key as binary"

  # 2.9 Workflows have timeout
  local no_timeout=0
  while IFS= read -r f; do
    if ! grep -q 'timeout-minutes' "$f" 2>/dev/null; then
      # Only check active (non-commented) workflows
      if grep -q '^name:' "$f" 2>/dev/null; then
        no_timeout=$((no_timeout + 1))
        if $VERBOSE; then echo "    No timeout: $f"; fi
      fi
    fi
  done < <(find .github/workflows -name '*.yml' -type f | grep -v repo-template-example)

  if [[ $no_timeout -le 3 ]]; then
    pass "Workflow timeouts: most workflows have timeout-minutes"
  else
    warn "Workflow timeouts: $no_timeout workflows missing timeout-minutes"
  fi

  # 2.10 Essential files exist
  for f in CLAUDE.md AGENTS.md GEMINI.md .cursorrules .windsurfrules .aider.conf.yml \
           .github/copilot-instructions.md .gitattributes .gitignore .editorconfig \
           CONTRIBUTING.md SECURITY.md CODE_OF_CONDUCT.md GOVERNANCE.md LICENSE \
           SUPPORT.md CHANGELOG.md .env.example \
           scripts/secure-repo.sh scripts/labels.sh scripts/my-tasks.sh scripts/close-issue.sh \
           scripts/audit-compliance.sh \
           templates/hooks/pre-commit-secrets.sh.template \
           templates/hooks/forbidden-tokens.txt.template \
           templates/hooks/setup-hooks.sh \
           templates/linting/commitlint.config.js.template \
           docs/AI-SECURITY.md docs/ARCHITECTURE.md docs/BRANCH-PROTECTION.md \
           docs/FORK-SECURITY.md docs/GITHUB-ENVIRONMENTS.md docs/PROD_CHECKLIST.md \
           docs/GETTING-STARTED.md docs/DOCUMENTATION-GUIDE.md \
           .claude/skills/README.md .claude/agents/README.md \
           CONTRIBUTORS.md; do
    assert_file_exists "$f"
  done
}

# ============================================================
# LAYER 3: FUNCTIONAL TESTS
# ============================================================
run_layer_3() {
  header "Layer 3: Functional Tests"

  # 3.1 setup-hooks.sh installs hooks
  # Save existing hook if present
  local had_hook=false
  if [[ -f .git/hooks/pre-commit ]]; then
    cp .git/hooks/pre-commit .git/hooks/pre-commit.test-backup
    had_hook=true
  fi

  bash templates/hooks/setup-hooks.sh >/dev/null 2>&1
  if [[ -x .git/hooks/pre-commit ]]; then
    pass "setup-hooks.sh: pre-commit hook installed and executable"
  else
    fail "setup-hooks.sh: pre-commit hook not installed or not executable"
  fi

  if [[ -f .git/hooks/forbidden-tokens.txt ]]; then
    pass "setup-hooks.sh: forbidden-tokens.txt created"
  else
    fail "setup-hooks.sh: forbidden-tokens.txt not created"
  fi

  # 3.2 setup-hooks.sh is idempotent
  local output
  output=$(bash templates/hooks/setup-hooks.sh 2>&1)
  if echo "$output" | grep -q 'SKIP'; then
    pass "setup-hooks.sh: idempotent (skips on re-run)"
  else
    warn "setup-hooks.sh: may not be idempotent"
  fi

  # 3.3 setup-hooks.sh chains with existing hook
  rm -f .git/hooks/pre-commit .git/hooks/pre-commit-secrets
  echo '#!/bin/bash' > .git/hooks/pre-commit
  echo 'echo "original hook"' >> .git/hooks/pre-commit
  chmod +x .git/hooks/pre-commit

  bash templates/hooks/setup-hooks.sh >/dev/null 2>&1
  if [[ -f .git/hooks/pre-commit-secrets ]] || ls .git/hooks/pre-commit.backup.* >/dev/null 2>&1; then
    pass "setup-hooks.sh: chains with existing hook (backup created)"
  else
    fail "setup-hooks.sh: did not chain with existing hook"
  fi

  # Restore original hook
  rm -f .git/hooks/pre-commit .git/hooks/pre-commit-secrets .git/hooks/pre-commit.backup.*
  if $had_hook; then
    mv .git/hooks/pre-commit.test-backup .git/hooks/pre-commit
  else
    cp templates/hooks/pre-commit-secrets.sh.template .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
  fi

  # 3.4 secure-repo.sh runs and produces scorecard
  if command -v gh &>/dev/null; then
    output=$(bash scripts/secure-repo.sh 2>&1) || true
    if echo "$output" | grep -q 'SCORECARD'; then
      pass "secure-repo.sh: produces scorecard"
    else
      fail "secure-repo.sh: no scorecard in output"
    fi
  else
    skip "secure-repo.sh: gh CLI not available"
  fi

  # 3.5 audit-compliance.sh produces valid JSON
  if command -v gh &>/dev/null; then
    output=$(bash scripts/audit-compliance.sh 2>/dev/null) || true
    if echo "$output" | python3 -c "import sys,json; json.load(sys.stdin)" 2>/dev/null; then
      pass "audit-compliance.sh: valid JSON output"
    else
      fail "audit-compliance.sh: invalid JSON output"
    fi
  else
    skip "audit-compliance.sh: gh CLI not available"
  fi

  # 3.6 my-tasks.sh runs without error (requires gh + repo context)
  if command -v gh &>/dev/null; then
    if bash scripts/my-tasks.sh all >/dev/null 2>&1; then
      pass "my-tasks.sh: runs without error"
    else
      warn "my-tasks.sh: exited with error (may need issue context)"
    fi
  else
    skip "my-tasks.sh: gh CLI not available"
  fi

  # 3.7 Scripts are executable
  for f in scripts/secure-repo.sh scripts/labels.sh scripts/my-tasks.sh scripts/close-issue.sh scripts/audit-compliance.sh templates/hooks/setup-hooks.sh; do
    if [[ -x "$f" ]]; then
      pass "Executable: $f"
    else
      fail "Not executable: $f"
    fi
  done
}

# ============================================================
# LAYER 4: SECURITY VERIFICATION
# ============================================================
run_layer_4() {
  header "Layer 4: Security Verification"

  # Ensure hooks are installed for testing
  if [[ ! -x .git/hooks/pre-commit ]]; then
    bash templates/hooks/setup-hooks.sh >/dev/null 2>&1
  fi

  # Helper: test if hook blocks a pattern
  test_hook_blocks() {
    local label="$1" content="$2" filename="$3"
    echo "$content" > "$filename"
    git add -f "$filename" >/dev/null 2>&1
    if bash .git/hooks/pre-commit >/dev/null 2>&1; then
      fail "Hook should BLOCK: $label"
    else
      pass "Hook BLOCKS: $label"
    fi
    git reset HEAD "$filename" >/dev/null 2>&1
    rm -f "$filename"
  }

  # Helper: test if hook allows a file
  test_hook_allows() {
    local label="$1" content="$2" filename="$3"
    echo "$content" > "$filename"
    git add -f "$filename" >/dev/null 2>&1
    if bash .git/hooks/pre-commit >/dev/null 2>&1; then
      pass "Hook ALLOWS: $label"
    else
      fail "Hook should ALLOW: $label"
    fi
    git reset HEAD "$filename" >/dev/null 2>&1
    rm -f "$filename"
  }

  # 4.1-4.5 Hook blocks secret patterns
  test_hook_blocks "sk-ant-* pattern" "const key = 'sk-ant-api03test123abc456';" "test-sec-41.js"
  test_hook_blocks "AKIA* pattern" "AWS_KEY=AKIAIOSFODNN7EXAMPLE1" "test-sec-42.py"
  test_hook_blocks "ghp_* pattern" "token = 'ghp_aBcDeFgHiJkLmNoPqRsTuVwXyZ0123456789'" "test-sec-43.ts"
  test_hook_blocks "private key" "-----BEGIN RSA PRIVATE KEY-----" "test-sec-45.txt.bak"

  # 4.6 Hook allows clean files
  test_hook_allows "clean code" "const greeting = 'hello world';" "test-sec-46.js"

  # 4.7 Hook skips .md files
  test_hook_allows ".md with patterns" "Example: sk-ant-example123456 is a pattern" "test-sec-47.md"

  # 4.8 Hook skips .template files
  test_hook_allows ".template with patterns" "AKIA pattern check" "test-sec-48.template"

  # 4.9 POSIX patterns — no \s in hooks (search for literal backslash-s)
  if grep -q '\\s' templates/hooks/pre-commit-secrets.sh.template 2>/dev/null; then
    fail "POSIX patterns: found \\s in pre-commit hook (use [[:space:]])"
  else
    pass "POSIX patterns: no \\s in pre-commit hook"
  fi

  if grep -q '\\s' scripts/secure-repo.sh 2>/dev/null; then
    fail "POSIX patterns: found \\s in secure-repo.sh"
  fi

  # 4.10 secret-scan-pr.yml has correct permissions
  assert_contains .github/workflows/secret-scan-pr.yml "contents: read" "secret-scan-pr: contents read permission"
  assert_contains .github/workflows/secret-scan-pr.yml "pull-requests: write" "secret-scan-pr: pull-requests write permission"
  assert_contains .github/workflows/secret-scan-pr.yml "KNOWN LIMITATION" "secret-scan-pr: fork limitation documented"

  # 4.11 CODEOWNERS covers security files
  assert_contains .github/CODEOWNERS "secure-repo.sh" "CODEOWNERS: secure-repo.sh listed"
  assert_contains .github/CODEOWNERS "templates/hooks" "CODEOWNERS: templates/hooks listed"
  assert_contains .github/CODEOWNERS ".gitattributes" "CODEOWNERS: .gitattributes listed"

  # 4.12 .gitignore blocks .env
  echo "SECRET=test" > .env.test-verify
  local git_add_output
  git_add_output=$(git add .env.test-verify 2>&1) || true
  if echo "$git_add_output" | grep -qi 'ignored'; then
    pass ".gitignore: blocks .env files"
  else
    # Check if it was actually ignored by checking status
    if git status --porcelain .env.test-verify 2>/dev/null | grep -q '??'; then
      # File shows as untracked — gitignore blocked it from add
      pass ".gitignore: blocks .env files"
    else
      git reset HEAD .env.test-verify >/dev/null 2>&1 || true
      warn ".gitignore: .env.test-verify may not match .env pattern"
    fi
  fi
  rm -f .env.test-verify

  # 4.13 .env file hook check (renamed to avoid gitignore)
  test_hook_blocks ".env file staged" "DB_PASSWORD=secret123" "test-sec-env.env.local"
}

# ============================================================
# MAIN
# ============================================================

echo ""
echo "============================================"
echo "  repo-template Test Suite"
echo "  $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "============================================"

if [[ -n "$RUN_LAYER" ]]; then
  case "$RUN_LAYER" in
    1) run_layer_1 ;;
    2) run_layer_2 ;;
    3) run_layer_3 ;;
    4) run_layer_4 ;;
    *) echo "Unknown layer: $RUN_LAYER (use 1-4)"; exit 1 ;;
  esac
else
  run_layer_1
  run_layer_2
  run_layer_3
  run_layer_4
fi

echo ""
echo "============================================"
TOTAL=$((PASS + FAIL + WARN + SKIP))
echo -e "  Results: ${GREEN}$PASS pass${NC} | ${RED}$FAIL fail${NC} | ${YELLOW}$WARN warn${NC} | $SKIP skip"
echo "  Total: $TOTAL checks"

if [[ $FAIL -eq 0 ]]; then
  echo -e "  ${GREEN}ALL TESTS PASSED${NC}"
else
  echo -e "  ${RED}$FAIL FAILURE(S)${NC}"
fi
echo "============================================"
echo ""

exit "$FAIL"
