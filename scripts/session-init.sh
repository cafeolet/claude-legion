#!/usr/bin/env bash
set -euo pipefail

# Legion session initialization — cleanup + status message only.
# Behavioral instructions live in agents/legatus.md (the agent prompt).

LEGION_DIR=".claude-legion"

# Clean up previous session markers
[ -d "$LEGION_DIR" ] && rm -f "$LEGION_DIR/changes.log" "$LEGION_DIR/vigil-ran"

echo "[Legion Activated] Legatus is online."
echo ""
echo "LEGION STATUS:"
echo "- Commander: Legatus (opus) — orchestrating"
echo "- Available specialists: Quaestor, Tribunus, Praetor, Centurion, Vigil, Augur, Scriba"
echo "- Skills: /claude-legion:legion, /claude-legion:plan, /claude-legion:deep-work, /claude-legion:consult, /claude-legion:research, /claude-legion:verify"
