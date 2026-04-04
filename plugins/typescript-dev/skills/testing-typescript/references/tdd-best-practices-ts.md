---
title: TDD Best Practices (TypeScript)
version: 1.0
based-on: Industry research 2025-2026
see-also: testing-strategy-ts.md
---

**Purpose**: TypeScript-specific TDD examples with vitest and @testing-library/react.

> Language-agnostic TDD principles (cycle, AAA, anti-patterns) are in
> the `tdd-core` plugin. This file extends those with TypeScript tooling.

## Red-Green-Refactor with vitest

In TypeScript, the RED phase often starts with a **type error** — the
function does not exist yet. That is intentional. Write the test first,
let the compiler tell you what is missing.

## AAA Structure in TypeScript Tests

```typescript
it('calculates order total from item prices', () => {
  // ARRANGE
  const items = [{ price: 10, qty: 2 }, { price: 5, qty: 1 }];
  const calculator = new OrderCalculator();

  // ACT
  const total = calculator.total(items);

  // ASSERT
  expect(total).toBe(25);
});
```

## TypeScript-Specific TDD: Type Guard

**RED** — write the test, it won't compile:

```typescript
it('rejects invalid email strings', () => {
  const result = parseEmail('notanemail');
  expect(result.ok).toBe(false);
});
```

**GREEN** — minimal implementation:

```typescript
type Result<T> = { ok: true; value: T } | { ok: false; error: string };

function parseEmail(input: string): Result<string> {
  if (input.includes('@')) {
    return { ok: true, value: input };
  }
  return { ok: false, error: 'Missing @' };
}
```

**REFACTOR** — improve without breaking tests.

## React Component TDD

**RED** — write the test first:

```typescript
it('displays greeting with user name', () => {
  render(<Greeting name="Alice" />);
  expect(screen.getByText('Hello, Alice!')).toBeInTheDocument();
});
```

**GREEN** — minimal component:

```tsx
interface GreetingProps { name: string; }

export function Greeting({ name }: GreetingProps) {
  return <p>Hello, {name}!</p>;
}
```

**REFACTOR** — extract shared patterns, improve accessibility.

## Custom Hook TDD

**RED** — write the test:

```typescript
import { renderHook, act } from '@testing-library/react';

it('toggles between true and false', () => {
  const { result } = renderHook(() => useToggle(false));

  act(() => result.current.toggle());

  expect(result.current.value).toBe(true);
});
```

**GREEN** — minimal hook:

```typescript
function useToggle(initial: boolean) {
  const [value, setValue] = useState(initial);
  const toggle = useCallback(() => setValue((v) => !v), []);
  return { value, toggle };
}
```

## Anti-Patterns

### Testing implementation details

```typescript
// BAD — tests internal state shape
expect(component.state.items.length).toBe(3);

// GOOD — tests observable behavior
expect(screen.getAllByRole('listitem')).toHaveLength(3);
```

### Snapshot abuse

```typescript
// BAD — brittle, noisy diffs on any change
expect(container).toMatchSnapshot();

// GOOD — assert specific behavior
expect(screen.getByRole('heading')).toHaveTextContent('Dashboard');
```

### Over-mocking

```typescript
// BAD — mocking everything, testing nothing
vi.mock('./utils');
vi.mock('./api');
vi.mock('./hooks');

// GOOD — mock only external boundaries
vi.mock('./api');  // external dependency only
```

## When to Use TDD in TypeScript

**Use TDD for**: Business logic, custom hooks, form validation,
async service logic, utility functions, component behavior

**Consider alternatives for**: Visual layout (use Storybook), complex animations,
one-off scripts, exploratory prototypes

## Running Tests During TDD

```bash
npx vitest                              # Watch mode (default)
npx vitest run src/utils/email.test.ts  # Single file
npx vitest run --reporter=verbose       # Show all test names
npx tsc --noEmit && npx vitest run      # Pre-commit
```
