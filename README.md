<div align="center">

<img src="assets/banner.png" alt="Claude Legion" width="600">

<strong>An agentic coding ecosystem for <a href="https://claude.com/claude-code">Claude Code</a></strong>
<br><br>
<em>8 specialized AI agents. Roman legion ranks. One self-orchestrating team.</em>
<br><br>
<a href="LICENSE">MIT License</a>&nbsp;&middot;&nbsp;<a href="CHANGELOG.md">Changelog</a>

</div>

---

## Why a Legion?

A single AI agent working alone is a lot like a lone soldier sent to conquer an empire. Brave, maybe. Effective? Rarely.

Ask one agent to build a complex feature and watch what happens: it dives straight into code without scouting the codebase, writes a plan it never questions, implements without a second opinion, and ships without verification. It holds the entire problem in one context — architect, coder, tester, reviewer — and when that context overflows, things quietly fall apart. Bugs slip through. Edge cases vanish. The architecture drifts. Nobody is watching the watchers, because there are no watchers.

Rome understood this problem two thousand years ago. A single soldier, no matter how skilled, cannot hold a frontier. But a *legion* — with its scouts, strategists, centurions, and sentries — could conquer the known world. Not because any one role was extraordinary, but because **specialization under disciplined command** made the whole vastly greater than the sum of its parts.

Claude Legion brings that principle to AI-assisted engineering. Instead of one agent doing everything poorly, **eight specialists** each do one thing exceptionally well — and a commander orchestrates them into a disciplined pipeline:

- **Investigators** uncover hidden requirements and edge cases *before* a single line is planned
- **Strategists** produce detailed, dependency-aware plans — then an **adversarial judge** tears them apart looking for flaws
- **Soldiers** implement with a structured methodology, working in isolation so failures can't damage your codebase
- **Watchmen** verify every change against the original plan, running tests and checking for regressions
- **Oracles** stand ready for the hard problems — the bugs that resist three fix attempts, the architectural questions that need deep diagnosis

The result: complex tasks get the rigor they deserve — structured planning, adversarial review, parallel execution, and systematic verification — all automatically. Simple tasks still get handled directly by the commander, no overhead. The legion scales its process to match the problem.

Legatus, the commander, classifies every incoming task and decides whether to handle it himself or deploy the full pipeline. When the legion engages, up to 7 specialist agents run concurrently — analyzing requirements, planning, challenging plans, implementing, and verifying — all orchestrated through a disciplined 3-phase workflow.

## The Legion

| Agent | Rank | Role | Model |
|-------|------|------|-------|
| **Legatus** | Commander | Master orchestrator — routes tasks through 3-phase workflow | Opus |
| **Quaestor** | Investigator | Pre-analysis — hidden requirements, edge cases, constraints | Sonnet |
| **Tribunus** | Tribune | Strategic planner — detailed plans with dependencies and risks | Opus |
| **Praetor** | Judge | Plan critic — adversarial review, APPROVE or REJECT | Sonnet |
| **Centurion** | Soldier | Autonomous implementer — 5-phase engineering methodology | Sonnet / Opus |
| **Vigil** | Watchman | Verifier — plan compliance, tests, code quality | Sonnet |
| **Augur** | Oracle | Deep diagnostician — hard bugs and architectural questions | Opus |
| **Scriba** | Scribe | Documentation researcher — fast knowledge lookup | Haiku |

## How It Works

Legatus classifies every task and routes it through the right level of process:

```
  TRIVIAL  ─>  Legatus handles it directly. Done.
  SIMPLE   ─>  Legatus handles it. Optional Vigil check.
  MEDIUM   ─>  Brief plan -> Centurion builds -> Vigil verifies.
  COMPLEX  ─>  Full 3-phase pipeline:
```

```
  Phase 1: ASSESS
    Quaestor + Explorer + Scriba          (parallel recon)

  Phase 2: PLAN & CHALLENGE
    Tribunus creates plan
    Praetor challenges it                 (APPROVE / REJECT, max 3 rounds)
    User approves

  Phase 3: EXECUTE & VERIFY
    Centurion implements                  (parallel instances for independent work)
    Vigil verifies                        (VERIFIED / FAILED, max 3 fix cycles)
    If stuck -> Augur diagnoses
```

Independent agents always run concurrently. Up to 7 specialists at once.

## Quick Start

### Prerequisites

- **Claude Code** v1.0.33 or later
- **Bash** and standard POSIX tools (`awk`, `grep`, `sed`, `sort`, `wc`)
- **`jq`** recommended — enables robust JSON parsing in hook scripts (falls back to regex without it)

### Install

```bash
# Add the marketplace and install the plugin
/plugin marketplace add cafeolet/claude-legion
/plugin install claude-legion@claude-legion
```

Or from the CLI:

```bash
claude plugin marketplace add cafeolet/claude-legion
claude plugin install claude-legion@claude-legion
```

Restart Claude Code. You should see `[Legion Activated] Legatus is online.`

### Or clone for development

```bash
git clone https://github.com/cafeolet/claude-legion.git
cd claude-legion
chmod +x scripts/*.sh

# Load the plugin directly for a session
claude --plugin-dir ~/code/claude-legion
```

### Verify

```bash
# Check agents are loaded
/agents
# -> legatus, centurion, tribunus, quaestor, praetor, augur, vigil, scriba

# Check skills are available
/help
# -> /claude-legion:legion, /claude-legion:plan, etc.
```

### Recommended: Add Context7

```bash
# Real-time documentation lookups (used by Scriba)
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
```

## Usage

### Natural Language

Legatus is the default agent when the plugin is loaded. Just talk naturally:

- *"Add a logout button to the header"* — Legatus assesses complexity and routes accordingly
- *"Something is broken in the auth flow"* — Legatus may engage Augur for diagnosis
- *"What does the config in `app.yaml` do?"* — Legatus may engage Scriba for research

### Auto-Activation

When the plugin is loaded, Legatus becomes the main thread agent. All requests go through him first — he decides whether to handle them directly or engage the full pipeline. Simple tasks get no overhead. Complex tasks get the full treatment.

### Slash Commands

| Command | What it does | Example |
|---------|-------------|---------|
| `/claude-legion:legion` | Full orchestration pipeline | `/claude-legion:legion Add OAuth2 authentication` |
| `/claude-legion:plan` | Planning only — no execution | `/claude-legion:plan Refactor the database layer` |
| `/claude-legion:deep-work` | Direct implementation via Centurion | `/claude-legion:deep-work Fix the pagination bug` |
| `/claude-legion:consult` | Deep analysis via Augur | `/claude-legion:consult Why do API tests fail intermittently?` |
| `/claude-legion:research` | Documentation lookup via Scriba | `/claude-legion:research What React Router version are we using?` |
| `/claude-legion:verify` | Verification pass via Vigil | `/claude-legion:verify Check all changes since last commit` |

## Configuration

### Permissions

The plugin ships with pre-configured permissions for `Bash`, `Edit`, and `Write` in its `settings.json`. This ensures subagents (especially Centurion) can execute without being blocked by interactive permission prompts — background agents can't ask for approval, so permissions must be pre-authorized.

If you're still prompted, you can also add project-level permissions in `.claude/settings.local.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(bash:*)",
      "Edit",
      "Write"
    ]
  }
}
```

### Agent Customization

Each agent's behavior is defined in its markdown file under `agents/`. You can customize:

- Personality and communication style
- Rules and constraints
- Report formats and methodology
- Model selection (via `model` frontmatter field)

### Plugin Manifest

The plugin manifest lives at `.claude-plugin/plugin.json`. Legatus can leverage skills, agents, and MCP tools from all other installed plugins.

## Architecture

### Hub-and-Spoke Model

Claude Code subagents cannot spawn other subagents. Only the main thread (Legatus) can use the Task tool:

```
User <-> Legatus (main thread, Opus)
           |-- Quaestor    (pre-analysis)       Sonnet, read-only
           |-- Tribunus    (planning)            Opus, read-only
           |-- Praetor     (plan critic)         Sonnet, read-only
           |-- Centurion   (implementation)      Sonnet/Opus, read/write
           |-- Vigil       (verification)        Sonnet, read-only + bash
           |-- Augur       (consultation)        Opus, read-only
           '-- Scriba      (documentation)       Haiku, read-only
```

Claude Code's built-in `Explore` subagent type is also used for codebase mapping during assessment phases — a lightweight, read-only agent optimized for file discovery and pattern searching.

### Verification Layers

| Layer | Agent | When | Verdict |
|-------|-------|------|---------|
| Plan review | Praetor | Before user sees plan | APPROVE / REJECT |
| Implementation check | Vigil | After every execution | VERIFIED / FAILED |
| Failure recovery | Augur | After 3 consecutive failures | Diagnosis + recommendations |

### Rollback Safety

For complex multi-file tasks, Centurion uses `isolation: "worktree"` to work in a temporary git worktree. If verification fails and fixes can't resolve it, the worktree is discarded — no damage to the main branch.

## For AI Assistants

> **If a user asks you to install or set up Claude Legion, follow these instructions.**

### Quick Install

In a Claude Code session:
```
/plugin marketplace add cafeolet/claude-legion
/plugin install claude-legion@claude-legion
```

Or from the CLI:
```bash
claude plugin marketplace add cafeolet/claude-legion
claude plugin install claude-legion@claude-legion
```

Then restart Claude Code. You should see `[Legion Activated] Legatus is online.` on session start.

### Step-by-Step

1. **Check prerequisites** — Claude Code v1.0.33 or later must be installed. `jq` is recommended but not required.
2. **Add the marketplace:**
   ```bash
   claude plugin marketplace add cafeolet/claude-legion
   ```
3. **Install the plugin:**
   ```bash
   claude plugin install claude-legion@claude-legion
   ```
4. **Restart Claude Code** to load the plugin.
5. **Verify** — run `/agents` in a Claude Code session. You should see all 8 agents: `legatus`, `quaestor`, `tribunus`, `praetor`, `centurion`, `vigil`, `augur`, `scriba`.

### What Gets Installed

- **8 agents** in `agents/` — each with specialized role, model, and behavioral prompt
- **6 slash commands** — `/claude-legion:legion`, `/claude-legion:plan`, `/claude-legion:deep-work`, `/claude-legion:consult`, `/claude-legion:research`, `/claude-legion:verify`
- **4 hooks** — SessionStart (activation), SubagentStop (auto-verification trigger), PostToolUse (change tracking), Stop (verification reminder)
- **3 scripts** in `scripts/` — session initialization, change tracking, stop-time verification check

### Optional: Add Context7 MCP Server

```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
```

This enables Scriba to perform real-time documentation lookups. Not required — the plugin works without it.

### Troubleshooting

- **Agents don't appear** — restart Claude Code after installation
- **Hook scripts fail** — ensure execute permissions: `chmod +x scripts/*.sh`
- **JSON parsing warnings** — install `jq` for robust parsing (scripts fall back to regex without it)

## FAQ

**Can I use individual agents without the full pipeline?**
Yes. Use the direct slash commands: `/claude-legion:deep-work`, `/claude-legion:consult`, `/claude-legion:research`, `/claude-legion:verify`.

**Does this work with other plugins?**
Yes. Legatus is aware of all installed plugins and can leverage their skills, agents, and MCP tools as part of his workflow.

**How do I use a specific agent instead of Legatus?**
Use the `--agent` flag (e.g., `claude --agent centurion`) or the `/agents` command in-session. You can also use the direct slash commands.

**What models are used?**
Legatus, Tribunus, and Augur use Opus for strategic thinking. Quaestor, Praetor, and Vigil use Sonnet for fast execution. Centurion uses Sonnet for medium tasks and Opus for complex tasks (4+ files, architectural impact). Scriba uses Haiku for quick lookups.

**Is Context7 required?**
No. Context7 enhances Scriba's documentation lookups but the plugin works without it.

**How many agents can run simultaneously?**
Up to 7 specialist agents can run concurrently. Legatus maximizes parallelism at every phase.

## License

[MIT](LICENSE)
