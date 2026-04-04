---
title: TypeScript Best Practices Reference
version: 1.0
applies-to: Agents and humans
purpose: Type-safe TypeScript coding standards with strict mode and modern patterns
see-also: react-best-practices.md, vite-conventions.md
---

## Strict Mode (Non-Negotiable)

### tsconfig.json Essentials

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "moduleResolution": "bundler",
    "module": "ESNext",
    "target": "ES2022",
    "isolatedModules": true,
    "skipLibCheck": true
  }
}
```

All projects must use `strict: true`. Never disable individual strict checks.

### Secrets Management

```typescript
const config = {
  apiKey: process.env.API_KEY ?? throwEnvError('API_KEY'),
  dbUrl: process.env.DATABASE_URL ?? throwEnvError('DATABASE_URL'),
};

function throwEnvError(name: string): never {
  throw new Error(`Missing environment variable: ${name}`);
}
```

Never hardcode credentials in source code.

## Type System

### Prefer unknown Over any

```typescript
// BAD — disables type checking
function parse(input: any): User { ... }

// GOOD — forces type narrowing
function parse(input: unknown): User {
  if (!isUser(input)) throw new TypeError('Invalid user data');
  return input;
}
```

### Type Guards Over Casts

```typescript
// BAD — bypasses type checking
const user = data as User;

// GOOD — runtime validation
function isUser(data: unknown): data is User {
  return typeof data === 'object' && data !== null && 'id' in data;
}
```

### Discriminated Unions

Model exclusive states with a literal discriminant:

```typescript
type RequestState =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success'; data: User[] }
  | { status: 'error'; error: string };
```

The compiler enforces exhaustive handling with `switch` on `status`.

### Proper Null Handling

```typescript
// Use nullish coalescing and optional chaining
const name = user?.profile?.displayName ?? 'Anonymous';

// Use strict null checks — never assume values exist
function getItem(id: string): Item | undefined { ... }
```

## Error Handling

### Result Pattern (for expected errors)

```typescript
type Result<T, E = Error> = { ok: true; value: T } | { ok: false; error: E };

function parseConfig(raw: string): Result<Config> {
  try {
    return { ok: true, value: JSON.parse(raw) };
  } catch (e) {
    return { ok: false, error: new Error('Invalid config JSON') };
  }
}
```

### Try/Catch (for unexpected errors)

```typescript
async function fetchUser(id: string): Promise<User> {
  const res = await fetch(`/api/users/${id}`);
  if (!res.ok) throw new HttpError(res.status, await res.text());
  return res.json() as Promise<User>;
}
```

## Modules and Imports

### ESM-First

```typescript
// Named exports preferred
export function createUser(data: UserInput): User { ... }
export type { User, UserInput };

// Avoid default exports (harder to refactor, inconsistent naming)
```

### Import Order

```typescript
// 1. Node/framework builtins
import { useEffect } from 'react';
// 2. External packages
import { z } from 'zod';
// 3. Internal modules
import { createUser } from '@/services/user';
// 4. Types
import type { User } from '@/types';
```

## Generics

```typescript
// Constrained generics for type-safe utilities
function groupBy<T, K extends string>(items: T[], key: (item: T) => K): Record<K, T[]> { ... }

// Inferred generics — let TypeScript infer when possible
const result = groupBy(users, (u) => u.role);
```

## Async Patterns

### Promise.allSettled for Concurrent Operations

```typescript
const results = await Promise.allSettled([
  fetchUser(id),
  fetchOrders(id),
  fetchPreferences(id),
]);

const [user, orders, prefs] = results.map((r) =>
  r.status === 'fulfilled' ? r.value : null
);
```

### AbortController for Cancellation

```typescript
const controller = new AbortController();
const res = await fetch(url, { signal: controller.signal });
```

## Common Mistakes

| Mistake | Impact | Fix |
|---------|--------|-----|
| Using `any` | Disables type safety | Use `unknown` + type guards |
| Type assertions (`as`) | Bypasses checking | Use type guards |
| Missing `noUncheckedIndexedAccess` | Silent undefined | Enable in tsconfig |
| Barrel imports of large libs | Bundle bloat | Import specific modules |
| `!` non-null assertion | Runtime errors | Handle null/undefined properly |
| Enum (numeric) | Loose typing | Use `as const` objects or unions |
| `export default` | Refactoring hazard | Use named exports |

## Pre-Commit Checklist

### Type Safety
- [ ] No `any` types in production code
- [ ] `strict: true` enabled
- [ ] No type assertions without justification
- [ ] Discriminated unions for state variants

### Code Quality
- [ ] Named exports used consistently
- [ ] ESM imports with proper ordering
- [ ] No hardcoded secrets or credentials
- [ ] All external input validated at boundaries

### Testing and Validation
- [ ] Unit tests for new logic
- [ ] `npx tsc --noEmit` passes
- [ ] `npx vitest run` passes
- [ ] `npx eslint .` passes
