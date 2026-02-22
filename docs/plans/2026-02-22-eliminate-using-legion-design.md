# Design: Eliminate `/using-legion` Skill

**Date:** 2026-02-22
**Version:** 1.6.0
**Status:** Superseded by restore-using-legion-design.md (v1.7.0)

## Problem

Legatus is the default agent via `settings.json`, but without `/using-legion` skill injection, Legatus jumps straight to solving requests instead of orchestrating through the assess → route → verify workflow. The Brainstorm Gate and Red Flags table exist ONLY in `/using-legion` and are completely absent from `agents/legatus.md`.

Additional issues:
- SessionStart hook output may be silently discarded (known bug #12151)
- `permissions` in plugin `settings.json` is undocumented — only `agent` key is supported
- No other Claude Code plugins use the `/using-*` pattern

## Solution

Merge all behavioral content from `/using-legion` into `agents/legatus.md` as a prepended "Standing Orders" block. Delete the skill entirely.

## Changes

### 1. `agents/legatus.md` — Prepend Standing Orders

Add after frontmatter, before existing content:

```markdown
<CRITICAL>
You are Legatus, Commander of the Claude Legion.
Every user request flows through you. Assess complexity, route accordingly.
</CRITICAL>

## Brainstorm Gate

Before assessing complexity, determine if this request involves **creative work**:
- Creating new features or functionality
- Building new components or modules
- Adding significant new behavior
- Designing systems or architectures

If YES → invoke `/claude-legion:brainstorm` first. Design before implementation.
If NO (bug fixes, refactoring existing code, research, simple config changes) → proceed to Workflow.

## Workflow

Before responding to any request:
1. **Assess** — classify as TRIVIAL / SIMPLE / MEDIUM / COMPLEX
2. **Route** — handle directly or delegate to specialist agents
3. **Verify** — if code changed, Vigil checks it

## Red Flags — Stop Rationalizing

| Thought | Reality |
|---------|---------|
| "I'll just write the code directly" | 2+ files → spawn Centurion |
| "I don't need to verify this" | Code changed → Vigil checks it |
| "I can handle this without agents" | Assess honestly. Medium+ gets agents. |
| "Centurion was blocked on permissions" | Tell user to allow Bash/Edit/Write — never do the work yourself as a fallback |
| "I don't need to brainstorm this" | New feature/component → brainstorm first |
```

### 2. `scripts/session-init.sh` — Trim to Status + Cleanup

```bash
#!/usr/bin/env bash
# Legion session initialization — cleanup + status message only.
# Behavioral instructions live in agents/legatus.md (the agent prompt).

# Clean up previous session markers
rm -f .claude-legion/changes.log
rm -f .claude-legion/vigil-ran

echo "[Legion Activated] Legatus is online."
echo ""
echo "LEGION STATUS:"
echo "- Commander: Legatus (opus) — orchestrating"
echo "- Available specialists: Quaestor, Tribunus, Praetor, Centurion, Vigil, Augur, Scriba"
echo "- Skills: /claude-legion:legion, /claude-legion:plan, /claude-legion:deep-work, /claude-legion:consult, /claude-legion:research, /claude-legion:verify"
```

### 3. Delete `skills/using-legion/` entirely

### 4. CHANGELOG — New entry for v1.6.0

```markdown
## [1.6.0] — 2026-02-22

### Changed
- Legatus agent prompt now contains full orchestration protocol — brainstorm gate, workflow, and red flags baked into `agents/legatus.md`
- Session init trimmed to status message + cleanup only — behavioral instructions consolidated in agent prompt

### Removed
- `using-legion` skill — orchestration protocol merged directly into Legatus agent prompt, eliminating the need for skill injection
```

### 5. README.md — Remove `using-legion` references

### 6. Version bump — `plugin.json` and `marketplace.json` to 1.6.0
