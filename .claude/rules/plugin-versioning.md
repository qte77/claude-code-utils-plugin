# Plugin Versioning

When modifying any file under `plugins/<name>/`, you MUST:

1. Bump that plugin's `version` in `plugins/<name>/.claude-plugin/plugin.json`
2. Bump the matching `version` in `.claude-plugin/marketplace.json` for the same plugin
3. Both versions MUST match

This is required because installed plugins are cached — users won't receive
fixes without a version bump.
