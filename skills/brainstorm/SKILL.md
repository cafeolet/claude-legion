---
name: brainstorm
description: "Collaborative design exploration — turns ideas into validated designs through structured dialogue before any implementation."
user_invocable: true
argument: idea
---

# Brainstorm — Collaborative Design Exploration

The user wants to explore an idea and produce a validated design before any implementation.

## Idea
$ARGUMENTS

## Instructions

### Phase 1: EXPLORE
Spawn assessment agents simultaneously as background agents:
- **Quaestor** (subagent_type: claude-legion:quaestor): Hidden requirements, constraints, edge cases
- **Explore agent** (subagent_type: Explore): Map relevant codebase structure, patterns, conventions
- **Scriba** (subagent_type: claude-legion:scriba): Only if external libs/APIs involved

**WAIT for ALL agents to complete. Read every result before proceeding.**

### Phase 2: CLARIFY
Ask the user questions to pin down the design. Classify each question as **text** (word-described choices) or **visual** (needs ASCII mockups to compare).

Batching rules:
- Ask all text questions first, visual questions last
- Batch up to 4 independent text questions per `AskUserQuestion` call; use multiple batches if more than 4
- Each question gets its own options — never dump all questions with a single toggle
- Ask visual questions **one at a time**, using the `markdown` preview field on each option for ASCII mockups
- When a concept is ambiguous, briefly explain each interpretation and offer them as separate options
- Use `multiSelect: true` when choices aren't mutually exclusive

Focus on: purpose, constraints, success criteria, user preferences.

### Phase 3: PROPOSE
Present 2-3 different approaches with trade-offs. Lead with your recommended approach and explain why.
Use `AskUserQuestion` to let the user choose (options = the approaches). If user picks "Other", ask for their alternative.

### Phase 4: DESIGN
Present the design in sections, scaled to complexity:
- Short sections (few sentences) for straightforward aspects
- Longer sections (up to 200-300 words) for nuanced aspects

After each section, use `AskUserQuestion` to confirm it looks right before proceeding.
Cover as applicable: architecture, components, data flow, error handling, testing approach, UX considerations.
YAGNI ruthlessly — cut anything that isn't clearly needed.
Revise sections based on feedback.

### Phase 5: DOCUMENT
Save the validated design to `docs/plans/YYYY-MM-DD-<topic>-design.md`. Create `docs/plans/` if it doesn't exist.
Do NOT auto-commit — the user will commit when ready.

### Phase 6: TRANSITION
Invoke `/claude-legion:plan` to create a detailed implementation plan from the design.
This is the ONLY terminal action — do NOT invoke any other implementation skill.

<CRITICAL>
HARD GATE: Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until the design is fully presented and approved by the user. This applies regardless of perceived simplicity.
</CRITICAL>

## Anti-Pattern
"This Is Too Simple To Need A Design" — every creative task goes through this process. A todo list, a single-function utility, a config change. The design can be short, but it MUST be presented and approved.

## Key Principles
- Batch independent text questions (up to 4 per call)
- Visual questions last, one at a time with markdown previews
- Surface implicit alternatives — don't assume; offer interpretations
- Multiple-choice preferred over open-ended
- YAGNI ruthlessly
- Always propose 2-3 approaches before settling
- Incremental validation — present design sections, get approval
- Be flexible — revise when feedback requires it
