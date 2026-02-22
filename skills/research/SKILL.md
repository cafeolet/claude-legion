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

Spawn a **Scriba** (subagent_type: claude-legion:scriba) with:
- The research topic/question
- The project's root directory for context

The Scriba will:
- Search project documentation
- Check dependency files and versions
- Read relevant code patterns
- Use MCP tools (Context7, etc.) if available for external docs

Present the Scriba's research report to the user.
