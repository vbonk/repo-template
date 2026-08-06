#!/usr/bin/env bash
# Compliance Audit — Score repos against repo-template standards
# Usage: ./scripts/audit-compliance.sh [repo1] [repo2] ...
# If no repos specified, audits the current repo.
# Output: JSON to stdout
set -euo pipefail

# shellcheck source=_lib.sh
# shellcheck disable=SC1091
source "$(dirname "$0")/_lib.sh"
check_gh_auth

REPOS=("$@")
if [ ${#REPOS[@]} -eq 0 ]; then
  check_gh_repo
  # shellcheck disable=SC2153  # REPO is set by check_gh_repo in _lib.sh
  REPOS=("$REPO")
fi

export AUDIT_REPOS="${REPOS[*]}"

python3 << 'PYEOF'
import json, subprocess, sys, os, re

def check_file(repo, path):
    """Check if a file exists in a repo via GitHub API"""
    result = subprocess.run(
        ["gh", "api", f"repos/{repo}/contents/{path}", "--silent"],
        capture_output=True, text=True
    )
    return result.returncode == 0

def list_workflow_files(repo):
    """Return the .yml/.yaml filenames under .github/workflows (empty on error)"""
    result = subprocess.run(
        ["gh", "api", f"repos/{repo}/contents/.github/workflows"],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        return []
    try:
        entries = json.loads(result.stdout)
    except json.JSONDecodeError:
        return []
    return [e["name"] for e in entries
            if e.get("name", "").endswith((".yml", ".yaml"))]

def fetch_workflow(repo, name):
    """Raw content of one workflow file, or None on error"""
    result = subprocess.run(
        ["gh", "api", f"repos/{repo}/contents/.github/workflows/{name}",
         "-H", "Accept: application/vnd.github.raw"],
        capture_output=True, text=True
    )
    return result.stdout if result.returncode == 0 else None

def active_uses_refs(content):
    """All non-commented `uses:` refs, excluding local and docker refs"""
    refs = []
    for line in content.splitlines():
        stripped = line.strip()
        if stripped.startswith("#"):
            continue
        m = re.search(r'(?:^|\s)uses:\s*([^\s#]+)', stripped)
        if not m:
            continue
        ref = m.group(1).strip("\"'")
        if ref.startswith("./") or ref.startswith("docker://"):
            continue
        refs.append(ref)
    return refs

def check_workflow_sha_pinned(repo):
    """EVERY third-party action in EVERY workflow must be pinned to a
    40-hex-char SHA. One pinned action does not vouch for the rest —
    a single mutable ref (@main, @v4) is the whole supply-chain hole."""
    names = list_workflow_files(repo)
    if not names:
        return False
    saw_any = False
    for name in names:
        content = fetch_workflow(repo, name)
        if content is None:
            return False  # unverifiable is not a pass
        for ref in active_uses_refs(content):
            saw_any = True
            if not re.search(r'@[0-9a-f]{40}$', ref):
                return False
    return saw_any

def check_workflow_permissions(repo):
    """Every workflow declares a top-level `permissions:` block
    (least-privilege). Unverifiable or missing anywhere = not compliant."""
    names = list_workflow_files(repo)
    if not names:
        return False
    for name in names:
        content = fetch_workflow(repo, name)
        if content is None or not re.search(r'^permissions:', content, re.M):
            return False
    return True

def check_sbom_release(repo):
    """release.yml exists and contains an SBOM generation step."""
    content = fetch_workflow(repo, "release.yml")
    return bool(content) and ("sbom" in content.lower())

# Feature definitions: (id, name, category, weight, check_path_or_special)
FEATURES = [
    ("claude-md", "CLAUDE.md", "ai-config", 5, "CLAUDE.md"),
    ("agents-md", "AGENTS.md", "ai-config", 4, "AGENTS.md"),
    ("claude-commands", ".claude/commands/", "ai-config", 3, ".claude/commands"),
    ("ci-workflow", "CI workflow", "ci-cd", 5, ".github/workflows/ci.yml"),
    ("ci-sha-pinned", "Actions SHA-pinned", "ci-cd", 4, "__sha_check__"),
    ("ci-permissions", "Explicit permissions", "ci-cd", 3, "__permissions_check__"),
    ("dependabot", "dependabot.yml", "ci-cd", 4, ".github/dependabot.yml"),
    ("release-workflow", "Release workflow", "ci-cd", 3, ".github/workflows/release.yml"),
    ("codeql", "CodeQL scanning", "security", 4, ".github/workflows/codeql.yml"),
    ("security-md", "SECURITY.md", "security", 5, "SECURITY.md"),
    ("gitignore-secrets", ".gitignore blocks secrets", "security", 5, ".gitignore"),
    ("codeowners", "CODEOWNERS", "security", 4, ".github/CODEOWNERS"),
    ("branch-protection", "Branch protection docs", "security", 3, "docs/BRANCH-PROTECTION.md"),
    ("secure-repo-script", "Secure repo script", "security", 4, "scripts/secure-repo.sh"),
    ("secret-scan-workflow", "Secret scan PR workflow", "security", 4, ".github/workflows/secret-scan-pr.yml"),
    ("precommit-hook", "Pre-commit secrets hook", "security", 3, "templates/hooks/pre-commit-secrets.sh.template"),
    ("hook-installer", "Hook installer script", "security", 2, "templates/hooks/setup-hooks.sh"),
    ("gitattributes", ".gitattributes", "security", 3, ".gitattributes"),
    ("fork-security", "Fork security guide", "security", 2, "docs/FORK-SECURITY.md"),
    ("contributing-md", "CONTRIBUTING.md", "community", 4, "CONTRIBUTING.md"),
    ("code-of-conduct", "CODE_OF_CONDUCT.md", "community", 3, "CODE_OF_CONDUCT.md"),
    ("funding-yml", "FUNDING.yml", "community", 2, ".github/FUNDING.yml"),
    ("license", "LICENSE file", "community", 4, "LICENSE"),
    ("support-md", "SUPPORT.md", "community", 2, "SUPPORT.md"),
    ("pr-template", "PR template", "issues", 3, ".github/PULL_REQUEST_TEMPLATE.md"),
    ("issue-templates", "Issue templates (3+)", "issues", 4, ".github/ISSUE_TEMPLATE"),
    ("labels-script", "Label setup script", "issues", 3, "scripts/labels.sh"),
    ("sync-workflow", "Status sync workflow", "issues", 2, ".github/workflows/sync-status.yml"),
    ("env-example", ".env.example", "devex", 3, ".env.example"),
    ("editorconfig", ".editorconfig", "devex", 3, ".editorconfig"),
    ("devcontainer", "devcontainer.json", "devex", 2, ".devcontainer/devcontainer.json"),
    ("vscode-config", ".vscode/ settings", "devex", 2, ".vscode/settings.json"),
    ("lint-config", "Linting config", "devex", 3, "templates/linting"),
    ("changelog", "CHANGELOG.md", "docs", 2, "CHANGELOG.md"),
    ("readme-quality", "README with badges + ToC", "docs", 5, "README.md"),
    ("architecture-md", "ARCHITECTURE.md", "docs", 2, "docs/ARCHITECTURE.md"),
    ("getting-started", "Getting Started guide", "docs", 4, "docs/GETTING-STARTED.md"),
    ("doc-guide", "Documentation patterns guide", "docs", 2, "docs/DOCUMENTATION-GUIDE.md"),
    ("docs-index", "docs/README.md index", "docs", 2, "docs/README.md"),
    ("prod-checklist", "Production checklist", "docs", 3, "docs/PROD_CHECKLIST.md"),
    ("meta-ci", "Template self-validation", "ci-cd", 2, ".github/workflows/validate-template.yml"),
    ("detect-conflicts", "Merge conflict detection", "ci-cd", 2, ".github/workflows/detect-conflicts.yml"),
    ("update-contributors", "Contributor tracking", "community", 2, ".github/workflows/update-contributors.yml"),
    ("contributors-md", "CONTRIBUTORS.md", "community", 2, "CONTRIBUTORS.md"),
    ("sbom-release", "SBOM in releases", "security", 3, "__sbom_check__"),
    ("skills-dir", "Claude skills directory", "ai-config", 2, ".claude/skills/README.md"),
    ("agents-dir", "Claude agents directory", "ai-config", 2, ".claude/agents/README.md"),
]

repos_env = os.environ.get("AUDIT_REPOS", "").split()
total_weight = sum(f[3] for f in FEATURES)

results = []
for repo in repos_env:
    print(f"Auditing {repo}...", file=sys.stderr)
    features = []
    score = 0
    for fid, fname, fcat, fweight, fpath in FEATURES:
        if fpath == "__sha_check__":
            present = check_workflow_sha_pinned(repo)
        elif fpath == "__permissions_check__":
            present = check_workflow_permissions(repo)
        elif fpath == "__sbom_check__":
            present = check_sbom_release(repo)
        else:
            present = check_file(repo, fpath)

        features.append({"id": fid, "present": present})
        if present:
            score += fweight

    pct = round(score / total_weight * 100)
    if pct >= 95: grade = "A+"
    elif pct >= 90: grade = "A"
    elif pct >= 85: grade = "B+"
    elif pct >= 75: grade = "B"
    elif pct >= 65: grade = "C+"
    elif pct >= 55: grade = "C"
    elif pct >= 40: grade = "D"
    else: grade = "F"

    results.append({
        "name": repo.split("/")[-1],
        "full_name": repo,
        "compliance_score": pct,
        "grade": grade,
        "features": features
    })
    print(f"  {repo}: {pct}% ({grade})", file=sys.stderr)

output = {
    "generated_at": subprocess.run(["date", "-u", "+%Y-%m-%dT%H:%M:%SZ"],
                                    capture_output=True, text=True).stdout.strip(),
    "template_version": "2.0.0",
    "total_weight": total_weight,
    "features": [{"id": f[0], "name": f[1], "category": f[2], "weight": f[3]} for f in FEATURES],
    "repos": results
}
print(json.dumps(output, indent=2))
PYEOF
