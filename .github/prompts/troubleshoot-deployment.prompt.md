---
mode: agent
description: Diagnose and fix failing CI/CD deployments
---

# Troubleshoot Deployment

Diagnose and resolve a failing GitHub Actions CI/CD deployment.

## Common Failure Points

### Build Failures
1. **TypeScript errors**: Run `npx tsc --noEmit` (frontend) and `cd api && npm run build` (API)
2. **Lint errors**: Run `npm run lint`
3. **Type drift**: Run `npm run validate:types` to check frontend/API type sync

### Infrastructure Failures (Bicep)
1. **Validation errors**: Run `az deployment group validate --resource-group {rg} --template-file infra/main.bicep --parameters infra/parameters.{env}.json deploymentId={env}-stable`
2. **Cosmos DB free tier conflict**: Only one free tier account per subscription. Check if another Cosmos DB in the subscription uses it.
3. **Name collisions**: Resource names include `uniqueString(deploymentId)`. Ensure `deploymentId` is consistent across runs.

### SWA Deployment Failures
1. **Token expired**: The SWA API key is retrieved dynamically — check Azure CLI auth
2. **Build output missing**: Verify `dist/` and `api/dist/` exist in the artifact
3. **API build fails in SWA**: Set `skip_api_build: false` to let SWA rebuild the API

### E2E Test Failures
1. **Deployment not ready**: The pipeline waits 30 seconds — may need longer for cold starts
2. **BASE_URL not set**: Check that the previous deploy job outputs the URL correctly
3. **Playwright browsers missing**: Ensure `npx playwright install --with-deps chromium` ran

## Diagnostic Steps

1. Read the failing workflow run logs
2. Identify which job and step failed
3. Check if the failure is in build, infrastructure, deployment, or testing
4. For infrastructure failures, run the validate command locally
5. For test failures, run the tests locally against the deployed URL
6. Check if the failure is environment-specific (PR vs QA vs Prod)
