---
name: research
description: "Documentation lookup — Scriba researches project docs, dependencies, and code patterns."
user_invocable: true
argument: topic
---

# Research — Documentation Lookup

The user wants documentation research from the Scriba.

## Topic
$ARGUMENTS

## Instructions

Spawn a **Scriba** agent for documentation research:

1. Read the Scriba agent prompt from `${CLAUDE_PLUGIN_ROOT}/agents/scriba.md`
2. Spawn the agent (subagent_type: general-purpose, model: haiku) with:
   - The full Scriba system prompt
   - The research topic/question
   - The project's root directory for context

The Scriba will:
- Search project documentation
- Check dependency files and versions
- Read relevant code patterns
- Use MCP tools (Context7, etc.) if available for external docs

Present the Scriba's research report to the user.
