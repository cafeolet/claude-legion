---
name: plan
description: "Planning only — Quaestor investigates, Tribunus plans, Praetor reviews. No execution."
user_invocable: true
argument: task
---

# Plan — Planning Pipeline Only

The user wants a plan without execution. Run the planning phases only.

## Task
$ARGUMENTS

## Instructions

Execute the planning workflow without implementation:

1. **Assess complexity** — Classify the task:
   - **Simple** (single file, clear scope): Skip to step 2 — create the plan yourself directly, no assessment agents needed.
   - **Medium/Complex** (2+ files, non-obvious scope): Spawn assessment agents simultaneously as background agents:
     - **Quaestor** (subagent_type: general-purpose, model: sonnet): Analyze hidden requirements, edge cases, constraints
     - **Explore agent** (subagent_type: Explore): Map relevant codebase, find key files and patterns
     - **Scriba** (subagent_type: general-purpose, model: haiku): Only if the task involves external libraries, unfamiliar APIs, or documentation questions — skip for internal-only tasks

2. **Plan** — Synthesize findings and either:
   - Create the plan yourself for medium-complexity tasks
   - Spawn **Tribunus** (subagent_type: general-purpose, model: opus) for complex multi-component tasks

3. **Challenge** — Spawn **Praetor** (subagent_type: general-purpose, model: sonnet) to review the plan
   - If REJECTED: revise and resubmit (max 3 cycles)

4. **Present** — Show the approved plan to the user with:
   - What will change
   - What files are affected
   - Risks and mitigations
   - Verification criteria

Do NOT proceed to execution. The user wants the plan only.

Always provide each spawned agent with its full agent prompt from `${CLAUDE_PLUGIN_ROOT}/agents/` as the beginning of its task description.
