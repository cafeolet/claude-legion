# Changelog

## [1.0.0] — 2026-02-21

### Added
- 8 agents: Legatus, Quaestor, Tribunus, Praetor, Centurion, Vigil, Augur, Scriba
- 6 skills: legion, plan, deep-work, consult, research, verify
- Hooks: SessionStart, SubagentStop, PostToolUse, Stop
- 3-phase orchestration pipeline: Intent Gate → Plan & Challenge → Execute & Verify
- `scripts/stop-check.sh` — deterministic stop-time verification reminder
- SubagentStop vigil hook — creates marker file so stop-check knows Vigil ran
- Session cleanup of `changes.log` and `vigil-ran` markers on SessionStart

### Details
- Shell scripts use `set -euo pipefail` with `jq` for robust JSON parsing (grep/sed fallback)
- Change log uses tab-delimited format to handle file paths with spaces
- Agent path references use `${CLAUDE_PLUGIN_ROOT}/agents/` for portability
- Stop hook is a deterministic `command` script (no wasted API calls)
- Scriba is conditional — only spawned when external docs are needed
- Vigil handles test-less projects gracefully
- Centurion supports worktree isolation for multi-file tasks
- `/deep-work` uses worktree isolation for tasks touching 2+ files
