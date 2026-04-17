# Security Policy

Thank you for helping keep Zava Gift Exchange secure!

## Security Best Practices for Contributors

### Dependencies
- Keep all npm packages updated
- Run `npm audit` before submitting PRs
- Report vulnerable dependencies privately first

### Code
- Never commit secrets (API keys, tokens, passwords)
- Use environment variables for sensitive configuration
- Sanitize user input on both frontend and API
- Use HTTPS for all communications
- Enable CORS restrictions appropriately
- Use `crypto.randomUUID()` / `crypto.randomInt()` for all token and code generation — never `Math.random()`
- Use `safeCompare()` from `api/src/shared/game-utils.ts` for all token comparisons (timing-safe via `crypto.timingSafeEqual`)
- Enforce input length limits via `INPUT_LIMITS` in `api/src/shared/types.ts` (max 100 participants, name: 80 chars, notes: 2000 chars)
- Never expose `error.message` or stack traces in API error responses

### Rate Limiting
- Game creation: 10 requests per minute per IP
- Email sending: 20 requests per minute per IP
- GET/PATCH endpoints: 60 requests per minute per IP
- Rate limiter is in-memory (`api/src/shared/rate-limiter.ts`); for stronger enforcement across multiple instances, consider Azure API Management or Cosmos DB-based counters

### Content Security Policy
- Strict CSP with no `unsafe-eval` and no `unsafe-inline` for scripts
- `Strict-Transport-Security` (HSTS) with 1-year max-age
- `frame-ancestors 'none'` to prevent clickjacking
- `Permissions-Policy: camera=(), microphone=(), geolocation=()` to disable unused browser APIs
- See `staticwebapp.config.json` for the full CSP header

### Data Protection
- HTML escaping via `escapeHtml()` in `api/src/shared/email-service.ts` for all user content embedded in email templates
- Service worker caches static assets (JS, CSS, images, fonts) and navigation (HTML) requests, but never API responses
- localStorage game data is automatically cleaned up after 30 days
- Game code collision detection prevents code reuse
- Cosmos DB emulator TLS bypass is hard-blocked in production environments
- API error responses never expose `error.message` or stack traces
### Azure Resources
- Key-based auth for Cosmos DB via `COSMOS_KEY` deployed through Bicep (RBAC role provisioned for future keyless migration)
- Rotate secrets regularly
- Enable Application Insights for monitoring
- Use resource group RBAC for access control
- Enable audit logging
- Budget alerts available via `budgetAmount` Bicep parameter

## Third-Party Services

This application uses the following third-party services:

- **Azure Communication Services**: For sending notification emails (optional, only when explicitly requested by users)

## Automated Security Scanning

This project uses:
- **CodeQL**: Static code analysis for security vulnerabilities
- **Dependency Check**: Identifies known vulnerable dependencies
- **npm audit**: Runtime dependency vulnerability scanning

These run automatically on all pull requests and merges to main.

## Response Timeline

- **Acknowledgment**: Within 48 hours
- **Initial assessment**: Within 1 week
- **Patch release**: As soon as possible after confirmation
- **Public disclosure**: After patch is available

## Disclosure Timeline

We follow responsible disclosure practices:
1. Issue reported privately
2. We confirm and create a fix
3. Security update released
4. Vulnerability publicly disclosed after update is available

If you prefer a different disclosure timeline, please let us know in your initial report.