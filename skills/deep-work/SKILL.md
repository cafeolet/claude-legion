---
name: deep-work
description: "Direct implementation — Centurion executes autonomously with full engineering methodology."
user_invocable: true
argument: task
---

# Deep Work — Direct Implementation

The user wants direct implementation without the full planning pipeline. Deploy the Centurion.

## Task
$ARGUMENTS

## Instructions

Spawn a **Centurion** agent for direct autonomous implementation:

1. Read the Centurion agent prompt from `${CLAUDE_PLUGIN_ROOT}/agents/centurion.md`
2. Spawn the agent (subagent_type: general-purpose, model: sonnet) with:
   - The full Centurion system prompt
   - The task description
   - Any relevant context about the codebase

The Centurion will execute its 5-phase methodology autonomously:
EXPLORE -> PLAN -> DECIDE -> EXECUTE -> VERIFY

After the Centurion completes, spawn **Vigil** (subagent_type: general-purpose, model: sonnet) to verify the implementation. Present results to the user.

For tasks touching 2+ files, use `isolation: "worktree"` for safety.
