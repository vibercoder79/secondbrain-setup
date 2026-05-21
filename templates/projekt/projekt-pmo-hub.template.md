> # PMO Hub — Template
> Kopiere diese Datei in `~/Obsidian/SecondBrain/02 Projekte/<dein-projekt>/`
> und benenne sie um in `<Projektname> - PMO HUB.md`. Befuelle dann die Platzhalter.
> Original-Repo: https://github.com/vibercoder79/secondbrain-setup

---
tags: [projekt]
status: aktiv
phase: konzeption
erstellt: <JJJJ-MM-TT>
aktualisiert: <JJJJ-MM-TT>
language: de
source: claude
chat_url: <URL oder unbekannt>
governance: "[[Projekt-Governance]]"
related: []
---

# <Projektname>

> Einzeiler: Was ist das Projekt und warum machen wir es?

## Projektziel

Konkrete, messbare Ziele. Was ist der gewuenschte Endzustand?

## Status

**Phase:** Konzeption / Umsetzung / Abschluss

## Stack

> Nur wenn Software-Projekt. Sonst weglassen.

## Phasen

> Optional. Roadmap-Skizze wenn schon klar.

## Kosten

> Optional. Statische Schaetzung. Echte Tracking-Daten in Financials.md (opt-in).

## Repositories & Code

| Was | Pfad / URL |
|-----|-----------|
| GitHub Repo | https://github.com/... |
| Lokaler Pfad | `~/Documents/GitHub/...` |
| Deployment | https://... |

> Abschnitt weglassen wenn das Projekt keinen Code hat.

## Offene Entscheidungen

```dataview
TABLE WITHOUT ID file.link AS "Entscheidung", erstellt
FROM "02 Projekte/<Projektname>/Decisions"
WHERE status = "offen"
SORT erstellt DESC
```

## Letzte Entscheidungen

```dataview
TABLE WITHOUT ID file.link AS "Entscheidung", entschieden_am
FROM "02 Projekte/<Projektname>/Decisions"
WHERE status = "entschieden"
SORT entschieden_am DESC
LIMIT 5
```

## Offene Action Items aus Meetings

```dataview
TASK
FROM "02 Projekte/<Projektname>/Meetings"
WHERE !completed
GROUP BY file.link
```

## Top-Risiken (nur wenn Risk-Tracking aktiv)

```dataview
TABLE WITHOUT ID file.link AS "Risiko", score, status
FROM "02 Projekte/<Projektname>/Risks"
WHERE status != "geschlossen" AND score >= 12
SORT score DESC
LIMIT 5
```

## Backlog

Tasks werden gepflegt in: **[Tool-Name](url)** (siehe [[Projekt-Governance]])

## Notizen

Laufende Gedanken, Ideen, offene Fragen.

## Verknuepfungen

- [[Related Note 1]]
