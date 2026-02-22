---
name: plan
description: "Planning only — Quaestor investigates, Tribunus plans, Praetor reviews. No execution."
user_invocable: true
argument: task
---

# Plan — Planning Pipeline Only

The user wants a plan without execution.

## Task
$ARGUMENTS

## Instructions

### Step 1: ASSESS
For simple tasks (single file, clear scope): skip to Step 3.

For Medium/Complex, spawn assessment agents simultaneously as background agents:
- **Quaestor** (subagent_type: claude-legion:quaestor): Hidden requirements, edge cases
- **Explore agent** (subagent_type: Explore): Map relevant codebase
- **Scriba** (subagent_type: claude-legion:scriba): Only if external libs/APIs involved

**WAIT for ALL agents to complete. Read every result.**

### Step 2: CLARIFY WITH USER
Use `AskUserQuestion` to clarify ambiguities, scope, and approach choices BEFORE planning.
Use `multiSelect: true` when choices aren't mutually exclusive.
**Do NOT plan until the user has answered.**

### Step 3: PLAN
Incorporate user answers. Either:
- Create the plan yourself (medium tasks)
- Spawn **Tribunus** (subagent_type: claude-legion:tribunus) for complex tasks. **WAIT for result.**

### Step 4: CHALLENGE
Spawn **Praetor** (subagent_type: claude-legion:praetor). **WAIT for verdict.**
If REJECTED: revise and resubmit (max 3 rounds). If still REJECTED after 3 rounds, present the last plan to the user with Praetor's concerns and let the user decide: proceed anyway, modify scope, or abandon.

### Step 5: PRESENT
Show the approved plan: what changes, affected files, risks, verification criteria.

### Step 6: SAVE
Save the approved plan to `.plans/YYYY-MM-DD-<topic>-plan.md`. Create `.plans/` if it doesn't exist.
Do NOT auto-commit — the user will commit when ready.

Do NOT proceed to execution. The user wants the plan only.
