---
name: verify
description: "Verification pass — Vigil checks plan compliance, runs tests, validates code quality."
user_invocable: true
argument: scope
---

# Verify — Verification Pass

The user wants a verification pass on recent changes.

## Scope
$ARGUMENTS

## Instructions

Spawn a **Vigil** (subagent_type: claude-legion:vigil) with:
- The user's scope (if specified) or instruction to check all recent changes
- Any relevant plan or task context

The Vigil will:
- Check code quality of all changed files
- Run the project's test suite
- Run linters if configured
- Check for regressions

Present the Vigil's verification report to the user with a clear VERIFIED or FAILED verdict.
