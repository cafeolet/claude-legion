---
name: consult
description: "Deep analysis — Augur investigates hard bugs, architectural questions, and failure patterns."
user_invocable: true
argument: question
---

# Consult — Deep Analysis

The user wants deep analysis from the Augur on a difficult problem.

## Question
$ARGUMENTS

## Instructions

Spawn an **Augur** (subagent_type: claude-legion:augur) with:
- The user's question
- Any relevant context (error messages, file paths, prior attempts)

The Augur will:
- Form ranked hypotheses
- Investigate the codebase for evidence
- Diagnose root causes
- Provide ranked recommendations

Present the Augur's full diagnosis to the user.
