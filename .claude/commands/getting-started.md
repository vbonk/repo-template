# Getting Started (Interactive)

Walk the user through setting up their repo from the Getting Started guide.

## Detection

First, check if this is a new-from-template repo that hasn't been customized yet:

```bash
grep -c '<!-- TODO' CLAUDE.md
```

If there are unfilled TODOs (count > 0), this is a fresh template that needs setup.

## If Fresh Template (TODOs found)

Tell the user:
> This looks like a fresh repo from the template. Let's get you set up. This covers Level 1 and Level 2 from the [Getting Started Guide](docs/GETTING-STARTED.md).

### Level 1: Production-Grade (2 minutes)

1. **Run security hardening:**
   ```bash
   bash scripts/secure-repo.sh
   ```
   Report what was configured (Dependabot, branch protection, tag protection).

2. **Install pre-commit hooks:**
   ```bash
   bash templates/hooks/setup-hooks.sh
   ```
   Confirm the hook is installed and executable.

3. **Report status:**
   Tell the user what is now protected and what the hook catches (API keys, private keys, credentials, AWS tokens, GitHub tokens).

### Level 2: Project-Aware AI (5 minutes)

4. **Gather project details.** Ask for:
   - Project name
   - One-line description
   - Tech stack (e.g., "TypeScript, Node.js, React")
   - Primary language: Node.js/TypeScript, Python, Go, Rust, or other

5. **Update CLAUDE.md** with the project name, stack, and description. Remove the `<!-- TODO -->` placeholders that were filled.

6. **Update the other agent configs** (AGENTS.md, GEMINI.md, .cursorrules, .windsurfrules, copilot-instructions.md) to mirror the CLAUDE.md changes.

7. **Uncomment the matching language section** in `.github/workflows/ci.yml` and `.github/dependabot.yml`.

### Wrap Up

8. **Point to the full guide:**
   > Your repo is set up! For the full guide covering workflow protection, defense-in-depth security, and automation, see [docs/GETTING-STARTED.md](docs/GETTING-STARTED.md).
   >
   > Next steps:
   > - Add your source code to `src/`
   > - Push a commit and watch CI run
   > - Run `/project:security-audit` for a full security scorecard
   > - Run `/project:init-template` for additional setup (issues, releases, dev tooling)

## If Already Customized (no TODOs or very few)

Tell the user:
> This repo looks like it's already been set up. Here's what I can check:

1. Check if pre-commit hooks are installed: `test -x .git/hooks/pre-commit`
2. Check if branch protection is configured: `gh api repos/{owner}/{repo}/branches/main/protection 2>&1`
3. Report any gaps and suggest fixes.
4. Point to [docs/GETTING-STARTED.md](docs/GETTING-STARTED.md) for the full reference.
