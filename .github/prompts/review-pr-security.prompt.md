---
mode: agent
description: Security review checklist for pull requests
---

# Security Review

Perform a security review of the changes in this pull request against the project's security standards.

## Review Checklist

### Authentication & Authorization
- [ ] Token comparisons use `safeCompare()` — never `===`
- [ ] New endpoints check `organizerToken` for privileged operations
- [ ] No tokens or secrets exposed in API responses
- [ ] No tokens logged to console or telemetry

### Input Validation
- [ ] All string inputs validated against `INPUT_LIMITS`
- [ ] Array lengths bounded (max 100 participants)
- [ ] Date inputs validated with `validateDateString()`
- [ ] Email format validated where applicable

### Cryptography
- [ ] IDs generated with `crypto.randomUUID()`
- [ ] Numeric codes use `crypto.randomInt()`
- [ ] No use of `Math.random()` for security-sensitive values

### API Security
- [ ] Rate limiting applied via `checkRateLimit()`
- [ ] Database queries use parameterized values (`@param`)
- [ ] Error responses don't leak internal details
- [ ] CORS not widened beyond current configuration

### Infrastructure
- [ ] No `rejectUnauthorized: false` in production paths
- [ ] CSP headers not weakened (no `unsafe-eval`, no `unsafe-inline` for scripts)
- [ ] No new secrets added without `::add-mask::` in CI/CD
- [ ] Bicep parameters use `@secure()` for sensitive values

### Dependencies
- [ ] No GPL/AGPL licensed packages added
- [ ] No known vulnerabilities (`npm audit`)
- [ ] Dependency is necessary (can't use existing utilities?)

## How to Use

Reference this prompt when reviewing a PR:
```
@workspace /review-pr-security Check the changes in this PR against our security checklist
```
