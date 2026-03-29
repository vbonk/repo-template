#!/usr/bin/env bash
# Compliance Audit — Score repos against repo-template standards
# Usage: ./scripts/audit-compliance.sh [repo1] [repo2] ...
# If no repos specified, audits the current repo.
# Output: JSON to stdout
set -euo pipefail

REPOS=("$@")
if [ ${#REPOS[@]} -eq 0 ]; then
  REPOS=("$(gh repo view --json nameWithOwner -q '.nameWithOwner')")
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

def check_workflow_sha_pinned(repo):
    """Check if workflows use SHA-pinned actions"""
    result = subprocess.run(
        ["gh", "api", f"repos/{repo}/contents/.github/workflows"],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        return False
    # If workflows dir exists, check for SHA pattern in ci.yml
    ci_result = subprocess.run(
        ["gh", "api", f"repos/{repo}/contents/.github/workflows/ci.yml",
         "-H", "Accept: application/vnd.github.raw"],
        capture_output=True, text=True
    )
    if ci_result.returncode != 0:
        return False
    # Check for SHA-pinned pattern (40-char hex after @)
    return bool(re.search(r'uses:.*@[a-f0-9]{40}', ci_result.stdout))

# Feature definitions: (id, name, category, weight, check_path_or_special)
FEATURES = [
    ("claude-md", "CLAUDE.md", "ai-config", 5, "CLAUDE.md"),
    ("agents-md", "AGENTS.md", "ai-config", 4, "AGENTS.md"),
    ("copilot-instructions", "copilot-instructions.md", "ai-config", 3, ".github/copilot-instructions.md"),
    ("cursorrules", ".cursorrules", "ai-config", 3, ".cursorrules"),
    ("gemini-md", "GEMINI.md", "ai-config", 3, "GEMINI.md"),
    ("windsurfrules", ".windsurfrules", "ai-config", 2, ".windsurfrules"),
    ("claude-commands", ".claude/commands/", "ai-config", 3, ".claude/commands"),
    ("ci-workflow", "CI workflow", "ci-cd", 5, ".github/workflows/ci.yml"),
    ("ci-sha-pinned", "Actions SHA-pinned", "ci-cd", 4, "__sha_check__"),
    ("ci-permissions", "Explicit permissions", "ci-cd", 3, "__skip__"),
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
    ("docs-index", "docs/README.md index", "docs", 2, "docs/README.md"),
    ("meta-ci", "Template self-validation", "ci-cd", 2, ".github/workflows/validate-template.yml"),
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
        elif fpath == "__skip__":
            present = True  # Can't easily check remotely
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
