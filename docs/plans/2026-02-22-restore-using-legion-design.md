# Design: Restore `using-legion` Skill

**Date:** 2026-02-22
**Version:** 1.7.0
**Status:** Approved

## Problem

v1.6.0 deleted the `using-legion` skill (`user_invocable: false`) and moved its content into `agents/legatus.md`, relying on the `settings.json` `"agent": "legatus"` key to make Legatus the active agent. However, the `agent` key is not being honored — the main Claude Code agent runs without any Legion orchestration instructions, causing:

1. **Brainstorm Gate never fires** — new features go straight to implementation without design
2. **Complexity assessment skipped** — no TRIVIAL/SIMPLE/MEDIUM/COMPLEX routing
3. **Verification skipped** — code changes aren't automatically checked by Vigil
4. **AskUserQuestion not used** — Legatus asks free-text questions instead of presenting options

## Root Cause

The `using-legion` skill with `user_invocable: false` was the working auto-injection mechanism. Its description stays in context and Claude can invoke it when relevant. The `settings.json` `agent` key, while documented, is not functioning — possibly a Claude Code bug or multi-plugin interaction issue.

## Solution

Restore `using-legion` as the proven enforcement mechanism. Remove the non-working `agent` key from `settings.json`.

## Changes

### 1. Create `skills/using-legion/SKILL.md`

Restore with Standing Orders content plus two new improvements:
- **Brainstorm Gate**: Add "Modifying agent behavior or plugin architecture" as explicit trigger
- **AskUserQuestion rule**: Always use AskUserQuestion with options, never plain-text questions

Content: CRITICAL identity + Brainstorm Gate + Workflow + Red Flags + Ask the User section.

### 2. Update `settings.json`

Remove `"agent": "legatus"` key. Keep `permissions` block.

### 3. Update `agents/legatus.md`

Add "Modifying agent behavior or plugin architecture" to Brainstorm Gate triggers (aligning with using-legion).

### 4. Version bump

- `plugin.json` → 1.7.0
- `marketplace.json` → 1.7.0
- `CHANGELOG.md` → new [1.7.0] entry

### 5. Update design doc

Mark the v1.6.0 eliminate-using-legion design as superseded.
