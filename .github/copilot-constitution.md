# Copilot Constitution

> Non-negotiable rules that **all agents and contributors** (human or AI) must follow.
> These rules take precedence over any agent-specific instructions.

## Security Rules (MUST)

1. **Never disable TLS verification** in production code. The `rejectUnauthorized: false` pattern is only allowed when `ENVIRONMENT !== 'prod'` and only for the local Cosmos DB emulator.
2. **Never log secrets, tokens, or keys.** This includes `organizerToken`, `participantToken`, `CLEANUP_SECRET`, and `ACS_CONNECTION_STRING`.
3. **Always use `safeCompare()`** (from `api/src/shared/game-utils.ts`) for token comparisons. Never use `===` or `==` for security tokens.
4. **Always use `crypto.randomUUID()` / `crypto.randomInt()`** for generating tokens, IDs, and game codes. Never use `Math.random()`.
5. **Always validate input lengths** against `INPUT_LIMITS` (from `api/src/shared/types.ts`) before processing. Never trust client input sizes.
6. **Always mask secrets** in CI/CD with `::add-mask::` before writing to `GITHUB_OUTPUT`.
7. **Never add `unsafe-eval` or `unsafe-inline`** to the CSP `script-src` directive in `staticwebapp.config.json`.

## Architecture Rules (MUST)

8. **API functions go in `api/src/functions/`**, one file per endpoint. Follow the existing handler + `app.http()` registration pattern.
9. **Shared utilities go in `api/src/shared/`**. Never import from one function file into another.
10. **Frontend types** (`src/lib/types.ts`) and **API types** (`api/src/shared/types.ts`) must stay in sync. Run `npm run validate:types` after any type changes.
11. **Translation keys** must be added to **all 9 language files** simultaneously. Never add a key to only some languages.
12. **Cosmos DB queries must use parameterized queries** (e.g., `@code`, `@cutoffDate`). Never concatenate user input into query strings.

## Dependency Rules (MUST)

13. **Never add a dependency with a GPL-2.0, GPL-3.0, or AGPL-3.0 license.** The dependency review workflow will block it.
14. **Prefer existing utilities** over adding new packages. Check `src/lib/utils.ts`, `api/src/shared/`, and existing packages before adding a new dependency.
15. **Pin Node.js to v20** (LTS). The `engines` field in both `package.json` files enforces this.

## Quality Rules (SHOULD)

16. Every new API function **should** have Jest unit tests in `api/src/__tests__/`.
17. Every user-facing feature **should** have a Playwright E2E test in `e2e/`.
18. Every infrastructure change **should** pass `az deployment group validate` before merging.
19. Error responses **should** use the `ApiErrorCode` enum and `createErrorResponse()` pattern from `api/src/shared/telemetry.ts`.
20. All API endpoints **should** include rate limiting via `checkRateLimit()` from `api/src/shared/rate-limiter.ts`.
