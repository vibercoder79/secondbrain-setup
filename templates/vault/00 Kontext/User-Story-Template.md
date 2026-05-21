> # User-Story-Template — Template
> Diese Datei gehoert in `~/Obsidian/SecondBrain/00 Kontext/User-Story-Template.md`.
> Sie ist Teil des SecondBrain-Setup-Templates. Original-Repo:
> https://github.com/vibercoder79/secondbrain-setup

---
tags: [kontext, template]
status: aktiv
erstellt: 2026-04-17
aktualisiert: 2026-04-17
source: claude
chat_url: unbekannt
---

# User-Story-Template

> Verbindlicher Standard fuer User Stories und Tasks die aus Meetings, Decisions oder
> Projekt-Planung entstehen — wird ins Backlog-Tool (Linear, M365 Planner, GitHub Issues)
> uebertragen. Sorgt fuer gleichbleibende Qualitaet ueber alle Projekte.

## Pflichtfelder

Jede Task / User Story MUSS diese Felder enthalten — der Skill prueft das vor Uebertrag
ins Backlog. Fehlt etwas: Nachfrage beim Operator.

| Feld | Pflicht | Beispiel | Wo gepflegt |
|------|---------|----------|-------------|
| **Titel** | ja | "Webflow CMS-Schema anlegen (47 Felder)" | Backlog + Meeting |
| **Owner** | ja | @Person | Backlog: assignee |
| **Beschreibung** | ja | Was genau soll getan werden? | Backlog: description |
| **Akzeptanzkriterien** | ja | Bullets, "wenn X, dann Y" | Backlog: description |
| **Startdatum** | ja | 2026-04-17 (Default: heute) | Backlog: start_date |
| **Enddatum** | ja | 2026-04-30 | Backlog: due_date |
| **Provenance** | ja | Link auf Meeting / Decision | Backlog: comment oder description |
| **Labels** | ja | `meeting-action`, `decision`, `risk-mitigation`, `feature`, `bug` | Backlog: labels |

## Optionale Felder

| Feld | Wann sinnvoll |
|------|---------------|
| Story Points / Schaetzung | Software-Projekte mit Sprint-Planung |
| Definition of Done | Komplexe Stories mit mehreren Schritten |
| Verlinkte Decision | Wenn Story aus einer ADR entstanden ist |
| Verlinktes Risiko | Wenn Story eine Risk-Mitigation ist |
| Prioritaet | High / Medium / Low (sonst Default Medium) |

## Markdown-Block fuer Meeting-File

So sehen Action Items im Meeting-File aus, BEVOR sie ins Backlog uebertragen werden:

```markdown
## Action Items

- [ ] **Webflow CMS-Schema anlegen (47 Felder)** @Person
  - Beschreibung: Schema fuer Newsletter-Items in Webflow CMS aufsetzen, alle 47 Felder gemaess Research-Paket
  - Akzeptanz: Schema in Webflow live, Test-Item kann angelegt werden
  - Start: 2026-04-17 | Ende: 2026-04-30
  - Labels: meeting-action, infra
```

Nach Uebertrag wird der Block ergaenzt:
```markdown
- [ ] **Webflow CMS-Schema anlegen (47 Felder)** @Person → [PROJ-142](https://linear.app/...)
  - ... (Rest unveraendert)
```

## Validierungs-Logik (fuer meeting-process Skill)

Beim Extrahieren aus Meeting-Files prueft der Skill pro Action Item:

1. Hat es einen **Owner** (`@Person`)? — Wenn nein: nachfragen.
2. Hat es eine **Beschreibung** ueber den Titel hinaus? — Wenn nein: nachfragen.
3. Hat es **Datum-Angaben** (Start + Ende)? — Wenn nein: vorschlagen Heute + 14 Tage Default.
4. Sind **Akzeptanzkriterien** vorhanden? — Wenn nein: nachfragen oder als TODO im Backlog markieren.
5. Hat es eine **Provenance** (= das Meeting-File selbst)? — Automatisch hinzufuegen.

## Einbettung im Backlog-Tool

### Linear

```
title: <Titel>
description:
  ## Beschreibung
  <Beschreibung>

  ## Akzeptanzkriterien
  - <AK 1>
  - <AK 2>

  ## Provenance
  Aus: [Meeting YYYY-MM-DD](obsidian://...)
assignee: <Owner>
labels: [<labels>]
startedAt: <Startdatum>
dueDate: <Enddatum>
```

### M365 Planner

```
Title: <Titel>
Notes: <Beschreibung>
Checklist:
  - <AK 1>
  - <AK 2>
Assignment: <Owner>
Labels: <labels>
StartDate: <Startdatum>
DueDate: <Enddatum>
```

### GitHub Issues

```
title: <Titel>
body:
  ## Beschreibung
  ...
  ## Akzeptanzkriterien
  - [ ] <AK 1>
  - [ ] <AK 2>
  ## Provenance
  ...
assignees: [<Owner>]
labels: [<labels>]
milestone: <ggf. Enddatum-Milestone>
```

## Sprache

Diese Template ist die **deutsche** Version. Englische Version: [[User-Story-Template.en]].
Welche Sprache fuer ein konkretes Projekt verwendet wird, steht in dessen
`Projekt-Governance.md` Frontmatter `language`.

## Herkunft

- **OpenCLAW Story-Template** (vibercoder79/KI-Masterclass-Koerting/implement) -- Pflichtfelder
- **INVEST-Kriterien** (Bill Wake, 2003) -- Independent / Negotiable / Valuable / Estimable / Small / Testable
- **Standard Linear Issue-Schema** + M365 Planner Task-Schema
