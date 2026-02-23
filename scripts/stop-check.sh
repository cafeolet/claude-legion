#!/usr/bin/env bash
set -euo pipefail
# Claude Legion — Stop Hook
# Deterministic check: warn if complex changes were made without Vigil verification
# Note: The vigil-ran marker is a single advisory flag. In parallel-Vigil workflows,
# one Vigil completing satisfies the check even if others failed.

LEGION_DIR=".legion"
CHANGES_LOG="${LEGION_DIR}/changes.log"
VIGIL_MARKER="${LEGION_DIR}/vigil-ran"

# No changes logged → no warning needed
[ ! -f "$CHANGES_LOG" ] && exit 0

# Count unique files changed this session (tab-delimited log: TIMESTAMP\tFILE_PATH)
UNIQUE_FILES=$(awk -F'\t' '{print $2}' "$CHANGES_LOG" | sort -u | wc -l | tr -d ' ')
UNIQUE_FILES=${UNIQUE_FILES:-0}

# Simple/trivial (0-1 files) → no warning
[ "$UNIQUE_FILES" -lt 2 ] && exit 0

# Complex/medium changes exist — check if Vigil ran
if [ -f "$VIGIL_MARKER" ]; then
  exit 0
fi

# Complex changes without Vigil → warn (exit 2 = non-blocking warning)
echo "[Legion] ${UNIQUE_FILES} files were modified without Vigil verification. Consider running /claude-legion:verify."
exit 2
