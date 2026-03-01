# Deploy skill references to docs/best-practices/ (copy-if-not-exists)
# Requires: PLUGIN_DIR set by caller
# Appends to: DEPLOYED array (caller must initialize)

mkdir -p docs/best-practices
for ref in "$PLUGIN_DIR"/skills/*/references/*.md; do
  [ -f "$ref" ] || continue
  target="docs/best-practices/$(basename "$ref")"
  if [ ! -f "$target" ]; then
    cp -L "$ref" "$target"
    DEPLOYED+=("doc: $(basename "$ref")")
  fi
done
