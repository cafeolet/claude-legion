# Changelog

## [1.8.0] — 2026-02-22

### Changed
- Plan files now stored in `.plans/` (gitignored) instead of `docs/plans/` — plans are ephemeral session artifacts
- Brainstorm skill no longer saves designs — delegates to `/plan` which always follows
- `/plan` skill now saves approved plans to `.plans/YYYY-MM-DD-<topic>-plan.md`
- `/legion` skill now saves approved plans to `.plans/` before execution

## [1.7.0] — 2026-02-22

### Added
- Restored `using-legion` skill (`user_invocable: false`) — auto-injects Legion orchestration protocol into every conversation
- "Modifying agent behavior or plugin architecture" added to Brainstorm Gate triggers in both `using-legion` and `legatus.md`
- `AskUserQuestion` enforcement in `using-legion` Standing Orders — always present clickable options, never plain-text questions

### Fixed
- Brainstorm Gate not firing — `settings.json` `agent` key not honored by Claude Code, so `using-legion` skill injection is the reliable auto-activation mechanism

### Changed
- Removed non-working `agent` key from `settings.json` (permissions block retained)

## [1.6.0] — 2026-02-22

### Changed
- Legatus agent prompt now contains full orchestration protocol — brainstorm gate, workflow, and red flags baked into `agents/legatus.md`
- Session init trimmed to status message + cleanup only — behavioral instructions consolidated in agent prompt

### Removed
- `using-legion` skill — orchestration protocol merged directly into Legatus agent prompt, eliminating the need for skill injection

## [1.5.0] — 2026-02-22

### Fixed
- Sub-agents reading files outside their task scope — Centurion's EXPLORE phase tightened from "read all relevant files" to assigned files + direct dependencies only
- Added explicit `FILES:` constraint to Legatus delegation format so sub-agents receive clear read/modify boundaries
- Defined "direct dependency" for non-code files (any file explicitly referenced by name) to prevent directory-wide reads on prompt/config tasks

### Changed
- Legatus delegation format replaced with structured template (TASK, EXPECTED OUTCOME, CONTEXT, CONSTRAINTS with FILES)
- New Centurion rule: "Scope your reads — only read files listed in your assignment plus their direct dependencies"

## [1.4.0] — 2026-02-22

### Added
- TDD validation in the verification pipeline — Vigil now executes the test plan, not just reviews code
- `## Test Plan` section in Tribunus plan format with Automated Tests, Manual Tests, and Test Requirements tables
- Test Plan Execution phase in Vigil (check #2) — runs automated test commands, verifies test file creation, reviews test quality
- `MANUAL VERIFICATION RECOMMENDED` in Vigil verdicts — non-blocking manual test recommendations surfaced to user
- Centurion now writes test files as a deliverable during EXECUTE phase
- `TESTS WRITTEN` and `TEST RESULTS` fields in Centurion report format
- Legatus passes full Test Plan to Vigil and presents manual test recommendations after VERIFIED

### Changed
- Vigil checks reordered: Plan compliance → Test plan execution (new) → Code quality → Regressions
- Vigil verdicts expanded to reference automated test results, test quality, and manual verification
- Centurion VERIFY phase runs written tests before reporting
- Tribunus rules expanded: test scenarios required per step, concrete CLI commands enforced

## [1.3.0] — 2026-02-22

### Added
- `/claude-legion:brainstorm` skill — collaborative design exploration that turns ideas into validated designs through structured dialogue (6 phases: Explore, Clarify, Propose, Design, Document, Transition)
- Brainstorm Gate in `using-legion` — creative work (new features, components, behavior, architecture) must go through brainstorming before implementation
- New red flag: "I don't need to brainstorm this" → New feature/component → brainstorm first

## [1.2.0] — 2026-02-22

### Fixed
- Session-init guard: `[ -n "$LEGION_DIR" ]` changed to `[ -d "$LEGION_DIR" ]` for correct directory check
- Removed `Task` tool from Centurion (subagents cannot spawn subagents)
- Removed `permissionMode: acceptEdits` from Vigil (read-only agent)
- Moved session markers from global `~/.claude-legion` to per-project `.claude-legion/`
- Fixed "3-phase" references to "4-phase" across all agents, skills, and README
- Fixed phase names in legion skill description to "assess, clarify, plan & challenge, execute & verify"
- Normalized worktree isolation threshold from 2+ files to 4+ files
- Fixed SubagentStop double-Vigil by adding idempotency check to Centurion hook prompt
- Removed hardcoded `model: sonnet` from Centurion — model is now specified by Legatus at call-site

### Added
- `user_invocable: false` to using-legion skill
- Centurion model routing: Legatus uses `model: "opus"` for 4+ file tasks
- Worktree Merge Protocol section in Legatus agent
- Plan REJECT escalation: after 3 rounds, present to user with Praetor's concerns
- "Approve with changes" handling in legion skill Phase 3
- Session Markers subsection and `.claude-legion/` gitignore recommendation in README

### Changed
- Legatus description updated to "4-phase workflow (assess, clarify, plan, execute)"
- v1.0.0 changelog entry corrected: "Intent Gate" replaced with "Assess"

## [1.1.2] — 2026-02-22

### Fixed
- SessionStart hook error in v1.1.1 — `type: "prompt"` is not supported on `SessionStart` events (command-only). Moved Legatus routing instructions into `session-init.sh` stdout, which is injected into context by the command hook.

## [1.1.1] — 2026-02-22 [YANKED]

### Fixed
- Legatus not auto-activating on session start — added `type: "prompt"` SessionStart hook. **Broken:** SessionStart only supports `type: "command"` hooks.

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
- 4-phase orchestration pipeline: Assess → Clarify → Plan & Challenge → Execute & Verify
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
