# Copilot Memory

> Persistent project context — decisions made, patterns that work, known issues, and lessons learned.
> Updated as the project evolves. Agents should consult this before making architectural decisions.

## Architecture Decisions

### Why Azure Static Web Apps (not App Service or Container Apps)?
- SWA provides integrated hosting for both the React frontend and Azure Functions API
- Standard tier SWA used for all environments (Free tier not available on all subscriptions)
- Built-in staging environments support the PR preview workflow
- **Limitation**: Managed Functions only support HTTP triggers (no timer/queue/Service Bus triggers)
- **Workaround**: The cleanup scheduled task uses a GitHub Actions cron workflow that calls an HTTP endpoint

### Why Cosmos DB Serverless (not provisioned throughput)?
- Pay-per-request pricing means near-zero cost for low-traffic environments (PR, QA)
- No capacity planning needed — auto-scales to any traffic level
- **Limitation**: No change feed triggers with SWA Managed Functions
- **Partition key**: `/id` — each game is its own partition. This works because games are always accessed by ID or code, never queried across partitions in bulk.

### Why key-based auth for Cosmos DB?
- Key-based auth using `COSMOS_KEY` deployed via Bicep using `cosmosAccount.listKeys().primaryMasterKey`
- The API requires both `COSMOS_ENDPOINT` and `COSMOS_KEY` to connect
- Matches the proven approach from the upstream secretsanta repository
- **RBAC role provisioned**: SWA system-assigned managed identity + Cosmos DB Data Contributor role are provisioned in Bicep for future migration to keyless auth when `@azure/identity` SDK compatibility with SWA is resolved
- **Local development**: Uses key-based auth with `COSMOS_KEY` in `local.settings.json` (the emulator doesn't support managed identity)

### Why not WebSocket/SSE for real-time updates?
- SWA Managed Functions don't support WebSocket connections
- Current polling approach (30-second interval) is sufficient for the use case
- Adding real-time would require Azure SignalR Service — evaluated and deferred due to added complexity and cost for minimal user benefit

## Patterns That Work

### Assignment Algorithm
The circular shuffle (Fisher-Yates with `crypto.randomInt`) produces a single Hamiltonian cycle where each participant gives to exactly one person and receives from exactly one person. This guarantees valid assignments in O(n) time. Exclusion pairs are handled by retry (up to 200 attempts) with a fallback that ignores exclusions if no valid arrangement is found.

### Lock-based Regeneration
When adding a participant to an existing game, confirmed participants' assignments are "locked" and only unconfirmed assignments are regenerated. This prevents disrupting participants who have already seen their assignment.

### Email Service Optionality
The email service (Azure Communication Services) is designed as fully optional. When `ACS_CONNECTION_STRING` is not set, all email functions gracefully return without error. This allows PR environments to skip email costs entirely.

## Known Gotchas

### Cosmos DB Emulator TLS
The Docker-based Cosmos DB emulator uses a self-signed certificate. The API handles this by checking for a local CA cert file first, and only falls back to `rejectUnauthorized: false` when the cert file doesn't exist and `ENVIRONMENT !== 'prod'`. The native Windows emulator on port 8081 can conflict with the Docker emulator — stop the native one first.

### SWA Deployment Token Security
The SWA API key retrieved via `az staticwebapp secrets list` must be masked with `::add-mask::` in CI/CD before writing to `GITHUB_OUTPUT`. This was a prior security finding that has been fixed.

### Translation Key Consistency
All 9 translation files must have identical keys. Adding a key to only some files will cause a runtime fallback to the key name itself (which is usually English camelCase — not user-friendly). The `validate:types` script does not currently check translation key consistency — this is a manual process.

### Cosmos DB Free Tier (Optional)
Cosmos DB free tier is **disabled by default** (`enableFreeTier = false` in Bicep) for maximum subscription compatibility. Azure allows only one free tier account per subscription, and it's not available on all subscription types. Users can opt-in by adding `"enableFreeTier": { "value": true }` to parameter files if their subscription supports it.

## What NOT to Do

- **Don't add timer triggers** to the Azure Functions. SWA Managed Functions only support HTTP triggers. Use the GitHub Actions cron + HTTP endpoint pattern instead.
- **Don't store user sessions** on the server. The app is stateless — participant identity is established by tokens in the URL/request, not by server-side sessions.
- **Don't add a database migration system**. Cosmos DB is schema-less. New fields are added with optional types and handled gracefully when missing.
- **Don't cache Cosmos DB responses** in the API. The serverless pricing model makes reads cheap, and caching would introduce stale data issues for a multi-user game.
