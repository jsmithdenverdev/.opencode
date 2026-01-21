#!/usr/bin/env bash
set -euo pipefail

# Lint opencode.json against the public JSON schema

SCHEMA_URL="https://opencode.ai/config.json"
SCHEMA_FILE=".schema-cache/config-schema.json"
CONFIG_FILE="opencode.json"

# Create cache directory
mkdir -p .schema-cache

# Download schema if not cached or force refresh
if [ ! -f "$SCHEMA_FILE" ] || [ "${FORCE_REFRESH:-}" = "true" ]; then
  echo "Downloading schema from $SCHEMA_URL..."
  curl -s -o "$SCHEMA_FILE" "$SCHEMA_URL"
fi

# Step 1: Validate JSON syntax
echo "Validating JSON syntax..."
if ! jq empty "$CONFIG_FILE" 2>/dev/null; then
  echo "❌ Invalid JSON syntax in $CONFIG_FILE"
  exit 1
fi

# Step 2: Validate against schema
echo "Validating against schema..."
npx -y ajv-cli validate \
  --spec=draft2020 \
  --strict=false \
  --allow-union-types \
  -s "$SCHEMA_FILE" \
  -d "$CONFIG_FILE"

echo "✓ Validation successful!"
