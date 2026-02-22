# Changelog

## [1.1.1] — 2026-02-22

### Fixed
- Legatus not auto-activating on session start — the `using-legion` skill had no injection mechanism, so routing instructions were never loaded into context. Added a `type: "prompt"` SessionStart hook that injects Legatus routing instructions directly into every conversation.

## [1.1.0] — 2026-02-22

### Added
- `using-legion` skill — non-user-invocable skill that auto-activates Legatus on every conversation (Superpowers pattern)
- Phase 2 "Clarify with User" — Legatus now asks clarifying questions with `AskUserQuestion` (including `multiSelect`) BEFORE planning
- Pre-authorized permissions in `settings.json` — Bash, Edit, Write shipped with the plugin so background agents don't get blocked
- `tools` and `permissionMode` frontmatter on Centurion and Vigil agents
- Rule 9 on Legatus: never bypass agents due to permission errors — guide the user instead

### Changed
- All 8 agents rewritten for token efficiency — ~60% size reduction (780 lines removed, 278 added)
- All 6 skills now use proper `subagent_type: claude-legion:*` instead of `general-purpose` (agents load automatically, no manual file reads)
- Legatus and all pipeline skills enforce WAIT for sub-agents before proceeding
- Session init script simplified — cleanup + status message only (using-legion skill handles activation)
- README permissions section updated — explains permissions are now automatic

### Fixed
- Centurion blocked on permissions in new projects — background agents can't prompt interactively, now pre-authorized via plugin settings
- Legatus racing ahead before sub-agents complete — explicit WAIT instructions added
- Plan reviews happening after final decisions — Praetor now reviews before user sees the plan
- Legatus never asking multiSelect questions — enforced in Phase 2 workflow
- Skills reading agent .md files unnecessarily — proper subagent_types eliminate redundant file reads

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
