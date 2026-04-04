---
title: React Best Practices Reference
version: 1.0
applies-to: Agents and humans
purpose: Modern React patterns with functional components, hooks, and accessibility
see-also: typescript-best-practices.md, vite-conventions.md
---

## Components

### Functional Components Only

```tsx
interface UserCardProps {
  user: User;
  onSelect: (id: string) => void;
}

export function UserCard({ user, onSelect }: UserCardProps) {
  return (
    <button onClick={() => onSelect(user.id)} type="button">
      {user.name}
    </button>
  );
}
```

Always type props with an interface. Never use class components.

### Component Organization

```typescript
// 1. Types/interfaces
// 2. Component function
// 3. Internal helpers (below component)
// One component per file (collocate sub-components if small)
```

## Hooks

### Custom Hook Extraction

Extract shared logic into custom hooks:

```typescript
function useDebounce<T>(value: T, delay: number): T {
  const [debounced, setDebounced] = useState(value);
  useEffect(() => {
    const timer = setTimeout(() => setDebounced(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);
  return debounced;
}
```

### useEffect Dependency Arrays

```typescript
// GOOD — all dependencies listed, cleanup returned
useEffect(() => {
  const controller = new AbortController();
  fetchData(id, { signal: controller.signal }).then(setData);
  return () => controller.abort();
}, [id]);

// BAD — missing dependency, stale closure
useEffect(() => {
  fetchData(id).then(setData);
}, []); // eslint will warn about missing 'id'
```

### Memoization Guidance

```typescript
// DO use when: passing callbacks to memoized children, expensive computations
const handleSubmit = useCallback((data: FormData) => {
  submitForm(data);
}, [submitForm]);

// DON'T use for: simple values, inline functions in non-memoized components
// Premature memoization adds complexity without benefit
```

## State Management

### Local State First

Start with `useState`. Lift state up only when shared. Reach for context or
external stores only when prop drilling becomes painful.

```typescript
// Simple state
const [count, setCount] = useState(0);

// Complex state — useReducer
const [state, dispatch] = useReducer(reducer, initialState);
```

### React 19 Patterns

```typescript
// use() for promises and context
const data = use(dataPromise);

// Actions for form handling
async function createAction(formData: FormData) {
  'use server';
  await saveToDb(formData);
}
```

## Keys

```tsx
// GOOD — stable, unique identifier
{items.map((item) => <ListItem key={item.id} item={item} />)}

// BAD — array index (breaks on reorder/filter)
{items.map((item, i) => <ListItem key={i} item={item} />)}
```

## Accessibility

### Semantic HTML

```tsx
// GOOD — semantic elements
<nav aria-label="Main navigation">
  <button type="button" onClick={toggle}>Menu</button>
</nav>

// BAD — div soup
<div onClick={toggle}>Menu</div>
```

### Required Practices

- All interactive elements keyboard-accessible (tab, enter, escape)
- Images have `alt` text (decorative: `alt=""`)
- Form inputs have associated `<label>` elements
- ARIA attributes for dynamic content (`aria-live`, `aria-expanded`)
- Color contrast meets WCAG AA (4.5:1 text, 3:1 large text)

## Common Mistakes

| Mistake | Impact | Fix |
|---------|--------|-----|
| Missing key prop | Broken reconciliation | Use stable unique id |
| Object/array in deps | Infinite re-renders | Memoize or restructure |
| State for derived data | Stale values | Compute during render |
| Missing cleanup in useEffect | Memory leaks | Return cleanup function |
| Non-interactive div with onClick | Inaccessible | Use `<button>` |
| Index as key | Broken reorder | Use stable id |
