> # User Story Template — Template
> This file belongs in `~/Obsidian/SecondBrain/00 Kontext/User-Story-Template.en.md`.
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

# User Story Template

> Mandatory standard for user stories and tasks that emerge from meetings, decisions, or
> project planning — to be transferred into the backlog tool (Linear, M365 Planner,
> GitHub Issues). Ensures consistent quality across all projects.

## Required Fields

Every task / user story MUST contain these fields — the skill validates this before
transferring to the backlog. If something is missing: ask the operator.

| Field | Required | Example | Where tracked |
|-------|----------|---------|---------------|
| **Title** | yes | "Set up Webflow CMS schema (47 fields)" | Backlog + Meeting |
| **Owner** | yes | @Person | Backlog: assignee |
| **Description** | yes | What exactly should be done? | Backlog: description |
| **Acceptance Criteria** | yes | Bullets, "if X, then Y" | Backlog: description |
| **Start Date** | yes | 2026-04-17 (default: today) | Backlog: start_date |
| **Due Date** | yes | 2026-04-30 | Backlog: due_date |
| **Provenance** | yes | Link to Meeting / Decision | Backlog: comment or description |
| **Labels** | yes | `meeting-action`, `decision`, `risk-mitigation`, `feature`, `bug` | Backlog: labels |

## Optional Fields

| Field | When useful |
|-------|-------------|
| Story Points / Estimate | Software projects with sprint planning |
| Definition of Done | Complex stories with multiple steps |
| Linked Decision | When story emerges from an ADR |
| Linked Risk | When story is a risk mitigation |
| Priority | High / Medium / Low (default Medium) |

## Markdown Block in Meeting File

This is how action items look in the meeting file BEFORE being transferred to the backlog:

```markdown
## Action Items

- [ ] **Set up Webflow CMS schema (47 fields)** @Person
  - Description: Set up schema for newsletter items in Webflow CMS, all 47 fields per research package
  - Acceptance: Schema live in Webflow, test item can be created
  - Start: 2026-04-17 | Due: 2026-04-30
  - Labels: meeting-action, infra
```

After transfer the block is augmented:
```markdown
- [ ] **Set up Webflow CMS schema (47 fields)** @Person → [PROJ-142](https://linear.app/...)
  - ... (rest unchanged)
```

## Validation Logic (for meeting-process skill)

When extracting from meeting files the skill checks per action item:

1. Does it have an **Owner** (`@Person`)? — If not: ask.
2. Does it have a **Description** beyond the title? — If not: ask.
3. Does it have **Date information** (Start + Due)? — If not: suggest Today + 14 days default.
4. Are **Acceptance Criteria** present? — If not: ask or mark as TODO in backlog.
5. Does it have a **Provenance** (= the meeting file itself)? — Add automatically.

## Embedding in the Backlog Tool

### Linear

```
title: <Title>
description:
  ## Description
  <Description>

  ## Acceptance Criteria
  - <AC 1>
  - <AC 2>

  ## Provenance
  From: [Meeting YYYY-MM-DD](obsidian://...)
assignee: <Owner>
labels: [<labels>]
startedAt: <Start Date>
dueDate: <Due Date>
```

### M365 Planner

```
Title: <Title>
Notes: <Description>
Checklist:
  - <AC 1>
  - <AC 2>
Assignment: <Owner>
Labels: <labels>
StartDate: <Start Date>
DueDate: <Due Date>
```

### GitHub Issues

```
title: <Title>
body:
  ## Description
  ...
  ## Acceptance Criteria
  - [ ] <AC 1>
  - [ ] <AC 2>
  ## Provenance
  ...
assignees: [<Owner>]
labels: [<labels>]
milestone: <optional due-date milestone>
```

## Language

This is the **English** version. German version: [[User-Story-Template]].
Which language is used for a concrete project is specified in its
`Projekt-Governance.md` frontmatter `language`.

## Origin

- **OpenCLAW Story Template** (vibercoder79/KI-Masterclass-Koerting/implement) -- mandatory fields
- **INVEST Criteria** (Bill Wake, 2003) -- Independent / Negotiable / Valuable / Estimable / Small / Testable
- **Standard Linear Issue schema** + M365 Planner task schema
