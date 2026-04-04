---
title: Vite Conventions Reference
version: 1.0
applies-to: Agents and humans
purpose: Vite project structure, configuration, and deployment conventions
see-also: typescript-best-practices.md, react-best-practices.md
---

## Project Structure

```text
├── public/              # Static assets (served as-is)
├── src/
│   ├── assets/          # Processed assets (imported in code)
│   ├── components/      # Shared React components
│   ├── hooks/           # Custom hooks
│   ├── lib/             # Utilities and helpers
│   ├── pages/           # Route-level components
│   ├── types/           # Shared TypeScript types
│   ├── App.tsx          # Root component
│   └── main.tsx         # Entry point
├── index.html           # HTML entry (Vite serves this)
├── vite.config.ts
├── tsconfig.json
└── package.json
```

## Configuration

### vite.config.ts

```typescript
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: { '@': '/src' },
  },
});
```

### Path Aliases

Configure in both `vite.config.ts` and `tsconfig.json`:

```json
{
  "compilerOptions": {
    "paths": { "@/*": ["./src/*"] }
  }
}
```

Use `@/` prefix for all internal imports: `import { Button } from '@/components/Button'`.

## Environment Variables

### Access Pattern

```typescript
// Vite exposes variables prefixed with VITE_
const apiUrl = import.meta.env.VITE_API_URL;

// Type-safe env
interface ImportMetaEnv {
  readonly VITE_API_URL: string;
  readonly VITE_APP_TITLE: string;
}
```

### .env Files

```text
.env                # Shared defaults
.env.local          # Local overrides (gitignored)
.env.production     # Production values
```

Never prefix secrets with `VITE_` — they are embedded in the client bundle.

## Build and Deployment

### Base Path

```typescript
// For subdirectory deployment (e.g., GitHub Pages)
export default defineConfig({
  base: '/my-repo/',
});
```

### Build Output

```bash
npx vite build          # Output to dist/
npx vite preview        # Preview production build locally
```

## Tailwind CSS v4 (Vite Plugin)

```typescript
// vite.config.ts — use @tailwindcss/vite plugin (v4)
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  plugins: [react(), tailwindcss()],
});
```

```css
/* src/index.css — v4 uses @import instead of @tailwind directives */
@import 'tailwindcss';
```

No `tailwind.config.js` needed in v4 — configure via CSS `@theme`.

## Common Mistakes

| Mistake | Impact | Fix |
|---------|--------|-----|
| Secret in `VITE_` var | Leaked to client | Use server-side env only |
| Missing `base` for subpath | Broken asset paths | Set `base` in config |
| Wrong alias in tsconfig | TS errors despite Vite working | Sync both configs |
| `tailwind.config.js` with v4 | Ignored config | Use CSS `@theme` blocks |
