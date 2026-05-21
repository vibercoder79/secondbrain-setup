> # Project Structure — Template
> This file belongs in `~/Obsidian/SecondBrain/00 Kontext/Projekt-Struktur.en.md`.
> It is part of the SecondBrain setup template. Original repo:
> https://github.com/vibercoder79/secondbrain-setup

---
tags: [context, template]
status: active
created: 2026-04-17
updated: 2026-04-17
source: claude
chat_url: unknown
---

# Project Structure (English)

> Mandatory structure for all English-language projects in the SecondBrain. Used when
> the project language is set to `language: en` in `Projekt-Governance.md`.
> German counterpart: [[Projekt-Struktur]].

## Core Principles

- **Obsidian = knowledge.** Meeting minutes, decisions, risks, research, documentation.
- **Backlog tool = work.** Tasks, status, owner, due dates. Tool is set in `Projekt-Governance.md`.
- **One source per piece of information.** No duplicate tracking.
- **Provenance stays intact.** Tasks in the backlog tool link back to the meeting minute they came from.
- **PMO HUB = project overview.** Static info + live views (Dataview) on decisions/meetings/risks. No data storage, just entry point.

## Directory Structure

Projects are ALWAYS created as folders with the full structure — no single files.

```
02 Projekte/ProjectName/
+-- ProjectName - PMO HUB.md          <-- Hub file (project overview / PMO landing page)
+-- Projekt-Governance.md             <-- Mandatory: tool stack + backlog convention
+-- Meetings/                         <-- One file per meeting
|   +-- Customer/                     <-- Optional: subfolders per meeting type
|   |   +-- YYYY-MM-DD Topic.md
|   +-- Internal/
|   +-- Development/
+-- Decisions/                        <-- ADRs: one file per decision
|   +-- YYYY-MM-DD Title.md
+-- Research/                         <-- Project-specific research (optional)
|   +-- README.md
+-- assets/                           <-- Images, diagrams, Excalidraw
+-- Risks/                            <-- OPT-IN: Risk Register
|   +-- YYYY-MM-DD Title.md
+-- Financials.md                     <-- OPT-IN: budget snapshot + links
```

**Subfolders in `Meetings/` are optional.** Flat for few meetings, split (Customer/Internal/Development) for many.

**`Risks/` and `Financials.md` are opt-in** — not created automatically, only via explicit trigger or onboarding answer.

**Note:** File and folder names like `Meetings/`, `Decisions/`, `Research/`, `assets/`, `Risks/`, `Financials.md`, `Projekt-Governance.md` stay the SAME across both language variants — only the *content* of the files is translated. This keeps the project structure visually recognizable.

---

## File Whitelist in Project Root

Only these files are allowed in the project root folder (`02 Projekte/<Project>/`):

| File | Required? |
|------|-----------|
| `<Project> - PMO HUB.md` | yes |
| `Projekt-Governance.md` | yes |
| `Financials.md` | opt-in |

All other files MUST go into a subfolder (`Meetings/`, `Decisions/`, `Risks/`, `Research/`, `assets/`).

### `README.md` in the project root is forbidden

Reason: The PMO HUB IS the landing page of the project. An additional README would
be a duplicate and cause conflicts ("which file is the real one?"). If a `README.md`
exists for historical reasons: move to the matching subfolder (usually `Research/README.md`)
or integrate into the PMO HUB.

### Research Placement Rule

Two places for research:

| Type | Location | Reason |
|------|----------|--------|
| **Vault-wide deep research** (used by multiple projects or no project link) | `04 Ressourcen/Research/YYYY-MM-DD Topic/` | Vault-central knowledge asset |
| **Project-specific research** (only this project) | `02 Projekte/<Project>/Research/` | Lives with the project |

Within `Research/`:
- Markdown documents live **directly** in `Research/` (e.g., `Research/01-Topic.md`)
- Only images, SVGs, PDFs and attachments go into `Research/assets/`
- For multiple markdown docs: `README.md` as entry point, files with prefix numbers (`01-`, `02-`, ...)

---

## Onboarding Dialog (mandatory when creating a project)

When `/projekt-init` or "new project" / "create a project" / "set up a project for..."
is triggered, Claude ALWAYS asks the following block first — all questions at once:

```
Before I create the project, I need some context:

MANDATORY:
0. Project language?
   a) German
   b) English
1. Project name?
2. One-sentence description (what is it about)?
3. Concrete goal / desired end state?
4. Project type?
   a) Software / Development
   b) Consulting / Client project
   c) Marketing / Content
   d) Personal / Learning
   e) Other
5. Stakeholder / Client? (internal / external name)
6. Backlog tool?
   a) Linear (recommended for Software)
   b) Teams-Kanban / M365 (recommended for Consulting)
   c) GitHub Issues
   d) not decided yet → none

OPTIONAL (leave blank if not wanted):
7. GitHub repo URL (if code)?
8. Activate risk tracking? (default: no)
9. Activate financials tracking? (default: no)
```

### Default Table per Project Type

If the operator hesitates or says "default":

| Type | Backlog | Risks | Financials | Default tags |
|------|---------|-------|------------|--------------|
| Software | Linear | no | no | `[development]` |
| Consulting | Teams-Kanban | **yes** | **yes** | `[consulting, client]` |
| Marketing | none or Notion | no | optional | `[marketing, content]` |
| Personal | none | no | no | `[learning]` |
| Other | none | no | no | — |

### Dialog rules

- Never create a project without onboarding (exception: operator says "no questions" / "default")
- If an answer is missing: use default + note "can be changed later"
- Derive tags and `related: [[...]]` from context (example: "Example program project" → `related: [[Example-Program]]`, tag `example-program`)
- If `risk_register: yes` → create `Risks/` folder + insert Top-Risks block in Hub
- If `financials_tool != none` → create `Financials.md` from template + add cost block in Hub

---

## Hub File Template

**Filename is ALWAYS:** `<Project> - PMO HUB.md`

The "PMO HUB" suffix makes the central PMO file vault-wide findable (search "PMO HUB" lists all hubs).

The hub file is project overview — static info + live views via Dataview. No data storage.

```markdown
---
tags: [project]
status: active
phase: discovery
created: YYYY-MM-DD
updated: YYYY-MM-DD
language: en
source: claude
chat_url: https://claude.ai/chat/...
governance: "[[Projekt-Governance]]"
related: []
---

# ProjectName

> One-liner: What is the project and why do we do it?

## Goal

Concrete, measurable goals. What is the desired end state?

## Status

**Phase:** Discovery / Delivery / Closeout

## Stack

> Only for software projects. Otherwise omit.

## Phases

> Optional. Roadmap sketch if already clear.

## Cost

> Optional. Static estimate. Real tracking in Financials.md (opt-in).

## Repositories & Code

| What | Path / URL |
|------|-----------|
| GitHub Repo | https://github.com/... |
| Local path | `~/Documents/GitHub/...` |
| Deployment | https://... |

> Omit this section if the project has no code.

## Open Decisions

```dataview
TABLE WITHOUT ID file.link AS "Decision", created
FROM "02 Projekte/ProjectName/Decisions"
WHERE status = "open"
SORT created DESC
```

## Recent Decisions

```dataview
TABLE WITHOUT ID file.link AS "Decision", decided_on
FROM "02 Projekte/ProjectName/Decisions"
WHERE status = "decided"
SORT decided_on DESC
LIMIT 5
```

## Open Action Items from Meetings

```dataview
TASK
FROM "02 Projekte/ProjectName/Meetings"
WHERE !completed
GROUP BY file.link
```

## Top Risks (only if risk tracking active)

```dataview
TABLE WITHOUT ID file.link AS "Risk", score, status
FROM "02 Projekte/ProjectName/Risks"
WHERE status != "closed" AND score >= 12
SORT score DESC
LIMIT 5
```

## Backlog

Tasks are tracked in: **[Tool Name](url)** (see [[Projekt-Governance]])

## Notes

Ongoing thoughts, ideas, open questions.

## Links

- [[Related Note 1]]
```

---

## Projekt-Governance Template (English variant)

**Filename:** `Projekt-Governance.md` — same filename as German variant, only content is English.

```markdown
---
type: governance
project: "[[ProjectName]]"
language: en
backlog_tool: none           # linear | teams-kanban | github-issues | jira | notion | none
backlog_url: ""
backlog_filter: ""
backlog_id_prefix: ""
risk_register: disabled      # enabled | disabled
financials_tool: none        # excel | accounting-tool | stripe | none
financials_url: ""
pipeline_workflow_id: ""
created: YYYY-MM-DD
updated: YYYY-MM-DD
source: claude
chat_url: unknown
---

# Project Governance — ProjectName

> Tool stack and conventions for this project. Single source of truth for Claude on all
> backlog / risk / financials actions.

## Tool Stack

| Function | Tool | URL / Path |
|----------|------|-----------|
| Backlog | Linear / Teams-Kanban / none | https://... |
| Code | GitHub | https://github.com/... |
| Communication | Slack / Teams / Mail | #channel |
| Risk register | Obsidian Risks/ (if enabled) / external | — |
| Financials | Excel / Accounting / none | path or URL |
| Documentation | Obsidian | this vault |

## Backlog Convention

> Only fill in if `backlog_tool != none`.

- **Project / Board:** ...
- **Labels:** `meeting-action`, `decision`, `risk-mitigation`, `feature`, `bug`
- **ID prefix:** ...
- **Owner:** @...

## Workflows

### Transfer meeting action items
Trigger phrases: "transfer action items", "create tasks from meeting"
1. Read latest file in `Meetings/`
2. Extract open checkboxes as tasks
3. Create in backlog tool with label `meeting-action`
4. Write issue IDs back into meeting file: `- [ ] Task @Person → [PROJ-142](url)`

### Turn decision into user story
Trigger phrase: "create user story from latest decision"
1. Read latest file in `Decisions/`
2. If technical consequences → create tasks in backlog tool with label `decision`
3. Enter issue IDs into `backlog_issues` of the decision file

### Transfer risk mitigations to backlog
> Only if `risk_register: enabled` and `backlog_tool != none`.
Trigger phrase: "create mitigations from risk XYZ"
1. Read risk file in `Risks/`
2. Extract mitigation list
3. Create in backlog tool with label `risk-mitigation`
4. Enter issue IDs into `backlog_issues` of the risk file

### Status sync (manual on demand)
Trigger phrase: "sync backlog status"
- Read backlog tool
- Check off completed action items in meeting files
- Mark closed decisions as `decided`

## Owners

- Owner: @...
- Stakeholders: ...
```

---

## Decision Template (ADR, English)

**Path:** `Decisions/YYYY-MM-DD Title.md`

```markdown
---
type: decision
project: "[[ProjectName]]"
status: open            # open | decided | rejected
created: YYYY-MM-DD
decided_on: 
tags: [decision]
source: claude
chat_url: unknown
backlog_issues: []      # Linear/issue IDs created from this decision
---

# Decision: Title

## Question

> What is the open question?

## Options

### Option A: ...
- Pro: ...
- Con: ...

### Option B: ...
- Pro: ...
- Con: ...

## Decision

> If `status: open` → leave blank.
> If `status: decided` → clear statement.

## Reasoning

Why this option?

## Consequences

What follows from this? What tasks arise? (Tasks themselves go into the backlog tool,
here only the list as provenance.)

## Links

- [[Meeting where this was discussed]]
- [[Related Decision]]
```

---

## Risk Template (opt-in, ADR pattern)

**Path:** `Risks/YYYY-MM-DD Title.md` — only if `risk_register: enabled` in Governance.

```markdown
---
type: risk
project: "[[ProjectName]]"
status: identified          # identified | mitigated | accepted | closed
created: YYYY-MM-DD
closed_on: 
likelihood: 3               # 1 (very unlikely) - 5 (very likely)
impact: 4                   # 1 (minor) - 5 (critical)
score: 12                   # likelihood * impact
category: technical         # technical | organizational | financial | legal | external
tags: [risk]
source: claude
chat_url: unknown
backlog_issues: []          # IDs of mitigation tasks in backlog tool
---

# Risk: Title

## Description

> What is the risk? What happens if it materializes?

## Likelihood

**Likelihood:** {1-5} — reasoning

## Impact

**Impact:** {1-5} — reasoning (cost, delay, reputation, ...)

## Score

**Score:** {likelihood * impact} — interpretation:
- 1-4: low (monitor)
- 5-11: medium (plan)
- 12-19: high (act now)
- 20-25: critical (escalate)

## Triggers / early indicators

> How do we recognize that the risk is materializing?

## Mitigation

> How do we reduce likelihood or impact?
> Concrete mitigation tasks go into the backlog tool, here only the strategy.

- ...

## Contingency Plan

> What to do if the risk actually materializes?

## Owner

- Responsible: @...

## Links

- [[Related Decision]]
- [[Related Meeting]]
```

---

## Financials Template (opt-in, English)

**Path:** `Financials.md` — only if `financials_tool != none` in Governance.

File holds snapshot + links to the real tool. Not a full bookkeeping tool.

```markdown
---
type: financials
project: "[[ProjectName]]"
language: en
financials_tool: excel
financials_url: "~/Documents/Budget.xlsx"
budget_total: 50000
budget_currency: CHF
budget_period: "2026"
created: YYYY-MM-DD
updated: YYYY-MM-DD
source: claude
chat_url: unknown
---

# Financials — ProjectName

> Snapshot and links to the real financial tool. Full bookkeeping lives externally.

## Budget Overview

| Position | Amount | Note |
|----------|--------|------|
| Total budget | 50000 CHF | Approved on YYYY-MM-DD |
| Spent so far | 0 CHF | As of: YYYY-MM-DD |
| Remaining | 50000 CHF | — |

## Cost categories (estimate)

| Category | Amount | Share |
|----------|--------|-------|
| Personnel | ... | ... |
| Tools / licenses | ... | ... |
| Hosting / infra | ... | ... |
| External contractors | ... | ... |

## External sources

- **Real budget:** [Excel file](file://...)
- **Bookkeeping:** [Tool](url)
- **Stripe dashboard:** [link](url)

## Notes

> Changes, approvals, escalations.
```

---

## Meeting Note Template (English)

**Path:** `Meetings/[subfolder/]YYYY-MM-DD Topic.md`

```markdown
---
type: meeting
meeting_type: customer     # customer | internal | development
project: "[[ProjectName]]"
date: YYYY-MM-DD
attendees:
  - "[[Person 1]]"
  - "[[Person 2]]"
tags: [meeting]
source: claude
chat_url: unknown
---

# YYYY-MM-DD -- Meeting Topic

## Agenda
- 

## Notes
- 

## Decisions
- 
> For larger decisions: create an ADR file in `Decisions/` and link here.

## Risks (if discussed)
- 
> If risk tracking is active: create file in `Risks/` and link here.

## Action Items
> Follows the User Story Template — see [[User-Story-Template.en]].

- [ ] **Task Title** @Person
  - Description: ...
  - Acceptance: ...
  - Start: YYYY-MM-DD | Due: YYYY-MM-DD
  - Labels: meeting-action

> Action items are transferred on demand to the backlog tool (see [[Projekt-Governance]]).
> Format after transfer: `- [ ] Task @Person → [PROJ-142](url)`
> When the backlog tool marks the task as done: check off here too.
```

---

## Language Reference

- User Story Template: [[User-Story-Template.en]]
- German variant of this file: [[Projekt-Struktur]]
- German user-story template: [[User-Story-Template]]

---

## Origin

- **Dann Berg Meeting Note Template** -- meeting structure
- **PARA Starter Kit** -- hub-file principle
- **ADR pattern** (Michael Nygard, 2011) -- decisions as own files
- **PMI / PRINCE2 Risk Register** -- risk template (likelihood x impact, score interpretation)
- **OpenCLAW Governance** (vibercoder79/KI-Masterclass-Koerting) -- governance file principle, onboarding phase 0
- **INVEST Criteria** (Bill Wake, 2003) -- user story quality standard
