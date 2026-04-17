# Runbook: Deployment Rollback

**Trigger**: Manual — used when a production deployment causes issues
**Goal**: Restore the previous working version as quickly as possible

## When to Rollback
- Production deployment introduces a critical bug
- API error rate spikes immediately after deployment
- Health check fails after deployment completes
- Users report broken functionality that correlates with a deploy

## Rollback Options

### Option 1: Redeploy Previous Commit (Recommended)

The CI/CD pipeline builds from a specific commit. Redeploying the last known good commit is the safest approach.

```bash
# 1. Find the last successful deployment commit
#    Go to GitHub → Actions → CI/CD → find the last green "Deploy to Production" run
#    Note the commit SHA

# 2. Create a revert branch
git checkout main
git pull
git checkout -b revert/rollback-{date}
git revert {bad-commit-sha}
git push origin revert/rollback-{date}

# 3. Open a PR — CI/CD will create a preview environment to verify the revert
# 4. Merge the PR — CI/CD will deploy to QA → run E2E → deploy to Production
```

### Option 2: Direct Redeployment via SWA CLI (Emergency)

If the CI/CD pipeline itself is broken, deploy directly:

```bash
# 1. Checkout the last known good commit
git checkout {good-commit-sha}

# 2. Build
npm ci && npm run build
cd api && npm ci && npm run build && cd ..

# 3. Get SWA deployment token
TOKEN=$(az staticwebapp secrets list \
  --name {swa-name} \
  --resource-group ZavaGiftExchange \
  --query "properties.apiKey" -o tsv)

# 4. Deploy directly
npx @azure/static-web-apps-cli deploy \
  --app-location dist \
  --api-location api \
  --deployment-token $TOKEN
```

### Option 3: Infrastructure Rollback

If the issue is in the Bicep infrastructure (not the app code):

```bash
# Redeploy infrastructure from the last known good state
git checkout {good-commit-sha} -- infra/

az deployment group create \
  --resource-group ZavaGiftExchange \
  --template-file infra/main.bicep \
  --parameters infra/parameters.prod.json deploymentId=prod-stable \
  "cleanupSecret={secret}"
```

## Post-Rollback Checklist
- [ ] Verify health endpoint returns 200: `curl https://{app-url}/api/health`
- [ ] Verify readiness probe passes: `curl https://{app-url}/api/health/ready`
- [ ] Spot-check key user flows (create game, view game, organizer panel)
- [ ] Notify the team about the rollback and root cause
- [ ] Create a post-incident report documenting what happened
- [ ] Fix the underlying issue in a new PR before re-deploying

## Prevention
- Always verify changes in the QA environment before production
- The CI/CD pipeline runs E2E tests against QA before promoting to production
- Use the `production` GitHub Environment with required reviewers for manual approval
