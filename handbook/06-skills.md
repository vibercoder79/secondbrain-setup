# 06 — Skills: projekt-init, lint, ingest in detail

> TL;DR: Three vault-centric Claude Code skills. `projekt-init` sets up new
> projects cleanly. `lint` keeps the vault healthy. `ingest` weaves new notes
> into the existing material. Together they implement Karpathy's LLM-Wiki
> pattern.

## What are skills?

Skills are Claude Code extensions — slash commands with their own workflow and
tool set. They live in `~/.claude/skills/<name>/` and consist at minimum of a
`SKILL.md` with frontmatter:

```yaml
---
name: projekt-init
description: ...
version: 1.2.0
user-invocable: true
allowed-tools: [Read, Edit, Write, Bash, Glob, Grep, AskUserQuestion]
---
```

When you invoke a skill (`/projekt-init` or via a trigger phrase like "set up a
project"), Claude reads the `SKILL.md` as a workflow guide and executes it.

In this repo: `skills/projekt-init/`, `skills/lint/`, `skills/ingest/`.

## Skill 1: `/projekt-init` — create a project

**Trigger:** "set up a project", "new project", "create a project", "create a
project for ...", or `/projekt-init` explicitly.

### What it does

Orchestrates the clean creation of a new project in the vault:

1. **Phase 0 — Onboarding** (10 questions in one block, see chapter 05)
2. **Phase 1 — Validation** (folder conflict? derive tags?)
3. **Phase 2 — Backlog discovery** (Linear via MCP, Teams via M365 MCP, GitHub via gh CLI, or none)
4. **Phase 3 — Create folder structure** (per whitelist: Meetings/, Decisions/, Research/, assets/)
5. **Phase 4 — Populate templates** (PMO HUB + Projekt-Governance with real values)
6. **Phase 5 — Apply opt-ins** (risk tracking? financials?)
7. **Phase 6 — Verification** (whitelist check, wikilinks valid, Dataview syntax)

### Methodology separation

The **methodology** (the 10 questions, defaults, language logic) lives
AI-agnostic in the vault: `00 Kontext/Workflows/Projekt-Anlegen.md`. Other AIs
(Gemini, Codex) read the same file and walk through the workflow manually.

The **automation** (MCP discovery, auto-create) lives in the skill — it's
Claude-Code-specific (because only Claude Code has MCP servers for Linear/M365).

### Backlog tool discovery

Depending on the answer to question 6:

| Tool | Workflow |
| ---- | -------- |
| `linear` | Linear MCP: `list_projects`, auto-create with confirmation, set up labels |
| `teams-kanban` (M365) | M365 MCP, analogous. Tool names determined at runtime |
| `github-issues` | `gh` CLI, repo validation, label setup |
| `notion` | user input (no MCP configured in the default setup) |
| `none` | the hub gets a "Pre-Backlog Action Items" section |

**Graceful degradation:** if an MCP tool does not respond (auth error etc.) →
fallback to user input with a link, no hard failure.

### How the skill prevents what can go wrong

Lessons learned from Tobias' vault that fed into the skill:

- **No `README.md` in the project root** (whitelist violation) — the hub is the landing page
- **No single-file projects** — always a folder with a hub + subfolders
- **`Projekt-Governance.md` is mandatory** — tool stack and backlog binding per project
- **The hub file MUST end with `- PMO HUB.md`** — naming convention for wikilinks
- **Default `backlog_tool: none`** if not explicitly chosen

### Version history

| Version | Changes |
| ------- | ------- |
| 1.2.0 | References reworked to stubs, vault methodology becomes the source of truth |
| 1.1.x | Multi-language (DE/EN), language choice as question 0 |
| 1.0.0 | Initial: 7-phase workflow, backlog hybrid strategy |

### Details

→ [`skills/projekt-init/SKILL.md`](../skills/projekt-init/SKILL.md)
→ [`skills/projekt-init/README.md`](../skills/projekt-init/README.md)

## Skill 2: `/lint` — vault health check

**Trigger:** "lint", "vault check", "check the vault", "health check", "orphan
notes", "orphans", "project compliance", or `/lint` explicitly.

### What it does

Checks the entire vault for hygiene, drift, and convention violations:

1. **Find orphan notes** — glob all `*.md`, for each check if at least one
   `[[wikilink]]` points to it. Exceptions: daily notes, `00 Kontext/`,
   `CLAUDE.md`, landing files.
2. **Suggest missing links** — topic matching between notes, each suggestion
   confirmed individually.
3. **Vault hygiene** — inbox count, completed-project candidates, frontmatter
   check, required synthesis pages.
4. **Project compliance** — against the governance in
   `00 Kontext/Projekt-Struktur.md`:
   - whitelist project root (only PMO HUB, Governance, Financials allowed)
   - `README.md` in the root is forbidden
   - required files exist
   - naming convention `* - PMO HUB.md`
   - broken wikilinks in the PMO HUB
   - decisions frontmatter consistency (`status` ↔ `entschieden_am`)
   - pre-backlog items older than 30 days
5. **Create report** — `01 Inbox/YYYY-MM-DD Vault Lint Report.md`, log entry in
   `log.md`.
6. **Regenerate the vault index** — `Index.md` as the wiki cover (see chapter 05).

### Container folder logic

If a project folder begins with an underscore (e.g. `_KUNDEN/`), it is treated
as a **container** — a collection folder for sub-projects. The container
itself has no PMO HUB; instead each direct subfolder is checked as a project of
its own.

### Important rules

- **ALWAYS ask** before modifying notes
- **NEVER delete** — existing content is only extended
- **`07 Anhaenge/` is fully ignored** — no images/PDFs scanned
- **Daily notes are not orphans** — they stand on their own
- **The log is append-only** — never edit existing entries
- **`Index.md` is atomic** — overwrite completely, no incremental edits

### Partial modes

| Invocation | Behavior |
| ---------- | -------- |
| `/lint` | Full check (all 6 steps) |
| `/lint orphans` | Only step 1 |
| `/lint inbox` | Only the inbox check from step 3 |
| `/lint projekte` | Only step 4 |
| `/lint index` | Only step 6 (regenerate the index) |

### Version history

| Version | Changes |
| ------- | ------- |
| 1.3.x | Index regeneration (Karpathy LLM-Wiki cover) |
| 1.2.x | Project compliance section |
| 1.1.x | Frontmatter description extended |
| 1.0.0 | Initial: 4-phase workflow |

### Details

→ [`skills/lint/SKILL.md`](../skills/lint/SKILL.md)
→ [`skills/lint/README.md`](../skills/lint/README.md)

## Skill 3: `/ingest` — connect notes

**Trigger:** `/ingest "<note title>"` or "wire up this note", "ingest that",
"link this in the vault".

### What it does

Processes a single new note and integrates it into the existing material:

1. **Scan the vault** — extract topics from the new note, search existing
   notes for topical overlap.
2. **Set wikilinks** — **bidirectional**:
   - In the new note: wikilinks to thematically related notes
   - In the related notes: a wikilink back to the new note
3. **Update the synthesis page** — the landing file of the topic folder
   (e.g. `04 Ressourcen/Cybersecurity/Cybersecurity.md`) gets a new paragraph
   or section with the insight from the new note.
4. **Append to log.md** — chronology entry.

### Why no hook?

A hook on every file edit would be:

- **Too expensive** — at 1247 notes every edit would trigger an LLM analysis
- **Too noisy** — synthesis pages would update on every trivial edit
- **Too autonomous** — you lose control of when what is processed

Instead: **manual invocation**. You decide which note is valuable enough to be
wired up.

### Variant B — existing landing files as synthesis pages

Instead of creating a new `wiki/` folder, ingest uses the existing **landing
files** in `04 Ressourcen/` as synthesis pages. Every topic folder has a
landing file of the same name (`04 Ressourcen/Gemini/Gemini.md`,
`04 Ressourcen/Claude Code/Claude Code.md`). These files are the living wiki
nodes.

Advantages:

- No new system parallel to the existing structure
- Landing files are already convention (see chapter 03)
- `/lint` checks that every topic folder has a landing file

### Details

→ [`skills/ingest/SKILL.md`](../skills/ingest/SKILL.md)
→ [`skills/ingest/README.md`](../skills/ingest/README.md)

## Putting it together: Karpathy in practice

The three skills implement Karpathy's [LLM-Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f):

| Karpathy operation | This setup |
| ------------------ | ---------- |
| **Ingest** — process a new source | `/ingest <note>` |
| **Query** — search the wiki, synthesize answers | wikilinks across notes + synthesis pages enable token-efficient queries |
| **Lint** — health checks | `/lint` (weekly or on demand) |

Plus the project-creation pattern:

| Pattern | This setup |
| ------- | ---------- |
| Structured, schema-compliant creation | `/projekt-init` with onboarding + verification |

## Installing the skills

Prerequisite: Claude Code installed.

```bash
# from this repo
cp -r ~/Documents/GitHub/secondbrain-setup/skills/projekt-init ~/.claude/skills/
cp -r ~/Documents/GitHub/secondbrain-setup/skills/lint ~/.claude/skills/
cp -r ~/Documents/GitHub/secondbrain-setup/skills/ingest ~/.claude/skills/
```

Verification:

```bash
ls ~/.claude/skills/
# projekt-init  lint  ingest
```

In Claude Code: `/projekt-init` — if the trigger is recognized, everything is
installed.

## Building your own skills

If you want to build your own skills (same lifecycle: develop locally → publish
to GitHub → document in the SecondBrain), see the `skill-creator` skill from
Tobias' main repo `vibercoder79/claudecodeskills`. The conventions, the publish
script and the skill lifecycle workflow are documented there.

## Next chapter

→ [07 — Customizing: your own paths, your own tools, migration](07-customizing.md)
