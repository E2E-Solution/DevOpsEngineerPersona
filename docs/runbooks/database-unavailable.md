# Runbook: Database Unavailable

**Alert**: `alert-availability-{environment}`
**Severity**: 0 (Critical)
**Trigger**: Readiness probe (`/api/health/ready`) returns 503

## Symptoms
- All API operations fail with "Database not available"
- Health check shows `Cosmos DB: Unhealthy`
- New game creation, retrieval, and updates all fail
- Frontend shows error state

## Diagnostic Steps

### 1. Verify the Issue
```bash
# Check readiness probe
curl -s https://{app-url}/api/health/ready | jq .

# Check full health (includes Cosmos DB status)
curl -s https://{app-url}/api/health | jq '.services[] | select(.name == "Azure Cosmos DB")'
```

### 2. Check Cosmos DB Account
```bash
# Check account status
az cosmosdb show --name {cosmos-account} --resource-group {rg} --query "{status: provisioningState, endpoint: documentEndpoint}"

# Check if database and container exist
az cosmosdb sql database show --account-name {cosmos-account} --resource-group {rg} --name ZavaGiftExchange
az cosmosdb sql container show --account-name {cosmos-account} --resource-group {rg} --database-name ZavaGiftExchange --name games
```

### 3. Check Connectivity
```kusto
// Connection errors in App Insights
dependencies
| where timestamp > ago(15m)
| where type == "Azure DocumentDB"
| where success == false
| summarize count() by resultCode
```

## Common Causes & Fixes

| Cause | Fix |
|-------|-----|
| Cosmos DB account paused/deleted | Redeploy infrastructure via CI/CD |
| `COSMOS_KEY` missing or invalid | Redeploy Bicep to refresh `COSMOS_KEY` in app settings |
| Region outage | Check [Azure Status](https://status.azure.com/); wait for recovery |
| Network connectivity | SWA Managed Functions should have direct access — check app settings |

## Recovery Steps

### If Cosmos DB account exists but API can't connect:
1. Verify app settings have correct `COSMOS_ENDPOINT` and `COSMOS_KEY`
2. Verify the SWA's Managed Identity has the Cosmos DB Data Contributor RBAC role
3. Redeploy infrastructure to recreate the role assignment:
   ```bash
   az deployment group create --resource-group {rg} --template-file infra/main.bicep --parameters infra/parameters.{env}.json deploymentId={env}-stable
   ```

### If Cosmos DB account was deleted:
1. Re-run the CI/CD pipeline (pushes to main auto-deploy infrastructure)
2. Or deploy manually: `scripts/deploy.sh {env}`
3. **Data loss**: Deleted Cosmos DB data cannot be recovered unless backups were configured

## Escalation
If Cosmos DB is healthy but the API still can't connect:
1. Check SWA app settings have the correct `COSMOS_ENDPOINT` and `COSMOS_KEY`
2. Restart the SWA (redeploy via CI/CD to force a cold start)
3. Contact Azure Support if the issue is at the platform level
