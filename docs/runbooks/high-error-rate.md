# Runbook: High API Error Rate

**Alert**: `alert-high-error-rate-{environment}`
**Severity**: 1 (Error)
**Trigger**: >5 failed requests (5xx) in a 5-minute window

## Symptoms
- Users see "Internal error" messages
- Health endpoint (`/api/health`) returns 503
- Application Insights shows spike in failed requests

## Diagnostic Steps

### 1. Check Application Health
```bash
# Check health endpoint
curl -s https://{app-url}/api/health | jq .

# Check readiness (database connectivity)
curl -s https://{app-url}/api/health/ready | jq .
```

### 2. Check Application Insights
```kusto
// Recent failures in App Insights (Logs → Query)
requests
| where timestamp > ago(15m)
| where success == false
| summarize count() by resultCode, name
| order by count_ desc
```

### 3. Check Cosmos DB Status
```bash
# Via Azure CLI
az cosmosdb show --name {cosmos-account} --resource-group {rg} --query "failoverPolicies"
```

### 4. Check Azure Functions Runtime
```kusto
// Function execution errors
traces
| where timestamp > ago(15m)
| where severityLevel >= 3
| project timestamp, message, severityLevel
| order by timestamp desc
```

## Common Causes & Fixes

| Cause | Fix |
|-------|-----|
| Cosmos DB throttling (429) | Check RU consumption; serverless auto-scales but may have brief spikes |
| Cosmos DB unavailable | Check Azure status page; verify region availability |
| API code error (unhandled exception) | Check App Insights exceptions; deploy fix via CI/CD |
| Memory/timeout issues | Check function timeout (5 min limit in host.json) |
| Rate limiting triggered | Expected behavior — clients see 429, not 5xx |

## Escalation
If the issue persists after 15 minutes:
1. Check [Azure Status](https://status.azure.com/) for service outages
2. Review recent deployments — consider rollback if a deploy correlates with the spike
3. Check Cosmos DB metrics for partition hotspots
