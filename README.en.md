# SecondBrain Setup

> A shared Markdown vault as a knowledge hub for all your AIs. PARA gives the
> order, Karpathy's LLM-Wiki pattern brings it to life, three small skills
> automate it. Claude Code, Claude Desktop, Gemini CLI, Codex CLI and
> Perplexity all write into the same vault without stepping on each other.

🇬🇧 English · [🇩🇪 Deutsch](README.md)

---

## Why this repo

When you seriously use two or more AIs day to day — Claude for code, Gemini
for text, Perplexity for research — you eventually notice: your knowledge is
scattered. Every AI is an island. Insights from one chat are unknown in the
next. No compound effect.

This setup solves that with **a single central Markdown vault** as the single
source of truth. All AIs read and write there. You stay owner of your
knowledge — no vendor database, no proprietary formats.

Inspired by:

- **Tiago Forte — Building a Second Brain (PARA)** — provides the skeleton:
  four folder types sorted by actionability
- **Andrej Karpathy — [LLM-as-a-Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)** —
  provides the liveliness: ingest/query/lint pattern for connected knowledge

## What you get

- **Three Claude Code skills:** `/projekt-init` (create a project), `/lint`
  (vault health), `/ingest` (connect notes)
- **Templates:** global configs for Claude Code, Gemini CLI, Codex CLI, Claude
  Desktop. Plus vault templates for projects, ADRs, meetings, user stories.
- **Handbook:** seven chapters on philosophy, architecture, multi-AI binding
  and customizing. Fully documented.
- **Diagrams:** hub-and-spoke, three-layer model, Karpathy data flow as
  Excalidraw + PNG.

## Quickstart (15 minutes)

```bash
# 1. clone the repo
git clone https://github.com/vibercoder79/secondbrain-setup ~/Documents/GitHub/secondbrain-setup
cd ~/Documents/GitHub/secondbrain-setup
```

### Step 1: create the Obsidian vault

If you don't have one yet:

1. Install [Obsidian](https://obsidian.md)
2. Create a new vault at `~/Obsidian/SecondBrain/` (or your own path — then
   adjust it everywhere in the templates)
3. Activate plugins: **Dataview** (required), Templater + Excalidraw (optional)

### Step 2: initialize the vault structure

```bash
VAULT=~/Obsidian/SecondBrain  # or your path
cd "$VAULT"

# create PARA folders
mkdir -p "00 Kontext/Workflows" "01 Inbox" "02 Projekte" "03 Bereiche" \
         "04 Ressourcen/Research" "05 Daily Notes" "06 Archiv" "07 Anhaenge"

# copy templates
cp ~/Documents/GitHub/secondbrain-setup/templates/vault/CLAUDE.md "$VAULT/CLAUDE.md"
cp ~/Documents/GitHub/secondbrain-setup/templates/vault/AGENTS.md "$VAULT/AGENTS.md"  # only if you use Codex
cp -r ~/Documents/GitHub/secondbrain-setup/templates/vault/"00 Kontext"/* "$VAULT/00 Kontext/"
```

> **Note:** the folder names (`00 Kontext`, `01 Inbox`, ...) stay in German —
> they are part of the convention and identical across languages so that
> wikilinks keep working.

### Step 3: connect at least one AI

**Claude Code (recommended):**

```bash
mkdir -p ~/.claude
cp ~/Documents/GitHub/secondbrain-setup/templates/claude/CLAUDE.md ~/.claude/CLAUDE.md
```

**Install the skills** (three slash commands):

```bash
cp -r ~/Documents/GitHub/secondbrain-setup/skills/projekt-init ~/.claude/skills/
cp -r ~/Documents/GitHub/secondbrain-setup/skills/lint ~/.claude/skills/
cp -r ~/Documents/GitHub/secondbrain-setup/skills/ingest ~/.claude/skills/
```

**More AIs?** See [handbook chapter 04 — Multi-AI setup](handbook/04-multi-ai-setup.md).

### Step 4: verification

Start Claude Code in any directory:

```
"What's in my inbox?"
```

If Claude lists the inbox notes from `01 Inbox/`, the binding works.

Create a test project:

```
"create a project for Test123"
```

Claude runs the 10-question onboarding. After your answers the project folder
exists with hub + governance + subfolders.

### Step 5: add your own context

Fill `00 Kontext/` with your profile (see [handbook chapter 03](handbook/03-vault-structure.md)):

- `Über mich.md`
- `ICP.md` (if you have customers)
- `Schreibstil.md` (tone)
- `Branding.md` (if relevant)

These files are not in the repo — they are your content.

## The whole thing at a glance

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

Detail diagrams in [`diagramme/`](diagramme/).

## Handbook

Seven chapters, 5-15 minutes each:

1. [Philosophy — why this setup exists](handbook/01-philosophy.md)
2. [Architecture — hub-and-spoke and the three-layer model](handbook/02-architecture.md)
3. [Vault structure — PARA in practice](handbook/03-vault-structure.md)
4. [Multi-AI setup — Claude, Gemini, Codex, Claude Desktop, Perplexity](handbook/04-multi-ai-setup.md)
5. [Workflows — daily notes, projects, deep research, ingest, lint](handbook/05-workflows.md)
6. [Skills — projekt-init, lint, ingest in detail](handbook/06-skills.md)
7. [Customizing — your own paths, your own tools, migration](handbook/07-customizing.md)

## Repo structure

```
secondbrain-setup/
├── README.md, README.en.md        Quickstart in DE + EN
├── handbuch/                       Deep dive (DE)
├── handbook/                       Deep dive (EN)
├── templates/
│   ├── claude/CLAUDE.md            global Claude Code config
│   ├── codex/AGENTS.md             global Codex CLI config
│   ├── gemini/GEMINI.md            global Gemini CLI config
│   ├── claude-desktop/             Claude Desktop config + README
│   ├── vault/                      vault contents (CLAUDE.md, AGENTS.md, 00 Kontext)
│   └── projekt/                    project templates (PMO HUB, Governance, ADR, Meeting)
├── skills/                         three skills: projekt-init, lint, ingest
├── diagramme/                      Excalidraw + PNG (DE + EN)
└── setup.sh                        optional setup helper
```

## Security notes

- **No API keys in the repo.** All templates use placeholders
  (`YOUR_API_KEY_HERE`). Use Keychain/env vars for real secrets.
- **Paths are sanitized** to `~/...` — no absolute userland paths.
- **Vault contents are generic** — no personal data, no example projects with
  customer names.

Before any push of your own: read `git diff --staged` and check for your own
secrets.

## License

MIT — see [LICENSE](LICENSE).

## Contributing

Issues and pull requests welcome. For bigger changes open an issue first so we
can align on direction.

## Inspiration & sources

- [Andrej Karpathy — LLM-as-a-Wiki Gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- Tiago Forte — Building a Second Brain (book, 2022)
- Michael Nygard — [Documenting Architecture Decisions (ADR)](https://www.cognitect.com/blog/2011/11/15/documenting-architecture-decisions) (2011)
- Vault-centric skills inspired by the [OpenCLAW Bootstrap pattern](https://github.com/vibercoder79/KI-Masterclass-Koerting-/tree/main/bootstrap)
