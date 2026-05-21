# 08 — Project management: hub, governance, Dataview aggregation

> TL;DR: Every project is a folder with a fixed structure. A PMO HUB file is
> the landing page and shows live views via Dataview queries. A governance
> file defines the tool stack. The methodology lives AI-agnostically in
> `00 Kontext/Workflows/Projekt-Anlegen.md` — all AIs use it, and the
> `/projekt-init` skill automates it for Claude Code.

## Principle: Obsidian = knowledge, backlog tool = work

A hard separation keeps the system healthy:

- **Obsidian** holds **knowledge**: meetings, decisions (ADRs), research,
  daily activities, qualitative documentation, stakeholder context.
- **Backlog tool** (Linear, Teams Kanban, GitHub Issues, Asana, ClickUp, ...)
  holds **work**: tasks, user stories, sprints, bugs, tickets with IDs and
  status values.

Running tasks in Obsidian is tempting (everything in one place), but:

- You lose the Kanban/sprint views of the backlog tool
- You duplicate effort if the backlog tool is already in place
- Other teammates without Obsidian access don't see the tasks

So the rule is: **tasks go into the backlog tool. Obsidian points to the
fact that they exist — and whoever cares clicks through.**

Exception: if the project is completely solo and no backlog tool is needed,
the hub has a "Pre-Backlog Action Items" section with checkboxes directly in
Markdown. As soon as the project wants to grow: enable a backlog tool.

## A project is always a folder

No single-file projects. Every project gets a folder with mandatory
structure right away:

```
02 Projekte/<Projekt-Name>/
├── <Projekt-Name> - PMO HUB.md   ★ Landing page (mandatory)
├── Projekt-Governance.md          ★ Tool stack (mandatory)
├── Meetings/                      One file per meeting
├── Decisions/                     ADRs — one file per decision
├── Research/                      Project-related research
├── assets/                        Diagrams, attachments
├── Risks/                         (Opt-in via risk_register: enabled)
└── Financials.md                  (Opt-in via financials_tool)
```

**Why a mandatory structure?**

- Consistency: everyone on the team knows where things live
- Wikilink stability: `[[<Projekt> - PMO HUB]]` works everywhere in the vault
- Dataview queries: rely on consistent paths
- `/lint` can detect drift and fix it

**What is forbidden in the root of the project folder:**

- `README.md` — the PMO HUB is the landing page
- Loose notes — they belong in a sub-folder (`Research/`, `Meetings/`, etc.)
- Other file types beyond the ones listed above

`/lint` flags such violations as whitelist errors.

## PMO HUB — the landing page

The hub is the **one file** that summarizes the whole project. Whoever wants
to understand the project reads the hub. Whoever works navigates from the
hub.

### Mandatory frontmatter

```yaml
---
tags: [projekt]
status: aktiv               # aktiv | abgeschlossen | pausiert
phase: konzeption           # konzeption | umsetzung | produktion | wartung
erstellt: 2026-05-21
aktualisiert: 2026-05-21
source: claude
chat_url: https://claude.ai/chat/...
governance: "[[Projekt-Governance]]"
related: []
---
```

Values like `status` and `phase` are the single source of truth — the
`Index.md` (vault cover) pulls its display from exactly this frontmatter.

### Sections in the hub

A typical hub has these sections:

```markdown
# <Projekt-Name>

> One-sentence description of the project.

## Project goal
Concrete goal, desired end state.

## Stakeholders
- Owner: @Person
- Involved: @Person, @Person
- Client: <internal | external>

## Stack
(Only for software projects: languages, frameworks, services in use)

## Daily activities
(Dataview query — aggregates daily notes with the project tag, see below)

## Open decisions
(Dataview query on Decisions/ with status: offen)

## Recent decisions
(Dataview query on Decisions/ with status: entschieden, LIMIT 5)

## Components
(Only for software: wikilinks to component notes in Components/)

## Backlog
Link to the backlog tool OR "Pre-Backlog Action Items" if `backlog_tool: none`

## Meetings
(Dataview query on Meetings/ — newest first)

## Research
Manual references to important research notes in Research/
```

The hub is **display, not storage**. The data lives in the sub-folders
(daily notes, decisions, meetings) — the hub aggregates it.

## Dataview aggregation — the trick

This is the heart of the setup. Instead of manually maintaining lists in
the hub, **Dataview queries** pull data live from the sub-folders:

### Daily activities from daily notes

````markdown
## Tagesaktivitaeten

```dataview
LIST file.link
FROM "05 Daily Notes"
WHERE contains(file.tags, "#mein-projekt-tag")
SORT file.name DESC
LIMIT 30
```
````

You write a section `## Mein-Projekt #mein-projekt-tag` in
`05 Daily Notes/2026-05-21.md` — the hub shows this daily note
automatically. No double maintenance.

### Open decisions from Decisions/

````markdown
## Offene Entscheidungen

```dataview
TABLE WITHOUT ID file.link AS "Entscheidung", erstellt
FROM "02 Projekte/<Projekt-Name>/Decisions"
WHERE status = "offen"
SORT erstellt DESC
```
````

You create `Decisions/ADR-05 Datenbank-Wahl.md` as a new ADR with
`status: offen` — the hub shows it right away.

### Recent decided ADRs

````markdown
## Letzte Entscheidungen

```dataview
TABLE WITHOUT ID file.link AS "Entscheidung", entschieden_am
FROM "02 Projekte/<Projekt-Name>/Decisions"
WHERE status = "entschieden"
SORT entschieden_am DESC
LIMIT 5
```
````

As soon as an ADR is set to `status: entschieden`, it moves from the upper
to the lower section. Visualized workflow state without code.

## Decisions as ADRs

ADR = Architecture Decision Record. One Markdown file per important
decision in `Decisions/`. The pattern comes from Michael Nygard (2011),
originally for software architecture — it works the same way for consulting,
marketing and personal projects.

### ADR structure

```yaml
---
type: entscheidung
status: offen           # offen | entschieden | verworfen
erstellt: 2026-05-21
entschieden_am: 2026-05-25
adr_nr: 5
tags: [projekt, mein-projekt-tag, decision]
---

# ADR-05: Database choice

## Context
What is the situation? Which pressure/constraint?

## Options
- A: PostgreSQL — known, robust, more ops overhead
- B: SQLite — simpler, sufficient for current scale
- C: Supabase — managed, fast start, vendor lock-in

## Decision
Option B (SQLite).

## Rationale
Current scale doesn't justify a server DB. SQLite handles 100k rows.
Migration to PostgreSQL stays possible.

## Consequences
- Backups: hourly during the day, daily at night
- Multi-writer constraint: only one service writes
- Migration path: re-evaluate in 6 months
```

### Why ADRs?

- **Later readability**: in 6 months you still understand *why* you decided what
- **Onboarding**: new teammates understand the stack without archaeology
- **Compound effect**: you spot patterns across projects (which decisions do you repeat?)
- **`/lint` checks consistency**: status ↔ entschieden_am, no offen without erstellt

## Project governance — the tool stack per project

Mandatory file per project: `Projekt-Governance.md`. It defines the **who
works where** for that project.

```yaml
---
type: governance
tags: [projekt, mein-projekt-tag, governance]
erstellt: 2026-05-21
aktualisiert: 2026-05-21
---

# Project governance

## Tool stack

| Discipline | Tool | Path / URL |
| ---------- | ---- | ---------- |
| Knowledge / docs | Obsidian | `02 Projekte/<Projekt-Name>/` |
| Backlog | Linear | https://linear.app/owlist/project/abc |
| Code | GitHub | https://github.com/vibercoder79/mein-repo |
| Code reviews | GitHub PRs | (see repo) |
| Communication | Slack / Teams | #mein-projekt |

## Backlog convention

- **Tool:** Linear
- **URL:** https://linear.app/owlist/project/abc
- **Filter:** `project:mein-projekt AND state != "Done"`
- **ID prefix:** `MP-` (e.g. `MP-42`)
- **Labels:** `meeting-action`, `decision`, `risk-mitigation`

## Risk tracking
risk_register: disabled    # disabled | enabled

## Financials
financials_tool: none      # none | excel | sheets | quickbooks
financials_url: —
```

### Why is this important?

- **Different tools per project possible**: client A uses Linear,
  client B Teams Kanban, an internal project only Pre-Backlog
- **AIs read the governance before backlog actions**: before Claude creates
  a task, it checks which tool is responsible for what
- **`/lint` checks consistency**: every project has a governance; a missing
  or empty governance is a compliance violation

## How the same structure emerges every time

Three mechanisms ensure that projects look the same everywhere:

### 1. AI-agnostic methodology

`00 Kontext/Workflows/Projekt-Anlegen.md` is the single source of truth for
the project creation workflow. It contains:

- The **10-question block** (language + 9 onboarding questions)
- The **language logic** (DE/EN)
- **Defaults per project type** (software → Linear, consulting → Teams Kanban, etc.)
- **Frontmatter schemas**
- **Phase workflow** (validation → backlog → folder → templates → verification)

All AIs read this file and run the same workflow. Claude, Gemini, Codex —
the result is identical because the methodology is identical.

### 2. Template source

`00 Kontext/Projekt-Struktur.md` contains the **templates** as code blocks:
PMO HUB template, governance template, ADR template, meeting template,
risk template, financials template. The AI reads the file and copies the
relevant blocks into the new project folder, **with real values** instead
of placeholders.

If you change the template here, it changes for **all future projects**.
Existing projects have to be migrated manually.

### 3. Skill automation

`/projekt-init` (see [chapter 06](06-skills.md)) automates the workflow
for Claude Code:

- Asks the 10 questions as one block
- Runs **MCP discovery** for backlog tools (Linear, M365 Teams Kanban) when
  configured
- Creates the folder structure
- Fills the templates with real values
- Verifies whitelist and mandatory files

Gemini and Codex have no skill — they do it manually based on the
methodology in `Projekt-Anlegen.md`. The result is the same, the path
differs.

## Container pattern for client groups

If you have **multiple projects for the same client**, there is the
container pattern:

```
02 Projekte/
├── _KUNDEN-A/                     ← Container (prefix _)
│   ├── 2026-04-15 Website-Redesign/
│   ├── 2026-05-01 SEO-Audit/
│   └── 2026-06-10 Email-Kampagne/
├── _INTERN/                       ← Container for internal projects
│   ├── Newsletter Q3/
│   └── Buchhaltung 2026/
└── Eigenstaendiges-Projekt/       ← Standard project
```

**Properties of a container:**

- **Prefix `_`** in the folder name — detected by lint as a container
- **No PMO HUB** at the container root — only sub-projects
- **No governance** — every sub-project has its own
- **Breaks no compliance rules** — `/lint` skips the container check
  for the root and only checks the sub-projects individually

Containers are pure collectors. They have no hub, no own logic, no
frontmatter. They only help keep the list of active projects (`Index.md`)
tidy.

## Anti-patterns (lessons learned)

Six mistakes that `/lint` can detect and report:

1. **`README.md` in the project root.** Classic from software repos. The hub
   is the landing page — no second entry point.
2. **Single-file projects.** Even a 2-day project gets a folder. It will
   grow anyway.
3. **Hub file is not named `<Projekt> - PMO HUB.md`.** Wikilinks break,
   Dataview queries don't find it.
4. **Decisions without `entschieden_am` on `status: entschieden`.** Frontmatter
   is inconsistent — Dataview filters become inaccurate.
5. **Markdown inside `Research/assets/`.** Images/PDFs belong in assets,
   Markdown notes go directly into `Research/`.
6. **Pre-Backlog items older than 30 days.** If you don't use a backlog tool
   but have 30+ days of open items: now would be a good time to enable
   a backlog tool.

`/lint projekte` checks exactly these points and proposes fixes — nothing is
changed automatically.

## Example: a project in 5 minutes

Trigger in Claude Code:

```
"Set up a project for Mein-Newsletter-Q3"
```

What happens:

1. Claude asks the 10-question block (1 minute)
2. You answer language, project type, stakeholders, backlog tool (2 minutes)
3. Claude creates:
   - Folder `02 Projekte/Mein-Newsletter-Q3/`
   - `Mein-Newsletter-Q3 - PMO HUB.md` with frontmatter + Dataview sections
   - `Projekt-Governance.md` with tool stack
   - Sub-folders `Meetings/`, `Decisions/`, `Research/`, `assets/`
   - With Linear/Teams: MCP discovery, auto-create with confirmation
4. Verification: whitelist check, wikilink check, Dataview syntax (1 minute)
5. Summary with "next steps" (1 minute)

Result after 5 minutes: a complete project setup you can start working with
right away. First meeting? In `Meetings/`. First decision? In `Decisions/`.
First research? In `Research/`.

## Next chapter

→ Back to the [README](../README.en.md) or directly to
[Chapter 06 — Skills](06-skills.md) for the skill that automates this.
