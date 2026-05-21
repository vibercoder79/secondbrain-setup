# projekt-init

> Orchestrates the creation of a new project in the SecondBrain Obsidian Vault — with
> onboarding dialog (incl. language choice), automatic folder structure, and intelligent
> backlog tool integration (Linear, M365 Teams Kanban, GitHub Issues).

German version: [README.md](README.md)

## What the skill solves

Setting up a new project in the SecondBrain previously required many manual steps: folder
structure, hub file, governance file, templates, backlog tool integration. Each setup
risked forgetting something or violating the file whitelist.

`projekt-init` automates this completely:
- Onboarding dialog (10 questions including language choice DE/EN) collects context
- Folder structure created per whitelist
- Templates from `Projekt-Struktur.md` (or `.en.md` for EN projects) filled with real values
- Backlog tool intelligently linked (MCP discovery, auto-create with confirmation, user input as fallback)
- Verification checks compliance before summary

## Installation

The skill is at `~/.claude/skills/projekt-init/` and is automatically loaded by Claude Code.

```bash
cp -r ~/Documents/GitHub/secondbrain-setup/skills/projekt-init ~/.claude/skills/projekt-init
```

## Usage

### Trigger phrases

- "create a project"
- "new project"
- "set up a project"
- "create a project for..."
- `/projekt-init` (explicit slash command)

### Quick mode (skip onboarding)

Add "Standard" or "no questions" to the trigger:

```
/projekt-init Standard
new project no questions
```

→ Claude uses defaults from `references/defaults-pro-typ.md`. Language = German.
Only project name needs to be asked.

## Modes and features

### Phase 0: Onboarding Dialog

10 questions, all in one block:
0. Project language? (German / English)
1. Project name?
2. One-sentence description?
3. Concrete goal?
4. Project type? (Software / Consulting / Marketing / Personal / Other)
5. Stakeholder / Client?
6. Backlog tool? (Linear / Teams-Kanban / GitHub / none)
7. GitHub repo URL? (optional)
8. Activate risk tracking? (default: no)
9. Activate financials tracking? (default: no)

### Phase 2: Backlog tool integration (Hybrid strategy)

Per chosen tool:

- **Linear:** Discovery via Linear MCP, auto-create with confirmation
- **M365 / Teams-Kanban:** Discovery via M365 MCP, analogous pattern
- **GitHub Issues:** Via `gh` CLI, repo validation, label setup
- **none:** Hub gets "Pre-Backlog Action Items" section

**Graceful degradation:** MCP not available → user input with link.

### Phases 3-6: Create and fill

- Folder structure per whitelist
- PMO HUB with live dataview views
- `Projekt-Governance.md` with tool stack
- Opt-in: `Risks/` and Top-Risks block
- Opt-in: `Financials.md`

### Phase 7: Verification

- Whitelist check
- Required files exist
- Wikilinks valid
- Dataview blocks correct
- Frontmatter complete

## Background

Inspired by the OpenCLAW Bootstrap pattern (https://github.com/vibercoder79/KI-Masterclass-Koerting-/tree/main/bootstrap),
which established the same principle for software development projects: structured phases,
onboarding-first, templates instead of placeholders, machine-enforced compliance.

`projekt-init` adapts the principle for the SecondBrain Vault context.

## Sources

- **OpenCLAW Bootstrap:** https://github.com/vibercoder79/KI-Masterclass-Koerting-/tree/main/bootstrap
- **PARA Method:** Tiago Forte, Building a Second Brain
- **ADR Pattern:** Michael Nygard, "Documenting Architecture Decisions" (2011)
- **PMI / PRINCE2 Risk Register:** Standard PMO risk format
- **Dann Berg Meeting Template:** Inspiration for meeting structure

## Prerequisites

- Obsidian SecondBrain Vault at `~/Obsidian/SecondBrain/`
- `Projekt-Struktur.md` + `.en.md` as single source of truth for templates
- `User-Story-Template.md` + `.en.md` as task standard
- Optional: Linear MCP for discovery
- Optional: M365 MCP for Teams-Kanban
- Optional: `gh` CLI for GitHub Issues

## File structure

```
projekt-init/
├── SKILL.md                              <-- Main logic DE
├── SKILL.en.md                           <-- Main logic EN
├── README.md                             <-- README DE
├── README.en.md                          <-- this file (EN)
├── projekt-init-overview.excalidraw      <-- Big picture DE
├── projekt-init-overview.png
└── references/                           <-- Detail references (DE, language-neutral logic)
    ├── onboarding-fragen.md
    ├── defaults-pro-typ.md
    ├── backlog-discovery-linear.md
    ├── backlog-discovery-m365.md
    └── verifikation-checks.md
```

## Connection to other skills

- **`lint`** finds compliance drift in already-created projects
- **`meeting-process`** distributes decisions/risks/tasks from meetings
- **`ingest`** is the counterpart for individual notes
- **`obsidian-markdown`** is used for markdown generation
