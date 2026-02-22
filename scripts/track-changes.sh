#!/usr/bin/env bash
set -euo pipefail
# Claude Legion — Change Tracker
# Logs modified files for Vigil's plan compliance check
# Called asynchronously on Write/Edit tool use

LEGION_DIR=".claude-legion"
CHANGES_LOG="${LEGION_DIR}/changes.log"

# Ensure directory exists
mkdir -p "$LEGION_DIR"

# Extract file_path from TOOL_INPUT JSON (available in PostToolUse hooks)
# Try jq first (robust JSON parsing), fall back to regex
if command -v jq &>/dev/null; then
  FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // empty')
else
  FILE_PATH=$(echo "$TOOL_INPUT" | grep -o '"file_path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*"file_path"\s*:\s*"//;s/"$//')
fi

if [ -n "$FILE_PATH" ]; then
  TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  # Tab-delimited format to handle file paths with spaces
  printf '%s\t%s\n' "$TIMESTAMP" "$FILE_PATH" >> "$CHANGES_LOG"
fi
