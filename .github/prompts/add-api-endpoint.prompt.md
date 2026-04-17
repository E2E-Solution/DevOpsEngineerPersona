---
mode: agent
description: Scaffold a new Azure Functions HTTP endpoint following project conventions
---

# Add API Endpoint

Create a new Azure Functions HTTP endpoint for the Zava Gift Exchange API.

## Requirements

- Function file goes in `api/src/functions/{name}.ts`
- Follow the existing handler pattern (see `api/src/functions/health.ts` as a reference)
- Include rate limiting via `checkRateLimit(request, 'default')`
- Include database connectivity check via `getDatabaseStatus()`
- Include telemetry via `trackEvent()` and `trackError()`
- Use `ApiErrorCode` enum and `createErrorResponse()` for error responses
- Register with `app.http()` at the bottom of the file

## Steps

1. Read `api/src/functions/health.ts` for the pattern to follow
2. Read `api/src/shared/telemetry.ts` for available error codes and helpers
3. Create the new function file in `api/src/functions/`
4. Import it in `api/src/index.ts` (add to the import list at the bottom)
5. Create Jest tests in `api/src/__tests__/` following existing test patterns
6. Run `cd api && npm run build` to verify it compiles
7. Run `cd api && npm test` to verify tests pass
