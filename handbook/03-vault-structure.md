# 03 — Vault structure: PARA in practice

> TL;DR: Eight numbered folders (00-07), three required files at the root,
> mandatory frontmatter on every note. Stick to the conventions and you never
> have to think about where something belongs.

## The eight folders

```
~/Obsidian/SecondBrain/
├── 00 Kontext/         personal profile + AI-agnostic methodology
├── 01 Inbox/           brain dumps and unprocessed notes
├── 02 Projekte/        active projects with a goal and an end date
├── 03 Bereiche/        ongoing areas of responsibility (no end date)
├── 04 Ressourcen/      reference material, research, AI chat archives
├── 05 Daily Notes/     one file per day
├── 06 Archiv/          completed projects and inactive areas
└── 07 Anhaenge/        images, PDFs, media (Obsidian default)
```

> **Note on folder names:** the folders keep their German names (`00 Kontext`,
> `01 Inbox`, `02 Projekte`, ...). These names are part of the convention and
> stay identical across languages so that wikilinks keep working. Don't translate
> them.

The numeric prefixes are not random — they sort in Obsidian's file explorer by
actionability, not alphabetically. `00` is the foundation, `01` is the inbox,
then things flow down to `07` attachments.

### 00 Kontext — the foundation

This is where your **profile** and your **methodological library** live:

```
00 Kontext/
├── Über mich.md              (who you are, background)
├── ICP.md                    (if you have customers: ideal target group)
├── Angebot.md                (if relevant: what you offer)
├── Schreibstil.md            (tone, writing rules)
├── Branding.md               (if you have a brand)
├── Projekt-Struktur.md       (★ templates for project creation)
├── User-Story-Template.md
└── Workflows/
    └── Projekt-Anlegen.md    (★ AI-agnostic methodology)
```

AIs read these files when they create content, write emails, or set up a new
project. When you change — writing style, target group, branding — you change
one file and every AI picks up the new version.

**For your own setup:** the templates `Projekt-Struktur.md` and
`Workflows/Projekt-Anlegen.md` shipped with this repo (`templates/vault/00 Kontext/`)
are generic. The profile files (`Über mich.md`, `ICP.md`, etc.) you write
yourself — that's your content, not the setup. The file names stay in German
to keep wikilinks portable; the file contents can be in any language you choose.

### 01 Inbox — the entrance

Everything that doesn't yet have a fixed place: a quick note from a phone call,
an idea from the shower, an unread article link, an AI output you haven't
sorted yet.

**Rule:** the inbox should be **empty**. More than 5 items is a warning sign.
The `/lint` skill warns you automatically when the inbox overflows.

### 02 Projekte — the operational layer

Projects have a **goal** and an **end date**. "Rebuild the website", "Write
Q3 newsletter", "Implement trading algorithm". If neither applies, it's not a
project — it's an area (`03`).

Every project is a **folder**, never a single file. The folder structure is
enforced (see chapter 06 — Skills, `/projekt-init`):

```
02 Projekte/<project-name>/
├── <project-name> - PMO HUB.md   (★ landing page)
├── Projekt-Governance.md          (★ tool stack, backlog binding)
├── Meetings/                      (one file per meeting)
├── Decisions/                     (ADRs — Architecture Decision Records)
├── Research/                      (project-related research)
└── assets/                        (diagrams, attachments)
```

**Container prefix `_`:** if you have multiple related projects (e.g. all
customer projects of one company), you can group them in a container folder
with an underscore prefix: `02 Projekte/_KUNDEN/`. Containers themselves have
no hub — they are just collectors.

### 03 Bereiche — the responsibilities

Ongoing responsibilities without an end date: "Finances", "Health", "Team",
"Lifelong Learning". Each area is a folder (because areas grow over time and
collect multiple files).

This is also where `03 Bereiche/Skills/` lives — the qualitative documentation
of every skill you use. The technical implementation of the skills lives in
`~/.claude/skills/`, the code in GitHub. The knowledge layer lives here.

### 04 Ressourcen — the reference material

Everything you use for reference: research results, article summaries, AI chat
archives, technical documentation. Each topic is a folder.

**Special sub-structures:**

- `04 Ressourcen/Research/YYYY-MM-DD Topic/` — deep researches (see chapter 05)
- `04 Ressourcen/Gemini/` — archived Gemini chat histories
- `04 Ressourcen/Codex - OpenAI/` — archived Codex chat histories
- `04 Ressourcen/Claude Desktop/` (optional) — if you use Claude Desktop

Every topic folder has a **synthesis page** with the same name as the folder
(e.g. `04 Ressourcen/Claude Code/Claude Code.md`). That page is the entry
point into the topic and the `/ingest` skill makes it richer with every new
note. This is Karpathy's living wiki.

### 05 Daily Notes — the logbook

One file per day, named `YYYY-MM-DD.md`. Format:

```markdown
---
tags:
  - daily
  - project-tag-1
  - project-tag-2
date: 2026-05-21
source: claude
chat_url: https://claude.ai/chat/...
---

# 2026-05-21

## My-Project #my-project-tag

> [!info] Via Claude — [[My-Project - PMO HUB]]

### What was done
- ...

### Decisions
- [[Decisions/ADR-03 Database choice]]

### Open
- [ ] Write setup script
```

Daily notes are the **single source of truth for daily activity**. Project hubs
pull from the daily notes automatically via Dataview queries using the matching
tag. That means: you write once into the daily note, and the hub updates by
itself.

### 06 Archiv — the completed

When a project is done or an area is no longer active: move it to
`06 Archiv/`. Don't delete it — valuable context for later. Only on instruction,
never automatically.

### 07 Anhaenge — the Obsidian default

Obsidian stores pasted images and PDFs here. Don't touch anything manually,
just let Obsidian do its job.

## Three mandatory files at the vault root

```
~/Obsidian/SecondBrain/
├── CLAUDE.md       ★ single source of truth for all AIs
├── AGENTS.md       Codex mirror with "Codex" language (optional, if Codex is used)
├── Index.md        ★ vault cover (generated by /lint)
└── log.md          ★ append-only chronology of /ingest and /lint
```

These files are the backbone:

- **CLAUDE.md** is the central rule file (chapter 02).
- **Index.md** is the vault cover. On session start the AI reads this single
  file and instantly has the overview: active projects, areas, synthesis pages,
  recent daily notes, statistics. It saves tokens compared to a full-text scan
  ([Karpathy LLM-Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)).
- **log.md** is the chronology. Every `/ingest` and `/lint` run writes an entry.

## Mandatory frontmatter

Every note (exception: `Index.md` is auto-generated, `log.md` is a special
case) starts with YAML frontmatter:

```yaml
---
tags: [topic-1, topic-2]
status: aktiv          # for projects: aktiv | abgeschlossen | pausiert
date: 2026-05-21       # for daily notes and dated notes
source: claude         # IMPORTANT for multi-AI tracking
chat_url: https://claude.ai/chat/...   # original chat, "unbekannt" if unclear
---
```

> **Note on values:** the example above uses German status values
> (`aktiv` = active, `abgeschlossen` = completed, `pausiert` = paused) because
> that is the convention shipped with the templates. In an English-only project
> you can use `active | completed | paused` — just be consistent across your
> vault, because Dataview queries match on these strings.

### Multi-AI tracking via `source` and `chat_url`

When multiple AIs write into the same vault, `source:` is indispensable. Days
later you need to be able to trace which AI wrote a given note — for trust,
for comparison, for debugging.

**Values:**

- `source: claude` — Claude (App, Code, Desktop)
- `source: gemini` — Gemini CLI or Gemini app
- `source: codex` or `source: codex-cli` — OpenAI Codex
- `source: perplexity` — Perplexity (via Web Clipper, see chapter 04)
- `source: chatgpt` — ChatGPT (manual)

`chat_url` is the URL of the original chat so you can always jump back. If the
URL is unknown: `chat_url: unbekannt` (German for "unknown") — **never omit it**.

## Wikilink conventions

Instead of classic Markdown links `[Text](path)` the vault uses Obsidian's
`[[wikilink]]` syntax:

```markdown
See [[My-Project - PMO HUB]] for details.
Related: [[2026-05-21 AI market research]]
```

Wikilinks have three advantages:

1. **Bidirectional** — Obsidian shows in the target note who links to it.
2. **Folder-agnostic** — the wikilink `[[My-Project - PMO HUB]]` finds the file
   regardless of which subfolder it lives in.
3. **Graph-capable** — Obsidian's graph view shows the vault as connected
   knowledge.

**Aliasing** with a pipe: `[[My-Project - PMO HUB|the project hub]]` renders as
"the project hub" and still links to the target file.

## Naming conventions

- **Daily notes:** `YYYY-MM-DD.md` (e.g. `2026-05-21.md`)
- **Project hubs:** `<project-name> - PMO HUB.md` (with the hyphenated suffix)
- **ADR decisions:** `ADR-XX <short title>.md` (e.g. `ADR-03 Database choice.md`)
- **Research folders:** `YYYY-MM-DD Topic/` (e.g. `2026-04-15 Karpathy LLM Wiki concept/`)
- **Other notes:** descriptive name in normal sentence case with spaces and
  capitals (e.g. `Cybersecurity framework ROI study.md`)

Consistent naming matters because wikilinks depend on it. If you write
`[[Project X]]` today and `[[project-x]]` tomorrow, you have two different
targets.

## Next chapter

→ [04 — Multi-AI setup: Claude, Gemini, Codex, Claude Desktop, Perplexity](04-multi-ai-setup.md)
