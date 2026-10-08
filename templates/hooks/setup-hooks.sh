#!/usr/bin/env bash
# setup-hooks.sh — Install git hooks from templates. Safe to re-run:
#   - an installed hook that already matches the template is left alone;
#   - an outdated copy of our hook is refreshed and kept as pre-commit.stale.<ts>;
#   - a foreign hook (husky, lint-staged, ...) is chained once, never twice;
#   - from a linked worktree the hooks go to the common git dir all worktrees share.
# Usage: bash templates/hooks/setup-hooks.sh
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Marker lines by which this installer recognises its own files.
SCANNER_MARKER="Pre-commit hook: blocks commits containing secrets"
WRAPPER_MARKER="Chained pre-commit hook"

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
# Hooks live in the common git directory, which every linked worktree shares.
# Inside a linked worktree $REPO_ROOT/.git is a file, so build the path from
# the common directory, not from the worktree root.
if ! GIT_COMMON_DIR="$(git rev-parse --git-common-dir 2>/dev/null)"; then
  echo "ERROR: not inside a git repository (run this from a checkout of the project)" >&2
  exit 1
fi
GIT_COMMON_DIR="$(cd "$GIT_COMMON_DIR" && pwd)"
HOOKS_DIR="$GIT_COMMON_DIR/hooks"
TEMPLATES_DIR="$REPO_ROOT/templates/hooks"
mkdir -p "$HOOKS_DIR"

echo "=== Installing git hooks ==="
echo "  Templates: $TEMPLATES_DIR"
echo "  Target:    $HOOKS_DIR"
echo ""

INSTALLED=0
UPDATED=0
SKIPPED=0
CHAINED=0
WARNINGS=0

# keep_aside FILE KIND — copy FILE to FILE.KIND.<timestamp>; print that name.
# Nothing the user may have edited is ever overwritten in place.
keep_aside() {
  local copy
  copy="$1.$2.$(date +%s)"
  cp "$1" "$copy"
  basename "$copy"
}

# --- Pre-commit hook (secret scanning) ---
TEMPLATE="$TEMPLATES_DIR/pre-commit-secrets.sh.template"
TARGET="$HOOKS_DIR/pre-commit"
SCANNER="$HOOKS_DIR/pre-commit-secrets"   # where the scanner lives once chained

if [[ ! -f "$TEMPLATE" ]]; then
  echo -e "${YELLOW}[SKIP]${NC} pre-commit-secrets.sh.template not found"
  SKIPPED=$((SKIPPED + 1))
elif [[ ! -f "$TARGET" ]]; then
  # No existing hook — install directly
  cp "$TEMPLATE" "$TARGET"
  chmod +x "$TARGET"
  echo -e "${GREEN}[DONE]${NC} pre-commit hook installed (secret scanning)"
  INSTALLED=$((INSTALLED + 1))
elif cmp -s "$TEMPLATE" "$TARGET"; then
  # Content comparison, not just the marker line: a re-run must deliver
  # fixes made to the template since the last install.
  [[ -x "$TARGET" ]] || chmod +x "$TARGET"
  echo -e "${YELLOW}[SKIP]${NC} pre-commit hook already current (secret scanning)"
  SKIPPED=$((SKIPPED + 1))
elif grep -q "$SCANNER_MARKER" "$TARGET" 2>/dev/null; then
  # An older copy of this scanner: keep it aside (it may carry local edits),
  # then install the current one.
  STALE=$(keep_aside "$TARGET" stale)
  cp "$TEMPLATE" "$TARGET"
  chmod +x "$TARGET"
  echo -e "${GREEN}[UPDATE]${NC} pre-commit hook refreshed from the template (old copy kept as $STALE)"
  UPDATED=$((UPDATED + 1))
elif grep -q "$WRAPPER_MARKER" "$TARGET" 2>/dev/null; then
  # Chained on an earlier run: leave the wrapper and the foreign hook alone
  # and refresh only the scanner the wrapper calls.
  if [[ -f "$SCANNER" ]] && cmp -s "$TEMPLATE" "$SCANNER"; then
    [[ -x "$SCANNER" ]] || chmod +x "$SCANNER"
    echo -e "${YELLOW}[SKIP]${NC} chained secret scanning already current"
    SKIPPED=$((SKIPPED + 1))
  else
    if [[ -f "$SCANNER" ]]; then
      STALE=$(keep_aside "$SCANNER" stale)
      echo -e "${GREEN}[UPDATE]${NC} chained secret scanning refreshed from the template (old copy kept as $STALE)"
    else
      echo -e "${GREEN}[UPDATE]${NC} chained secret scanning restored from the template"
    fi
    cp "$TEMPLATE" "$SCANNER"
    chmod +x "$SCANNER"
    UPDATED=$((UPDATED + 1))
  fi
  # A backup that is itself a wrapper means an earlier installer version
  # chained twice; the chain then never reaches the original hook. Say so.
  NEWEST_BACKUP=""
  for b in "$HOOKS_DIR"/pre-commit.backup.*; do
    [[ -f "$b" ]] || continue
    if [[ -z "$NEWEST_BACKUP" || "$b" -nt "$NEWEST_BACKUP" ]]; then NEWEST_BACKUP="$b"; fi
  done
  if [[ -n "$NEWEST_BACKUP" ]] && grep -q "$WRAPPER_MARKER" "$NEWEST_BACKUP" 2>/dev/null; then
    echo -e "${YELLOW}[WARN]${NC} $(basename "$NEWEST_BACKUP") is itself a chained wrapper (an earlier run chained twice);"
    echo "       remove it so the chain reaches your original hook"
  fi
else
  # Different hook exists (husky, lint-staged, etc.) — chain them
  BACKUP=$(keep_aside "$TARGET" backup)
  echo -e "${YELLOW}[CHAIN]${NC} Existing pre-commit hook backed up to $BACKUP"

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
  cp "$TEMPLATE" "$SCANNER"
  chmod +x "$SCANNER"
  CHAINED=$((CHAINED + 1))
fi

# --- Forbidden tokens file ---
TOKENS_TEMPLATE="$TEMPLATES_DIR/forbidden-tokens.txt.template"
TOKENS_TARGET="$HOOKS_DIR/forbidden-tokens.txt"

if [[ ! -f "$TOKENS_TEMPLATE" ]]; then
  echo -e "${YELLOW}[SKIP]${NC} forbidden-tokens.txt.template not found"
  SKIPPED=$((SKIPPED + 1))
elif [[ -f "$TOKENS_TARGET" ]]; then
  # Never refreshed: this file carries the user's own tokens.
  echo -e "${YELLOW}[SKIP]${NC} forbidden-tokens.txt already exists (customize as needed)"
  SKIPPED=$((SKIPPED + 1))
else
  cp "$TOKENS_TEMPLATE" "$TOKENS_TARGET"
  echo -e "${GREEN}[DONE]${NC} forbidden-tokens.txt installed (customize with your tokens)"
  INSTALLED=$((INSTALLED + 1))
fi

# --- Hook routing: core.hooksPath (husky, lint-staged) ---
# When core.hooksPath is set, git runs hooks from there and never from the
# hooks dir above; a relative value counts from the worktree root, where
# hooks run. Measured: with core.hooksPath=.husky and no such directory, a
# commit sailed past the installed gate. Say so, and say how to wire it.
HOOKS_PATH_CFG="$(git config --path --get core.hooksPath 2>/dev/null || true)"
if [[ -n "$HOOKS_PATH_CFG" ]]; then
  case "$HOOKS_PATH_CFG" in
    /*) EFFECTIVE_HOOKS_DIR="$HOOKS_PATH_CFG" ;;
    *)  EFFECTIVE_HOOKS_DIR="$REPO_ROOT/$HOOKS_PATH_CFG" ;;
  esac
  HOOKS_DIR_PHYS="$(cd "$HOOKS_DIR" && pwd -P)"
  EFFECTIVE_PHYS="$(cd "$EFFECTIVE_HOOKS_DIR" 2>/dev/null && pwd -P || echo "$EFFECTIVE_HOOKS_DIR")"
  if [[ "$EFFECTIVE_PHYS" != "$HOOKS_DIR_PHYS" ]]; then
    echo ""
    echo -e "${YELLOW}[WARN]${NC} core.hooksPath is set to \"$HOOKS_PATH_CFG\" ($EFFECTIVE_PHYS): git runs hooks"
    echo "       from there and never from $HOOKS_DIR, so the secret gate"
    echo "       installed above is inert until that hook calls it. Either:"
    echo "         - add this line to $EFFECTIVE_PHYS/pre-commit:"
    echo "             bash \"$HOOKS_DIR/pre-commit\""
    echo "         - or copy the scanner there (replaces that hook if it exists):"
    echo "             cp \"$TEMPLATE\" \"$EFFECTIVE_PHYS/pre-commit\" && chmod +x \"$EFFECTIVE_PHYS/pre-commit\""
    WARNINGS=$((WARNINGS + 1))
  fi
fi

# --- Backup hooks to persistent location ---
# Named after the main checkout, not after a linked worktree.
REPO_NAME=$(basename "$(dirname "$GIT_COMMON_DIR")")
BACKUP_DIR="$HOME/.config/repo-template/hooks/$REPO_NAME"

if [[ $INSTALLED -gt 0 || $UPDATED -gt 0 || $CHAINED -gt 0 ]]; then
  mkdir -p "$BACKUP_DIR"
  for f in "$HOOKS_DIR"/pre-commit "$HOOKS_DIR"/pre-commit-secrets "$HOOKS_DIR"/forbidden-tokens.txt; do
    [[ -f "$f" ]] && cp "$f" "$BACKUP_DIR/"
  done
  echo -e "${GREEN}[DONE]${NC} Hooks backed up to $BACKUP_DIR"
  echo "  (Survives reclone — restore with: cp $BACKUP_DIR/* $HOOKS_DIR/)"
  INSTALLED=$((INSTALLED + 1))
fi

# --- Summary ---
echo ""
echo "=== Results: $INSTALLED installed | $UPDATED updated | $CHAINED chained | $SKIPPED skipped | $WARNINGS warnings ==="

if [[ $INSTALLED -gt 0 || $UPDATED -gt 0 || $CHAINED -gt 0 ]]; then
  echo ""
  echo "Next steps:"
  echo "  1. Edit $HOOKS_DIR/forbidden-tokens.txt with your environment-specific tokens"
  echo "  2. Test that the hook blocks a fake secret (run from the repo root):"
  echo "       echo \"key='sk-ant-test1234567890'\" > .hook-selftest.py"
  echo "       git add .hook-selftest.py && git commit -m 'hook test'"
  echo "     The commit should be BLOCKED. Then clean up:"
  echo "       git reset .hook-selftest.py && rm .hook-selftest.py"
  echo ""
  echo "After recloning this repo, restore hooks with:"
  echo "  cp $BACKUP_DIR/* .git/hooks/ && chmod +x .git/hooks/pre-commit"
  echo "Re-run this installer after pulling template updates: an outdated copy is"
  echo "refreshed and the old one kept as pre-commit.stale.<timestamp>."
fi
