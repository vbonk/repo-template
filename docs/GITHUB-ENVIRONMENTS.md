# GitHub Environments & Deployment Protection

Set up deployment environments with approval gates and secrets scoping.

## What Are Environments?

GitHub Environments let you:
- Scope secrets to specific deployment targets (staging, production)
- Require manual approval before deploying
- Limit which branches can deploy
- Set wait timers before deployment proceeds

## Setup

### 1. Create Environments

Go to **Settings > Environments > New environment** and create:

| Environment | Purpose |
|-------------|---------|
| `staging` | Pre-production testing |
| `production` | Live deployment |

### 2. Configure Protection Rules

For each environment:

**Staging:**
- Required reviewers: none (auto-deploy)
- Deployment branches: `main`, `develop`
- No wait timer

**Production:**
- Required reviewers: 1+ (select your team)
- Deployment branches: `main` only
- Wait timer: 5 minutes (gives time to cancel)

### 3. Scope Secrets

Move deployment-specific secrets into environments:

```
Settings > Environments > production > Environment secrets
```

| Secret | Environment | Example |
|--------|-------------|---------|
| `DEPLOY_KEY` | production | SSH key for production server |
| `DATABASE_URL` | staging | Staging database connection |
| `API_TOKEN` | production | Production API credentials |

These secrets are only available to workflows running in that environment.

### 4. Reference in Workflows

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production  # Triggers approval + scopes secrets
    steps:
      - name: Deploy
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}  # Only available in production env
        run: |
          echo "Deploying to production..."
```

## Workflow Pattern

```yaml
# deploy.yml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@SHA
      - run: npm test

  deploy-staging:
    needs: test
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - run: echo "Deploy to staging"

  deploy-production:
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment: production  # Requires approval
    steps:
      - run: echo "Deploy to production"
```

## Best Practices

1. **Never put production secrets in repository-level secrets** — use environment-scoped secrets
2. **Require approval for production** — prevents accidental deploys
3. **Limit deployment branches** — only `main` should deploy to production
4. **Use wait timers** — gives a window to cancel bad deploys
5. **Audit regularly** — review who has approval access

## See Also

- [GitHub Docs: Environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
- [BRANCH-PROTECTION.md](BRANCH-PROTECTION.md) — Branch-level protections
- [SECURITY.md](../SECURITY.md) — Security policy
