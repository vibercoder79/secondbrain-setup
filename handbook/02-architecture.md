# 02 — Architecture: hub-and-spoke and the three-layer model

> TL;DR: A **vault `CLAUDE.md`** is the single source of truth. All AI configs
> point to it via `@-import` or Filesystem MCP. AI-agnostic methodology lives in
> the vault; AI-specific specials live in the respective global configs.

## Hub-and-spoke

The picture is simple: a hub in the middle (the vault `CLAUDE.md`) with spokes
reaching out to the AIs.

```
                ~/.claude/CLAUDE.md          (Claude Code)
                       │
                       │ @-import
                       │
~/.gemini/GEMINI.md ───┤
        │              │
        │ @-import     ▼
        │      ┌──────────────────────────────────────┐
        │      │ ~/Obsidian/SecondBrain/CLAUDE.md     │
        │      │ Single source of truth (AI-agnostic) │
        │      └──────────────────────────────────────┘
        │              ▲
        │              │ @-import / Filesystem MCP
        │              │
~/.codex/AGENTS.md ────┤
                       │
                Claude Desktop (Filesystem MCP)
```

See diagram: [`diagramme/02-hub-and-spoke.png`](../diagramme/02-hub-and-spoke.png)

### Why this architecture?

**Change in exactly one place.** When you change the daily-note pattern,
introduce new frontmatter fields, or define a new folder area — you change
`~/Obsidian/SecondBrain/CLAUDE.md`. All AIs pull the change on the next session
start. You don't have to walk through three or four config files.

**AI-specific specials remain possible.** Some AIs support skills/slash commands
(Claude Code), others don't (Gemini CLI, Codex). Some have MCP servers (Claude
Code, Claude Desktop), others don't. These differences belong in the respective
global config:

- `~/.claude/CLAUDE.md` contains the skill-lifecycle workflow (Claude-Code-specific).
- `~/.gemini/GEMINI.md` contains the Gemini chat archiving rules (Gemini-specific).
- `~/.codex/AGENTS.md` contains the Codex chat archiving rules (Codex-specific).

But: **no AI-agnostic knowledge** is duplicated in the global configs. If
"write a daily note" is a rule, it belongs in the vault `CLAUDE.md`, not in
three configs.

### The `@-import` syntax

Claude Code and Gemini CLI support `@-import`: inside a Markdown file,
`@/path/to/file.md` is interpreted as an inline embed and the contents of the
target file are loaded along with the parent. Example from `~/.gemini/GEMINI.md`:

```markdown
## Second Brain

The authoritative rules live in the vault's own rule file:

@~/Obsidian/SecondBrain/CLAUDE.md
```

Codex CLI also supports `@-import` (version-dependent). If an AI does not
support it, the fallback is to write an explicit **read instruction**: "On
session start, read the file `~/Obsidian/SecondBrain/CLAUDE.md`."

### Why is the file called `CLAUDE.md`?

Historical reasons — it grew out of the Claude Code setup. The **content** is
AI-agnostic. You could rename the file to `VAULT.md` or `RULES.md` and it would
work as long as you update the path in every global config. We keep the name
because it has settled as convention and Claude Code looks for it by default.

## The three-layer model

If you use the setup seriously with skills, you have three persistence layers
for your knowledge — and each has a clear purpose:

| Layer                 | Purpose                                       | Location                              |
| --------------------- | --------------------------------------------- | ------------------------------------- |
| Implementation        | SKILL.md, scripts, templates                  | `~/.claude/skills/<skill-name>/`      |
| Code & versioning     | README.md, changelog, version tags            | GitHub repo (e.g. `vibercoder79/claudecodeskills`) |
| Knowledge & context   | Qualitative docs, connections, insights       | SecondBrain: `03 Bereiche/Skills/`    |

The important rule: **the SecondBrain is the knowledge SSoT, not the skill
folder.** If a skill needs to access a color palette, it reads it from
`~/Obsidian/SecondBrain/00 Kontext/Branding.md` — not from a copy inside its own
`references/`. If the palette changes, it changes everywhere at once.

See diagram: [`diagramme/03-drei-ebenen-modell.png`](../diagramme/03-drei-ebenen-modell.png)

## What belongs in the vault, what doesn't

A recurring question: does information **A** live in the vault or somewhere
else?

Rule of thumb:

| Question | Vault | Elsewhere |
| -------- | ----- | --------- |
| Will I still need it in 6 months? | Yes → vault | No → temporary (chat) |
| Should multiple AIs read it? | Yes → vault | No → AI-specific memory |
| Is it code (executable)? | No | Yes → Git repo |
| Is it a decision with a rationale? | Yes → `Decisions/` | — |
| Is it a code snippet without a repo? | Yes → `04 Ressourcen/` | — |
| Is it personal identity (a password)? | No, never | Keychain / password manager |

Vault is Markdown knowledge. Code lives in Git repos. Secrets live nowhere
visible.

## AI-agnostic methodology

Inside the vault there is a special place: `00 Kontext/Workflows/`. That is
where **methodological guides** live which multiple AIs should execute — for
example `Projekt-Anlegen.md` (a 9-question onboarding for new projects). This
file is the single source of truth for the workflow.

- Claude Code has a `/projekt-init` skill that runs the methodology
  **automatically** (with MCP discovery for backlog tools, etc.)
- Gemini CLI reads the same file and walks through the workflow **manually**
  (asks the same questions, creates the same folders, uses the same templates).
- Codex CLI does it the same way, manually.

The methodology exists exactly once. The execution depends on the AI's
capabilities. Change a question in the onboarding and the behavior changes
across all AIs.

## Where does what live?

A quick overview:

```
~/                                       (home)
├── .claude/
│   ├── CLAUDE.md                       (global Claude config — points to the vault)
│   └── skills/                          (Claude-specific skills)
├── .gemini/
│   └── GEMINI.md                       (global Gemini config — @-imports the vault)
├── .codex/
│   └── AGENTS.md                       (global Codex config — points to the vault)
└── Obsidian/
    └── SecondBrain/
        ├── CLAUDE.md                   (★ single source of truth)
        ├── AGENTS.md                   (Codex mirror with "Codex" language)
        ├── Index.md                    (★ vault cover, generated by /lint)
        ├── log.md                      (★ processing chronology)
        ├── 00 Kontext/                 (profiles, templates, workflows)
        │   ├── Projekt-Struktur.md
        │   ├── User-Story-Template.md
        │   └── Workflows/
        │       └── Projekt-Anlegen.md
        ├── 01 Inbox/                   (brain dumps)
        ├── 02 Projekte/                (active projects with end date)
        ├── 03 Bereiche/                (ongoing responsibilities)
        ├── 04 Ressourcen/              (reference material, research, AI archives)
        ├── 05 Daily Notes/             (one per day)
        ├── 06 Archiv/                  (completed)
        └── 07 Anhaenge/                (images, PDFs)
```

The star ★ marks the files that hold the whole system together. The folder
names stay in German because they are part of the convention — wikilinks rely
on them being identical across languages.

## Next chapter

→ [03 — Vault structure: PARA in practice](03-vault-structure.md)
