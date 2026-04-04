---
paths:
  - "src/**/*.test.ts"
  - "src/**/*.test.tsx"
  - "tests/**/*.ts"
---

# Testing Rules (TypeScript)

- Use vitest with @testing-library/react for component tests
- Mock external dependencies with vi.mock()
- Use jsdom environment for DOM tests
- Mirror src/ structure in tests
- Test behavior, not implementation details
- Use Arrange-Act-Assert structure
- Prefer userEvent over fireEvent for interactions
