---
title: Testing Strategy (TypeScript)
version: 1.0
applies-to: Agents and humans
purpose: TypeScript-specific testing tools and when to use each
see-also: tdd-best-practices-ts.md
---

**Purpose**: TypeScript-specific testing tools and when to use each.

> Language-agnostic testing strategy (what to test, mocking, organization)
> is in the `tdd-core` plugin. This file extends it with TypeScript tools
> (vitest, @testing-library/react, MSW).

## Core Principles

| Principle | Testing Application |
|-----------|---------------------|
| **KISS** | Test behavior, not implementation details |
| **DRY** | No duplicate coverage across tests |
| **YAGNI** | Don't test framework or library behavior |

## What to Test

**High-Value** (test these):

1. Business logic — algorithms, calculations, decision rules
2. Error paths — thrown errors, rejected promises, edge cases
3. Component behavior — user interactions, conditional rendering
4. Integration points — API contracts, serialization, custom hooks

**Low-Value** (avoid these):

1. Framework mechanics — React renders, router navigates
2. Trivial getters/setters — unless they encode business rules
3. Type system — TypeScript already verifies types at compile time
4. CSS styling — visual regressions need screenshot tools, not unit tests

### Patterns to Remove

| Pattern | Why Remove | Example |
|---------|------------|---------|
| Type checks | TypeScript verifies | `expect(typeof x).toBe('string')` |
| Snapshot abuse | Brittle, noisy diffs | Snapshot of entire page component |
| Library wrappers | Testing the library | `expect(useState).toBeDefined()` |
| Over-granular | Consolidate | 6 tests for one component's props |

**Rule**: If the test wouldn't catch a real bug, remove it.

## Tool Selection Guide

| Tool | Question it answers | Use for |
|------|---------------------|---------|
| **vitest** | Does this logic produce the right result? | TDD, unit, integration |
| **@testing-library/react** | Does this component behave correctly? | Component interactions |
| **MSW** | Does this work with real API shapes? | API mocking at network level |
| **vi.mock** | Does this behave in isolation? | Module-level mocking |

**One-line rule**: vitest for **logic**, testing-library for **components**, MSW for **APIs**, vi.mock for **isolation**.

## Unit Tests

```typescript
import { describe, it, expect } from 'vitest';
import { calculateTotal } from './order';

describe('calculateTotal', () => {
  it('sums item prices multiplied by quantity', () => {
    const items = [{ price: 10, qty: 2 }, { price: 5, qty: 1 }];
    expect(calculateTotal(items)).toBe(25);
  });
});
```

## Component Tests with @testing-library/react

```typescript
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Counter } from './Counter';

it('increments count on button click', async () => {
  const user = userEvent.setup();
  render(<Counter />);

  await user.click(screen.getByRole('button', { name: /increment/i }));

  expect(screen.getByText('Count: 1')).toBeInTheDocument();
});
```

### Query Priority

1. `getByRole` — accessible queries (preferred)
2. `getByLabelText` — form elements
3. `getByText` — visible text
4. `getByTestId` — last resort only

### Async Patterns

```typescript
// Wait for element to appear
await screen.findByText('Loaded');

// Wait for element to disappear
await waitFor(() => {
  expect(screen.queryByText('Loading...')).not.toBeInTheDocument();
});
```

## API Mocking with MSW

```typescript
import { http, HttpResponse } from 'msw';
import { setupServer } from 'msw/node';

const server = setupServer(
  http.get('/api/users/:id', ({ params }) => {
    return HttpResponse.json({ id: params.id, name: 'Alice' });
  })
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```

**When to use MSW**: API integrations, error responses, loading states
**When NOT to use**: Pure logic tests, simple component rendering

## Module Mocking with vi.mock

```typescript
import { vi, describe, it, expect } from 'vitest';

vi.mock('./api', () => ({
  fetchUser: vi.fn().mockResolvedValue({ id: '1', name: 'Alice' }),
}));
```

Always call `vi.restoreAllMocks()` in `afterEach`.

## Vitest Configuration

```typescript
// vitest.config.ts (or in vite.config.ts)
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./src/test/setup.ts'],
  },
});
```

```typescript
// src/test/setup.ts
import '@testing-library/jest-dom/vitest';
```

## Test Organization

```text
src/
├── components/
│   ├── Button.tsx
│   └── Button.test.tsx    (colocated)
├── lib/
│   ├── utils.ts
│   └── utils.test.ts      (colocated)
└── test/
    ├── setup.ts            (global setup)
    └── mocks/              (shared MSW handlers)
```

## Naming Conventions

**Format**: `describe('{Module}') > it('{behavior}')`

```typescript
describe('OrderCalculator', () => {
  it('sums item prices', () => { ... });
  it('applies percentage discount', () => { ... });
});
```

## Decision Checklist

1. Does this test **behavior** (keep) or **implementation** (skip)?
2. Would this catch a **real bug** (keep) or is it **trivial** (skip)?
3. Is this testing **our code** (keep) or **framework/library** (skip)?
4. Which tool: vitest (default), testing-library (components), MSW (APIs), vi.mock (isolation)

## References

- TDD practices: `tdd-best-practices-ts.md`
- [Vitest Documentation](https://vitest.dev/)
- [Testing Library Docs](https://testing-library.com/docs/react-testing-library/intro)
- [MSW Documentation](https://mswjs.io/)
