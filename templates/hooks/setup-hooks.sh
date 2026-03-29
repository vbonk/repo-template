#!/usr/bin/env bash
# setup-hooks.sh — Install git hooks from templates. Safe and idempotent.
# Usage: bash templates/hooks/setup-hooks.sh
# Checks for existing hooks and chains them instead of overwriting.
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
HOOKS_DIR="$REPO_ROOT/.git/hooks"
TEMPLATES_DIR="$REPO_ROOT/templates/hooks"

echo "=== Installing git hooks ==="
echo "  Templates: $TEMPLATES_DIR"
echo "  Target:    $HOOKS_DIR"
echo ""

INSTALLED=0
SKIPPED=0
CHAINED=0

# --- Pre-commit hook (secret scanning) ---
TEMPLATE="$TEMPLATES_DIR/pre-commit-secrets.sh.template"
TARGET="$HOOKS_DIR/pre-commit"

if [[ ! -f "$TEMPLATE" ]]; then
  echo -e "${YELLOW}[SKIP]${NC} pre-commit-secrets.sh.template not found"
  SKIPPED=$((SKIPPED + 1))
elif [[ -f "$TARGET" ]]; then
  # Existing hook found — check if it's already ours
  if grep -q "Pre-commit hook: blocks commits containing secrets" "$TARGET" 2>/dev/null; then
    echo -e "${YELLOW}[SKIP]${NC} pre-commit hook already installed (secret scanning)"
    SKIPPED=$((SKIPPED + 1))
  else
    # Different hook exists (husky, lint-staged, etc.) — chain them
    BACKUP="$TARGET.backup.$(date +%s)"
    cp "$TARGET" "$BACKUP"
    echo -e "${YELLOW}[CHAIN]${NC} Existing pre-commit hook backed up to $(basename "$BACKUP")"

    # Create wrapper that runs both hooks
    cat > "$TARGET" << 'WRAPPER'
#!/usr/bin/env bash
# Chained pre-commit hook — runs secret scanning + original hook
set -euo pipefail
HOOK_DIR="$(cd "$(dirname "$0")" && pwd)"

# Run secret scanning first
if [[ -f "$HOOK_DIR/pre-commit-secrets" ]]; then
  bash "$HOOK_DIR/pre-commit-secrets"
fi

# Run original hook
BACKUP=$(ls -t "$HOOK_DIR"/pre-commit.backup.* 2>/dev/null | head -1)
if [[ -n "$BACKUP" && -f "$BACKUP" ]]; then
  bash "$BACKUP"
fi
WRAPPER
    chmod +x "$TARGET"

    # Install our hook as a separate file
    cp "$TEMPLATE" "$HOOKS_DIR/pre-commit-secrets"
    chmod +x "$HOOKS_DIR/pre-commit-secrets"
    CHAINED=$((CHAINED + 1))
  fi
else
  # No existing hook — install directly
  cp "$TEMPLATE" "$TARGET"
  chmod +x "$TARGET"
  echo -e "${GREEN}[DONE]${NC} pre-commit hook installed (secret scanning)"
  INSTALLED=$((INSTALLED + 1))
fi

# --- Forbidden tokens file ---
TOKENS_TEMPLATE="$TEMPLATES_DIR/forbidden-tokens.txt.template"
TOKENS_TARGET="$HOOKS_DIR/forbidden-tokens.txt"

if [[ ! -f "$TOKENS_TEMPLATE" ]]; then
  echo -e "${YELLOW}[SKIP]${NC} forbidden-tokens.txt.template not found"
  SKIPPED=$((SKIPPED + 1))
elif [[ -f "$TOKENS_TARGET" ]]; then
  echo -e "${YELLOW}[SKIP]${NC} forbidden-tokens.txt already exists (customize as needed)"
  SKIPPED=$((SKIPPED + 1))
else
  cp "$TOKENS_TEMPLATE" "$TOKENS_TARGET"
  echo -e "${GREEN}[DONE]${NC} forbidden-tokens.txt installed (customize with your tokens)"
  INSTALLED=$((INSTALLED + 1))
fi

# --- Backup hooks to persistent location ---
REPO_NAME=$(basename "$REPO_ROOT")
BACKUP_DIR="$HOME/.config/repo-template/hooks/$REPO_NAME"

if [[ $INSTALLED -gt 0 || $CHAINED -gt 0 ]]; then
  mkdir -p "$BACKUP_DIR"
  for f in "$HOOKS_DIR"/pre-commit "$HOOKS_DIR"/pre-commit-secrets "$HOOKS_DIR"/forbidden-tokens.txt; do
    [[ -f "$f" ]] && cp "$f" "$BACKUP_DIR/"
  done
  echo -e "${GREEN}[DONE]${NC} Hooks backed up to $BACKUP_DIR"
  echo "  (Survives reclone — restore with: cp $BACKUP_DIR/* .git/hooks/)"
  INSTALLED=$((INSTALLED + 1))
fi

# --- Summary ---
echo ""
echo "=== Results: $INSTALLED installed | $CHAINED chained | $SKIPPED skipped ==="

if [[ $INSTALLED -gt 0 || $CHAINED -gt 0 ]]; then
  echo ""
  echo "Next steps:"
  echo "  1. Edit .git/hooks/forbidden-tokens.txt with your environment-specific tokens"
  echo "  2. Test: echo 'sk-ant-test123' > /tmp/test.txt && git add /tmp/test.txt"
  echo "     (the pre-commit hook should block the commit)"
  echo ""
  echo "After recloning this repo, restore hooks with:"
  echo "  cp $BACKUP_DIR/* .git/hooks/ && chmod +x .git/hooks/pre-commit"
fi
