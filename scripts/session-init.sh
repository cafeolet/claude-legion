#!/usr/bin/env bash
set -euo pipefail
# Claude Legion — Session Initialization

# Clean up previous session markers
LEGION_DIR="${HOME}/.claude-legion"
[ -n "$LEGION_DIR" ] && rm -f "${LEGION_DIR}/changes.log" "${LEGION_DIR}/vigil-ran"

cat << 'EOF'
SessionStart:startup hook success: [Legion Activated] Legatus is online.

LEGION STATUS:
- Commander: Legatus (opus) — orchestrating
- Available specialists: Quaestor, Tribunus, Praetor, Centurion, Vigil, Augur, Scriba
- Skills: /claude-legion:legion, /claude-legion:plan, /claude-legion:deep-work, /claude-legion:consult, /claude-legion:research, /claude-legion:verify

The Legion stands ready.
EOF
