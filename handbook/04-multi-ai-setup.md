# 04 — Multi-AI setup: connecting every AI to the vault

> TL;DR: Four AIs, four config patterns. Claude Code via a global CLAUDE.md
> with `@-import`. Gemini CLI the same. Codex CLI the same. Claude Desktop via
> a Filesystem MCP server. Perplexity has no native binding — the workaround is
> Obsidian Web Clipper with an OpenRouter interpreter.

## Prerequisite: the vault exists

Before you connect any AI, the vault has to exist:

1. Install [Obsidian](https://obsidian.md) (free)
2. Create a new vault at `~/Obsidian/SecondBrain/` (or your own path — then
   update it everywhere in the configs)
3. Copy the templates from `templates/vault/` into the vault:
   - `templates/vault/CLAUDE.md` → `~/Obsidian/SecondBrain/CLAUDE.md`
   - `templates/vault/AGENTS.md` → `~/Obsidian/SecondBrain/AGENTS.md` (only if you use Codex)
   - `templates/vault/00 Kontext/` → `~/Obsidian/SecondBrain/00 Kontext/`
4. Create the eight PARA folders (see chapter 03):
   `mkdir -p "01 Inbox" "02 Projekte" ...`
5. **Recommended Obsidian plugins:**
   - **Dataview** (required — the hub files use Dataview queries)
   - **Templater** (optional, for your own templates)
   - **Excalidraw** (optional, for embedded diagrams)
   - **Obsidian Web Clipper** (a separate browser extension — see Perplexity below)

## Claude Code

Claude Code is the CLI flavor of Claude and the "default" of this setup (which
is why the vault file is called `CLAUDE.md`).

### Setup

1. Install Claude Code (see [docs.claude.com/claude-code](https://docs.claude.com/claude-code))
2. Create the global config:
   ```bash
   mkdir -p ~/.claude
   cp <repo>/templates/claude/CLAUDE.md ~/.claude/CLAUDE.md
   ```
3. In `~/.claude/CLAUDE.md` verify the vault path — it must point to your
   actual vault.

### What makes Claude Code special

- **Skills** via slash commands: `/projekt-init`, `/lint`, `/ingest`, etc. The
  three vault-centric skills are in `skills/` in this repo.
- **MCP servers** for external integrations (Linear, M365, etc.).
- **Sub-agents** for parallel complex tasks.

### Verification

Start Claude Code in any directory and say:

```
"What's in my inbox?"
```

If Claude lists the inbox notes from `01 Inbox/`, the binding works.

## Gemini CLI

Gemini CLI is Google's official CLI tool for Gemini models.

### Setup

1. Install Gemini CLI (`npm install -g @google/generative-ai` or per the
   official docs)
2. Create the global config:
   ```bash
   mkdir -p ~/.gemini
   cp <repo>/templates/gemini/GEMINI.md ~/.gemini/GEMINI.md
   ```
3. Create a directory for Gemini chat archives in the vault:
   ```bash
   mkdir -p ~/Obsidian/SecondBrain/04\ Ressourcen/Gemini/
   ```

### What makes Gemini special

- **Long context windows** — suited for whole-vault analyses
- **Multimodal** — can work with images, audio, video
- **But: no skills/slash commands** — you drive workflows manually with Bash/Write

### What Gemini can't do

- Claude skill slash commands (`/projekt-init`, `/lumen-strategist`, ...)
- TodoWrite / AskUserQuestion (Claude-specific)
- The publish-script workflow

→ For skill-driven automation: Claude Code. Gemini is an **alternative
conversational interface** on top of the same vault.

### Chat archiving

To keep Gemini sessions discoverable in the vault, there is a convention:

- **Default location:** `04 Ressourcen/Gemini/`
- **Naming:** `YYYY-MM-DD-HHMM-short-topic.md`
- **Frontmatter:** `tags: [gemini-chat]`, `datum:`, `thema:`, `source: gemini`,
  `chat_url:`
- **Trigger:** offer proactively at session end

The pattern is documented in GEMINI.md itself — Gemini reads the file on start
and knows the rule.

## Codex CLI (OpenAI)

OpenAI Codex CLI has been OpenAI's official coding CLI since early 2026.

### Setup

1. Install Codex CLI:
   ```bash
   brew install codex
   # or
   npm install -g @openai/codex
   ```
2. Log in: `codex login` (creates `~/.codex/auth.json`)
3. Create the global config:
   ```bash
   mkdir -p ~/.codex
   cp <repo>/templates/codex/AGENTS.md ~/.codex/AGENTS.md
   ```
4. Optional: directory for Codex chat archives:
   ```bash
   mkdir -p "~/Obsidian/SecondBrain/04 Ressourcen/Codex - OpenAI/"
   ```
5. Optional: a vault-specific Codex config — copy `templates/vault/AGENTS.md`
   to `~/Obsidian/SecondBrain/AGENTS.md` so Codex has a dedicated "Codex lens"
   when it reads the vault rules.

### What makes Codex special

- **MCP server support** (see `~/.codex/config.toml`)
- **SQLite-based session history** — the internal history is opaque; the vault
  archive is the readable mirror
- **CI/CD pipeline mode** — Codex can run as a build step

### Verification

```bash
cd ~  # or any directory
codex
```

In the Codex chat: *"What's in my inbox?"* — Codex should read `01 Inbox/`.

## Claude Desktop

Claude Desktop is the GUI flavor of Claude (macOS, Windows). It accesses the
vault via an **MCP server**.

### Setup

1. Install Claude Desktop (from [claude.com/download](https://claude.com/download))
2. Configure a Filesystem MCP server for the vault — config path:
   - **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
   - **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`
3. Take the template from `templates/claude-desktop/claude_desktop_config.template.json`
   — the relevant block is:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "~/Obsidian/SecondBrain"
      ]
    }
  }
}
```

4. **Quit Claude Desktop completely and relaunch** (not just close the tab/chat
   — the config is only loaded on app start).
5. In a new chat: at the bottom right of the input field the MCP server icon
   should light up. If yes, Filesystem is active.

### Security warning: never put API keys in this file

If you add other MCP servers (Perplexity, Pencil, etc.), they often need API
keys. **Never write the key in plaintext into the config.** Better patterns:

- **macOS Keychain** + a shell wrapper script that reads the key at runtime
- **env-var file** with `chmod 600` and a shell wrapper
- **Externalize** into a separate file outside the config (e.g.
  `~/.secrets/perplexity.env`) and load it in the MCP server wrapper

The file `claude_desktop_config.json` is **readable by any process running as
your user** — no protection against malware, other apps, or accidental sharing.

### What makes Claude Desktop special

- **Persistent app** — runs in the background, can interrupt you while you work
- **Computer Use** (in some versions) — Claude controls your screen
- **Chrome extension pairing** (in some versions) — web research in the browser

But: **no direct access to Claude skills** like the CLI flavor. If you need
`/projekt-init`-style automation, Claude Code is the right choice.

## Perplexity — the special case

Perplexity has **no native vault binding**. You can't just drop a config file
like the other AIs. The workaround: **Obsidian Web Clipper as a browser
extension**.

### Setup: Obsidian Web Clipper

1. **Activate the plugin in Obsidian:** Settings → Community Plugins →
   "Obsidian Web Clipper"
2. **Install the browser extension:**
   - [Chrome / Edge / Brave (Chromium)](https://chromewebstore.google.com/detail/obsidian-web-clipper/cnjifjpddelmedmihgijeibhnjfabmlf)
   - [Firefox](https://addons.mozilla.org/firefox/addon/obsidian-web-clipper/)
   - [Safari](https://apps.apple.com/app/obsidian-web-clipper/id6720708363)
3. In the browser: open the extension → connect it to the Obsidian vault (shows
   a QR code or path picker).

### Template for Perplexity research

In the Web Clipper extension: create a new template with the following values.

**Template name:** `Perplexity Research`

**Trigger:** URL contains `perplexity.ai`

**Note name (filename template):**

```
{{date|date:"YYYY-MM-DD"}} {{"Was ist das konkrete Thema dieser Research? Antworte NUR mit 3-5 Stichworten, z.B. 'NIST CSF Tier 3 Analyse' oder 'KI Markt Europa Vergleich' oder 'Cybersecurity Framework ROI Studie'"}}
```

> The prompt above is left in German because that is the actual configured
> value in the reference setup. **If you work in English, replace the prompt
> accordingly**, e.g. *"What is the specific topic of this research? Reply only
> with 3-5 keywords, e.g. 'NIST CSF Tier 3 analysis' or 'AI market Europe
> comparison'."*

The part inside `{{"..."}}` is an **LLM interpreter call** — see the next
section.

**Save location:** `04 Ressourcen/Research/`

**Frontmatter:**

```yaml
---
tags: [perplexity, research]
datum: {{date|date:"YYYY-MM-DD"}}
source: perplexity
chat_url: {{url}}
---
```

**Note content template:**

```markdown
## Summary

{{content}}

## Sources

See Perplexity citations in the text.
```

### Interpreter: OpenRouter + Gemini 3.1 Flash Lite

The `{{"..."}}` block in the filename template is an **LLM call** that runs at
clip time. Web Clipper supports several providers — the recommendation is
**OpenRouter with Gemini 3.1 Flash Lite Preview** (cheap, fast, good for short
summaries).

**Setup:**

1. In the Web Clipper settings: enable the interpreter
2. Provider: **OpenRouter**
3. Model: `google/gemini-flash-1.5-8b` or a similar Flash Lite model
4. API key: your OpenRouter key
   - **Important:** the key is stored in the browser. Use a key that is
     **dedicated to Web Clipper** and has a strict budget limit
     ([openrouter.ai/credits](https://openrouter.ai/credits))
5. **Extended interpreter context** (inside the template):

```
Here is the content of a Perplexity Deep Research:

{{content|slice:0,2000}}

Extract the specific core topic. Reply ONLY with 3-5 concrete keywords in
English. No sentences, no generic terms.
Examples: 'NIST CSF Tier 3 analysis', 'React performance optimization',
'B2B SaaS pricing strategies'
```

### What you get

You click the Web Clipper button on a Perplexity result page. The extension:

1. Sends the first 2000 characters of the research content to OpenRouter
2. Gets 3-5 keywords back (e.g. "NIST CSF Tier 3 analysis")
3. Builds the file name: `2026-05-21 NIST CSF Tier 3 analysis.md`
4. Stores the file in `04 Ressourcen/Research/` with frontmatter and content

Result: Perplexity research lands in the vault automatically and consistently
named.

### For other tools without a vault binding

The same pattern works for:

- **ChatGPT sessions** (template: URL contains `chat.openai.com`)
- **Claude.ai web chats** (URL contains `claude.ai`)
- **Arbitrary articles** (no trigger, manual clip)

One Web Clipper template per source with adapted frontmatter values
(`source: chatgpt`, `source: claude`, etc.).

## Multiple AIs at the same time — who writes when?

If two AIs run simultaneously, write conflicts are theoretically possible. In
practice it is rarely a problem, because:

1. AIs mostly write **append-only** or create new files
2. If they do collide: Obsidian detects external file changes and reloads

**Safety valve:** for genuinely critical changes (e.g. editing `CLAUDE.md`
itself) — only let one AI work on it at a time.

## Next chapter

→ [05 — Workflows: daily notes, projects, deep research, ingest, lint](05-workflows.md)
