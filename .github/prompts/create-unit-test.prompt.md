---
mode: agent
description: Create Jest unit tests for an API function
---

# Create Unit Tests

Write comprehensive Jest unit tests for an Azure Functions endpoint.

## Conventions

- Test files go in `api/src/__tests__/{functionName}.test.ts`
- Mock all external dependencies: `jest.mock('../shared/cosmosdb')`, `jest.mock('../shared/telemetry')`
- Use `beforeEach(() => { jest.clearAllMocks() })` to reset between tests
- Cover: happy path, validation errors (400), auth failures (401/403), not found (404), server errors (500)
- Test rate limiting responses (429)
- Test input validation against `INPUT_LIMITS`
- Verify telemetry calls (`trackEvent`, `trackError`) are made with correct parameters

## Test Pattern

```typescript
import { HttpRequest, InvocationContext } from '@azure/functions'

jest.mock('../shared/cosmosdb')
jest.mock('../shared/telemetry')

// Import handler after mocks
import { handlerName } from '../functions/fileName'
import { getGameByCode, getDatabaseStatus } from '../shared/cosmosdb'

const mockContext = {
  invocationId: 'test-id',
  log: jest.fn(),
  warn: jest.fn(),
  error: jest.fn(),
} as unknown as InvocationContext

describe('functionName', () => {
  beforeEach(() => { jest.clearAllMocks() })

  it('should return 200 with valid input', async () => {
    // Arrange — set up mocks
    // Act — call handler
    // Assert — verify response
  })
})
```

## Steps

1. Read the function file being tested to understand its behavior
2. Read existing tests in `api/src/__tests__/` for pattern reference
3. Create the test file with comprehensive coverage
4. Run `cd api && npm test` to verify all tests pass
5. Check coverage: `cd api && npm run test:coverage`
