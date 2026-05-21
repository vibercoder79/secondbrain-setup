> # Projekt-Struktur — Template
> Diese Datei gehoert in `~/Obsidian/SecondBrain/00 Kontext/Projekt-Struktur.md`.
> Sie ist Teil des SecondBrain-Setup-Templates. Original-Repo:
> https://github.com/vibercoder79/secondbrain-setup

---
tags: [kontext, template]
status: aktiv
erstellt: 2026-04-15
aktualisiert: 2026-04-17
source: claude
chat_url: unbekannt
---

# Projekt-Struktur

> Verbindliche Struktur fuer alle Projekte im SecondBrain. Gilt fuer Claude und alle anderen KIs.

## Grundprinzipien

- **Obsidian = Wissen.** Meeting Minutes, Decisions, Risks, Research, Doku.
- **Backlog-Tool = Arbeit.** Tasks, Status, Owner, Due Dates. Welches Tool steht in `Projekt-Governance.md`.
- **Eine Quelle pro Information.** Keine doppelte Pflege von Tasks oder Entscheidungen.
- **Provenance bleibt erhalten.** Tasks im Backlog-Tool verlinken zurueck auf die Meeting-Minute, aus der sie stammen.
- **Hub-Datei = Projektuebersicht.** Statische Projekt-Info + Live-Sichten (Dataview) auf Decisions/Meetings/Risks. Keine Datenhaltung, nur Einstieg.

## Verzeichnisstruktur

Projekte werden IMMER als Ordner mit vollstaendiger Struktur angelegt — keine Einzeldateien.

```
02 Projekte/Projektname/
+-- Projektname - PMO HUB.md      <-- Hub-Datei (Projektuebersicht / PMO Landing Page)
+-- Projekt-Governance.md         <-- Pflicht: Tool-Stack + Backlog-Konvention
+-- Meetings/                     <-- Ein File pro Meeting
|   +-- Kunde/                    <-- Optional: Subordner pro Meeting-Typ
|   |   +-- YYYY-MM-DD Thema.md
|   +-- Intern/
|   +-- Entwicklung/
+-- Decisions/                    <-- ADRs: Eine Datei pro Entscheidung
|   +-- YYYY-MM-DD Titel.md
+-- Research/                     <-- Projekt-spezifische Recherche (optional)
|   +-- README.md
+-- assets/                       <-- Bilder, Diagramme, Excalidraw
+-- Risks/                        <-- OPT-IN: Risk Register
|   +-- YYYY-MM-DD Titel.md
+-- Financials.md                 <-- OPT-IN: Budget-Snapshot + Links
```

**Subordner unter `Meetings/` sind optional.** Bei wenigen Meetings flach lassen, bei vielen aufteilen.

**`Risks/` und `Financials.md` sind opt-in.** Werden nicht beim Anlegen automatisch erzeugt — nur via expliziten Trigger oder Onboarding-Antwort.

---

## File-Whitelist im Projektwurzel

Im Projekt-Wurzelordner (`02 Projekte/<Projekt>/`) sind **NUR** diese Dateien erlaubt:

| Datei | Pflicht? |
|-------|----------|
| `<Projekt> - PMO HUB.md` | ja |
| `Projekt-Governance.md` | ja |
| `Financials.md` | opt-in |

Alle anderen Dateien MUESSEN in einen Subordner (`Meetings/`, `Decisions/`, `Risks/`, `Research/`, `assets/`).

### `README.md` im Projektwurzel ist verboten

Begruendung: Der PMO HUB IST die Landing Page des Projekts. Eine zusaetzliche README waere Doppelung und fuehrt zu Konflikten ("welche Datei ist die echte?"). Falls eine `README.md` aus historischen Gruenden existiert: in den passenden Subordner verschieben (meistens `Research/README.md` als Index eines Research-Pakets) oder in den PMO HUB integrieren.

### Research-Ablage-Regel

Es gibt zwei Orte fuer Research:

| Typ | Ort | Begruendung |
|-----|-----|-------------|
| **Vault-weite Deep Research** (mehrere Projekte nutzen sie, oder kein Projekt-Bezug) | `04 Ressourcen/Research/YYYY-MM-DD Thema/` | Vault-zentrales Knowledge Asset |
| **Projekt-spezifische Research** (nur dieses Projekt) | `02 Projekte/<Projekt>/Research/` | Lebt mit dem Projekt |

Innerhalb von `Research/`:
- Markdown-Dokumente liegen **direkt** in `Research/` (z.B. `Research/01-Thema.md`)
- Nur Bilder, SVGs, PDFs und Anhaenge in `Research/assets/`
- Bei mehreren Markdown-Dokumenten: `README.md` als Einstieg, Files mit Prefix-Nummern (`01-`, `02-`, ...)

**Falsch:** `Research/assets/01-Architektur.md` (Markdown im assets-Subordner)
**Richtig:** `Research/01-Architektur.md` + `Research/assets/diagramm.svg`

---

## Onboarding-Dialog (Pflicht beim Anlegen)

Beim Trigger "lege ein Projekt an" / "neues Projekt" / "Projekt anlegen" / "erstelle ein Projekt fuer..." stellt Claude IMMER ZUERST diesen Block — alle Fragen auf einmal:

```
Bevor ich das Projekt anlege, brauche ich kurz Kontext:

PFLICHT:
0. Projekt-Sprache?
   a) Deutsch
   b) Englisch
1. Projektname?
2. Ein-Satz-Beschreibung (worum geht es)?
3. Konkretes Ziel / gewuenschter Endzustand?
4. Projekt-Typ?
   a) Software / Entwicklung
   b) Beratung / Kundenprojekt
   c) Marketing / Content
   d) Persoenlich / Lernen
   e) Anderes
5. Stakeholder / Kunde? (intern / Name extern)
6. Backlog-Tool?
   a) Linear (empfohlen fuer Software)
   b) Teams-Kanban / M365 (empfohlen fuer Beratung)
   c) GitHub Issues
   d) noch nicht entschieden → none

OPTIONAL (leer lassen ist ok):
7. GitHub-Repo-URL (falls Code)?
8. Risk-Tracking aktivieren? (default: nein)
9. Financials-Tracking aktivieren? (default: nein)
```

### Sprach-Logik (Frage 0)

Die Projekt-Sprache bestimmt, welche Templates verwendet und welche Sprache im
Projekt-Inhalt geschrieben wird:

| Projekt-Sprache | Template-Quelle | Frontmatter-Werte | Sprache der Inhalte |
|-----------------|-----------------|-------------------|---------------------|
| Deutsch (default) | [[Projekt-Struktur]] (diese Datei) | `status: aktiv`, `phase: konzeption` | Deutsch |
| Englisch | [[Projekt-Struktur.en]] | `status: active`, `phase: discovery`, `language: en` | Englisch |

**Wichtig:** Datei- und Ordnernamen bleiben in beiden Varianten GLEICH
(`Projekt-Governance.md`, `Meetings/`, `Decisions/`, `Risks/`, `Research/`, `assets/`,
`Financials.md`, `<Projekt> - PMO HUB.md`). Nur der *Inhalt* der Dateien ist uebersetzt.
Das haelt die Struktur vault-weit wiedererkennbar.

**User-Story-Template:** [[User-Story-Template]] (Deutsch) / [[User-Story-Template.en]] (Englisch) — jede Task/Story im Projekt folgt der Sprach-passenden Version.

### Default-Tabelle pro Projekt-Typ

Wenn der Operator zoegert oder "default" sagt:

| Typ | Backlog | Risks | Financials | Default-Tags (DE) | Default-Tags (EN) |
|------|---------|-------|------------|-------------------|-------------------|
| Software | Linear | nein | nein | `[entwicklung]` | `[development]` |
| Beratung | Teams-Kanban | **ja** | **ja** | `[beratung, kunde]` | `[consulting, client]` |
| Marketing | none oder Notion | nein | optional | `[marketing, content]` | `[marketing, content]` |
| Persoenlich | none | nein | nein | `[lernen]` | `[learning]` |
| Anderes | none | nein | nein | — | — |

Tags richten sich nach der **Projekt-Sprache** (Frage 0).

### Regeln fuer den Dialog

- Niemals Projekt anlegen ohne Onboarding (Ausnahme: Operator sagt "ohne Fragen" oder "Standard")
- Bei fehlender Antwort: Default verwenden + Hinweis "kann spaeter geaendert werden"
- Tags und `related: [[...]]` aus Kontext ableiten (Beispiel: "Beispiel-Programm-Projekt" → `related: [[Beispiel-Programm]]`, tag `beispiel-programm`)
- Wenn `risk_register: yes` → `Risks/` Ordner anlegen + Top-Risiken-Block in Hub einfuegen
- Wenn `financials_tool != none` → `Financials.md` mit Template anlegen + Kosten-Block in Hub einfuegen

---

## Hub-Datei Template

**Dateiname ist IMMER:** `Projektname - PMO HUB.md`

Suffix "- PMO HUB" macht die zentrale Projekt-Management-Office-Datei eindeutig auffindbar (Suche nach "PMO HUB" listet alle Hubs auf einen Schlag).

Die Hub-Datei ist Projektuebersicht — statische Info + Live-Sichten via Dataview. Keine Datenhaltung.

```markdown
---
tags: [projekt]
status: aktiv
phase: konzeption
erstellt: YYYY-MM-DD
aktualisiert: YYYY-MM-DD
language: de
source: claude
chat_url: https://claude.ai/chat/...
governance: "[[Projekt-Governance]]"
related: []
---

# Projektname

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
FROM "02 Projekte/Projektname/Decisions"
WHERE status = "offen"
SORT erstellt DESC
```

## Letzte Entscheidungen

```dataview
TABLE WITHOUT ID file.link AS "Entscheidung", entschieden_am
FROM "02 Projekte/Projektname/Decisions"
WHERE status = "entschieden"
SORT entschieden_am DESC
LIMIT 5
```

## Offene Action Items aus Meetings

```dataview
TASK
FROM "02 Projekte/Projektname/Meetings"
WHERE !completed
GROUP BY file.link
```

## Top-Risiken (nur wenn Risk-Tracking aktiv)

```dataview
TABLE WITHOUT ID file.link AS "Risiko", score, status
FROM "02 Projekte/Projektname/Risks"
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
```

---

## Projekt-Governance Template

**Dateiname:** `Projekt-Governance.md` — Pflicht-Datei pro Projekt. Wenn das Projekt kein Backlog-Tool nutzt, `backlog_tool: none` setzen.

Claude liest diese Datei IMMER ZUERST bei Backlog-/Risk-/Financials-bezogenen Aktionen.

```markdown
---
type: governance
project: "[[Projektname]]"
language: de                 # de | en
backlog_tool: none           # linear | teams-kanban | github-issues | jira | notion | none
backlog_url: ""
backlog_filter: ""
backlog_id_prefix: ""
risk_register: disabled      # enabled | disabled
financials_tool: none        # excel | accounting-tool | stripe | none
financials_url: ""
pipeline_workflow_id: ""     # n8n-Workflow-ID wenn aktiv, sonst leer
erstellt: YYYY-MM-DD
aktualisiert: YYYY-MM-DD
source: claude
chat_url: unbekannt
---

# Projekt-Governance — Projektname

> Tool-Stack und Konventionen fuer dieses Projekt. Single Source of Truth fuer Claude bei allen Backlog-/Risk-/Financials-Aktionen.

## Tool-Stack

| Funktion | Tool | URL / Pfad |
|----------|------|-----------|
| Backlog | Linear / Teams-Kanban / none | https://... |
| Code | GitHub | https://github.com/... |
| Kommunikation | Slack / Teams / Mail | #channel |
| Risk-Register | Obsidian Risks/ (wenn enabled) / extern | — |
| Financials | Excel / Accounting / none | Pfad oder URL |
| Doku | Obsidian | dieses Vault |

## Backlog-Konvention

> Nur ausfuellen wenn `backlog_tool != none`.

- **Project / Board:** ...
- **Labels:** `meeting-action`, `decision`, `risk-mitigation`, `feature`, `bug`
- **ID-Prefix:** ...
- **Owner:** @...

## Workflows

### Meeting Action Items uebertragen
Trigger-Saetze: "uebertrag Action Items", "leg Tasks aus Meeting an"
1. Lies neueste Datei in `Meetings/`
2. Extrahiere offene Checkboxes als Tasks
3. Lege im Backlog-Tool an mit Label `meeting-action`
4. Schreib Issue-IDs zurueck ins Meeting-File: `- [ ] Aufgabe @Person → [PROJ-142](url)`

### Decision in User Story uebersetzen
Trigger-Saetze: "leg User Story aus letzter Decision an"
1. Lies neueste Datei in `Decisions/`
2. Wenn technische Konsequenzen → Tasks im Backlog-Tool anlegen mit Label `decision`
3. Trage Issue-IDs in `backlog_issues` der Decision-Datei ein

### Risk-Mitigation in Backlog uebertragen
> Nur wenn `risk_register: enabled` und `backlog_tool != none`.
Trigger-Satz: "leg Mitigations aus Risiko XYZ an"
1. Lies Risk-File in `Risks/`
2. Extrahiere Mitigation-Liste
3. Lege im Backlog-Tool an mit Label `risk-mitigation`
4. Trage Issue-IDs in `backlog_issues` der Risk-Datei ein

### Status-Sync (manuell auf Anfrage)
Trigger-Satz: "sync den Backlog-Status"
- Lies Backlog-Tool
- Hake erledigte Action Items in den Meeting-Files ab
- Markiere geschlossene Decisions als `entschieden`

## Verantwortliche

- Owner: @...
- Stakeholder: ...
```

---

## Decision Template (ADR)

**Pfad:** `Decisions/YYYY-MM-DD Titel.md`

```markdown
---
type: entscheidung
project: "[[Projektname]]"
status: offen           # offen | entschieden | verworfen
erstellt: YYYY-MM-DD
entschieden_am: 
tags: [entscheidung]
source: claude
chat_url: unbekannt
backlog_issues: []      # Linear/Issue-IDs die aus dieser Decision entstanden sind
---

# Entscheidung: Titel

## Fragestellung

> Was ist die offene Frage?

## Optionen

### Option A: ...
- Pro: ...
- Contra: ...

### Option B: ...
- Pro: ...
- Contra: ...

## Entscheidung

> Wenn `status: offen` → leer lassen.
> Wenn `status: entschieden` → klare Aussage.

## Begruendung

Warum diese Option?

## Konsequenzen

Was folgt daraus? Welche Tasks entstehen? (Tasks selbst gehen ins Backlog-Tool, hier nur die Auflistung als Provenance.)

## Verknuepfungen

- [[Meeting in dem das besprochen wurde]]
- [[Related Decision]]
```

### Akzeptierte Alternative: ADR-Pattern mit `tags: [adr]` (Code-Repo-Mirror)

Projekte mit gespiegelter Repo-Doku nutzen ein paralleles ADR-Schema mit fortlaufender Nummerierung. Diese Variante ist **gleichberechtigt** zur Standard-Variante oben.

```markdown
---
tags: [adr, <projekt-tag>]
status: entschieden        # offen | entschieden | verworfen
adr_nr: 25                 # fortlaufende ADR-Nummer im Projekt
erstellt: YYYY-MM-DD
entschieden_am: YYYY-MM-DD
language: de
source: claude
chat_url: unbekannt
parent: "[[<Projekt> - PMO HUB]]"
related: "[[Andere Entscheidung]]"
---

# ADR-25: Titel

> **Datum:** YYYY-MM-DD | **Status:** Accepted | **Issue:** PROJ-360

## Kontext / Status

## Entscheidung

## Begruendung

## Konsequenzen
```

**Wann diese Variante:** Wenn das Projekt einen Code-Repo-Mirror unter `journal/` oder `docs/decisions/` fuehrt und die ADRs auch dort verfuegbar sein sollen.

**Wann die Standard-Variante (`type: entscheidung`):** Default fuer alle Projekte ohne Repo-Mirror — bessere Dataview-Vorlagen-Kompatibilitaet (PMO HUB filtert auf `type` und `status`).

**Wichtig:** Nicht beide Varianten im selben Projekt mischen.

---

## Risk Template (opt-in, ADR-Pattern)

**Pfad:** `Risks/YYYY-MM-DD Titel.md` — nur wenn `risk_register: enabled` in Governance.

```markdown
---
type: risiko
project: "[[Projektname]]"
status: identifiziert        # identifiziert | mitigiert | akzeptiert | geschlossen
erstellt: YYYY-MM-DD
geschlossen_am: 
likelihood: 3                # 1 (sehr unwahrscheinlich) - 5 (sehr wahrscheinlich)
impact: 4                    # 1 (geringfuegig) - 5 (kritisch)
score: 12                    # likelihood * impact
category: technisch          # technisch | organisatorisch | finanziell | rechtlich | extern
tags: [risiko]
source: claude
chat_url: unbekannt
backlog_issues: []           # IDs der Mitigation-Tasks im Backlog-Tool
---

# Risiko: Titel

## Beschreibung

> Was ist das Risiko? Was passiert wenn es eintritt?

## Eintrittswahrscheinlichkeit

**Likelihood:** {1-5} — Begruendung

## Auswirkung

**Impact:** {1-5} — Begruendung (Kosten, Verzoegerung, Reputation, ...)

## Score

**Score:** {likelihood * impact} — interpretiert:
- 1-4: niedrig (beobachten)
- 5-11: mittel (planen)
- 12-19: hoch (sofort handeln)
- 20-25: kritisch (Eskalation)

## Trigger / Frueh-Indikatoren

> Woran erkennen wir, dass das Risiko eintritt?

## Mitigation

> Wie reduzieren wir Likelihood oder Impact?
> Konkrete Mitigation-Tasks gehen ins Backlog-Tool, hier nur die Strategie.

- ...

## Contingency-Plan

> Was tun wenn das Risiko tatsaechlich eintritt?

## Owner

- Verantwortlich: @...

## Verknuepfungen

- [[Related Decision]]
- [[Related Meeting]]
```

### Score-Interpretation

| Score | Stufe | Aktion |
|-------|-------|--------|
| 1-4 | niedrig | Beobachten, dokumentieren |
| 5-11 | mittel | Mitigation planen |
| 12-19 | **hoch** | Sofort handeln, im Hub anzeigen |
| 20-25 | **kritisch** | Eskalation an Stakeholder |

---

## Financials Template (opt-in)

**Pfad:** `Financials.md` — nur wenn `financials_tool != none` in Governance.

Datei haelt Snapshot + Links auf echtes Tool. Kein vollstaendiges Buchhaltungs-Tool.

```markdown
---
type: financials
project: "[[Projektname]]"
financials_tool: excel
financials_url: "~/Documents/Budget.xlsx"
budget_total: 50000
budget_currency: CHF
budget_period: "2026"
erstellt: YYYY-MM-DD
aktualisiert: YYYY-MM-DD
source: claude
chat_url: unbekannt
---

# Financials — Projektname

> Snapshot und Links auf das echte Finanz-Tool. Vollstaendige Buchhaltung lebt extern.

## Budget-Uebersicht

| Position | Betrag | Bemerkung |
|----------|--------|-----------|
| Gesamtbudget | 50000 CHF | Genehmigt am YYYY-MM-DD |
| Bisher ausgegeben | 0 CHF | Stand: YYYY-MM-DD |
| Verbleibend | 50000 CHF | — |

## Kostenarten (Schaetzung)

| Kategorie | Betrag | Anteil |
|-----------|--------|--------|
| Personal | ... | ... |
| Tools / Lizenzen | ... | ... |
| Hosting / Infra | ... | ... |
| Externe Dienstleister | ... | ... |

## Externe Quellen

- **Echtes Budget:** [Excel-Datei](file://...)
- **Buchhaltung:** [Tool-Name](url)
- **Stripe-Dashboard:** [Link](url)

## Notizen

> Aenderungen, Genehmigungen, Eskalationen.
```

---

## Meeting-Note Template

**Pfad:** `Meetings/[Subordner/]YYYY-MM-DD Thema.md`

```markdown
---
type: meeting
meeting_type: kunde     # kunde | intern | entwicklung
project: "[[Projektname]]"
date: YYYY-MM-DD
attendees:
  - "[[Person 1]]"
  - "[[Person 2]]"
tags: [meeting]
source: claude
chat_url: unbekannt
---

# YYYY-MM-DD -- Meeting-Thema

## Agenda
- 

## Notizen
- 

## Entscheidungen
- 
> Bei groesseren Entscheidungen: eine eigene ADR-Datei in `Decisions/` anlegen und hier verlinken.

## Risiken (wenn besprochen)
- 
> Bei Risk-Tracking aktiv: eigene Datei in `Risks/` anlegen und hier verlinken.

## Action Items
- [ ] Aufgabe 1 @Person
- [ ] Aufgabe 2 @Person

> Action Items werden auf Anfrage ins Backlog-Tool uebertragen (siehe [[Projekt-Governance]]).
> Format nach Uebertragung: `- [ ] Aufgabe 1 @Person → [PROJ-142](url)`
> Wenn Backlog-Tool die Task als done markiert: Checkbox hier abhaken.
```

---

## Frontmatter-Standard

### Hub-Datei

| Feld | Pflicht | Werte |
|------|---------|-------|
| tags | ja | [projekt] |
| status | ja | aktiv / abgeschlossen / pausiert |
| phase | ja | konzeption / umsetzung / abschluss |
| erstellt | ja | YYYY-MM-DD |
| aktualisiert | ja | YYYY-MM-DD |
| source | ja | claude / chatgpt / manuell |
| chat_url | ja | URL oder "unbekannt" |
| governance | ja | [[Projekt-Governance]] |
| language | ja | de / en (Projekt-Sprache aus Onboarding-Frage 0) |
| related | nein | [[Wikilinks]] |

### Projekt-Governance

| Feld | Pflicht | Werte |
|------|---------|-------|
| type | ja | governance |
| project | ja | [[Projektname]] |
| language | ja | de / en |
| backlog_tool | ja | linear / teams-kanban / github-issues / jira / notion / none |
| backlog_url | nein | URL |
| backlog_filter | nein | Linear-Filter / Board-ID |
| backlog_id_prefix | nein | OWL- / PROJ- / ... |
| risk_register | ja | enabled / disabled |
| financials_tool | ja | excel / accounting-tool / stripe / none |
| financials_url | nein | Pfad oder URL |
| pipeline_workflow_id | nein | n8n-Workflow-ID |

### Decision (ADR)

| Feld | Pflicht | Werte |
|------|---------|-------|
| type | ja | entscheidung |
| project | ja | [[Projektname]] |
| status | ja | offen / entschieden / verworfen |
| erstellt | ja | YYYY-MM-DD |
| entschieden_am | nein | YYYY-MM-DD wenn entschieden |
| backlog_issues | nein | Liste IDs |

### Risk (Register)

| Feld | Pflicht | Werte |
|------|---------|-------|
| type | ja | risiko |
| project | ja | [[Projektname]] |
| status | ja | identifiziert / mitigiert / akzeptiert / geschlossen |
| likelihood | ja | 1-5 |
| impact | ja | 1-5 |
| score | ja | likelihood * impact |
| category | ja | technisch / organisatorisch / finanziell / rechtlich / extern |
| backlog_issues | nein | Liste IDs |

### Financials

| Feld | Pflicht | Werte |
|------|---------|-------|
| type | ja | financials |
| project | ja | [[Projektname]] |
| financials_tool | ja | excel / accounting-tool / stripe / none |
| financials_url | nein | Pfad / URL |
| budget_total | nein | Zahl |
| budget_currency | nein | CHF / EUR / USD |
| budget_period | nein | "2026" / "Q2 2026" |

### Meeting-Note

| Feld | Pflicht | Werte |
|------|---------|-------|
| type | ja | meeting |
| meeting_type | ja | kunde / intern / entwicklung |
| project | ja | [[Projektname]] |
| date | ja | YYYY-MM-DD |
| attendees | ja | [[Person]] als Wikilinks |
| tags | ja | [meeting] |

---

## Trigger-Saetze (Was Claude automatisch tut)

### Projekt anlegen
Saetze: "lege ein Projekt an", "neues Projekt", "Projekt anlegen", "erstelle ein Projekt fuer..."

→ ZUERST Onboarding-Dialog (siehe oben). Dann:
- Lege Ordnerstruktur an (Hub + `Projekt-Governance.md` + `Meetings/` + `Decisions/` + `Research/` + `assets/`)
- `Projekt-Governance.md` IMMER anlegen — auch wenn `backlog_tool: none`
- Wenn Onboarding-Antwort 8 = ja → `Risks/` Ordner + Top-Risiken-Block in Hub
- Wenn Onboarding-Antwort 9 != none → `Financials.md` mit Template + Kosten-Verweis in Hub
- Defaults aus Default-Tabelle gemaess Projekt-Typ verwenden wenn Antwort fehlt

Ausnahme: Operator sagt "ohne Fragen" / "Standard" → Onboarding ueberspringen, mit Defaults arbeiten.

### Action Items uebertragen
Saetze: "uebertrag Action Items nach [Tool]", "leg Tasks aus Meeting an"

→ ZUERST `Projekt-Governance.md` lesen. Dann handeln gemaess Workflow-Block in der Governance.

### Decision in User Story uebersetzen
Saetze: "leg User Story aus letzter Decision an", "mach Tasks aus der Entscheidung"

→ ZUERST `Projekt-Governance.md` lesen. Dann Decision pruefen. Tasks anlegen, IDs in `backlog_issues` eintragen.

### Status-Sync
Satz: "sync den Backlog-Status"

→ ZUERST `Projekt-Governance.md` lesen. Backlog-Tool abfragen. Erledigte Action Items abhaken. Geschlossene Decisions markieren.

### Decision anlegen
Saetze: "neue Entscheidung", "leg eine Decision an", "ADR fuer ..."

→ Datei in `Decisions/` mit Template anlegen. Status `offen`. Wenn Kontext aus Meeting: dort verlinken.

### Risk-Tracking aktivieren (opt-in)
Saetze: "aktiviere Risk-Tracking", "leg Risk-Register an", "Risiken tracken fuer dieses Projekt"

→ `Risks/` Ordner anlegen. `risk_register: enabled` in Governance setzen. Top-Risiken-Block in Hub einfuegen. Wenn schon Risiken bekannt: ersten Risk-File anlegen.

### Risiko anlegen
Saetze: "neues Risiko", "leg ein Risiko an", "Risk fuer ..."

→ Voraussetzung: `risk_register: enabled`. Sonst zuerst aktivieren.
Datei in `Risks/` mit Template. Status `identifiziert`. Likelihood/Impact/Score ausfuellen.

### Risk-Mitigations in Backlog
Satz: "leg Mitigations aus Risiko XYZ an"

→ ZUERST Governance lesen. Risk-File pruefen. Mitigation-Liste extrahieren. Tasks im Backlog-Tool anlegen, IDs in `backlog_issues` der Risk-Datei.

### Financials-Tracking aktivieren (opt-in)
Saetze: "aktiviere Financials", "leg Budget-Tracking an", "Financials fuer dieses Projekt"

→ `Financials.md` mit Template anlegen. `financials_tool` und `financials_url` in Governance setzen. Kosten-Verweis in Hub.

---

## Pflicht-Regel: Governance-First

Bei JEDER Backlog-/Risk-/Financials-bezogenen Aktion (anlegen, uebertragen, syncen, abfragen) liest Claude IMMER ZUERST `Projekt-Governance.md` des betreffenden Projekts. Nie raten, nie improvisieren. Wenn die Datei fehlt → einmal nachfragen, anlegen, dann handeln.

---

## Herkunft

- **Dann Berg Meeting Note Template** -- Meeting-Struktur
- **PARA Starter Kit** -- Hub-Datei-Prinzip
- **ADR-Pattern** (Michael Nygard, 2011) -- Decisions als eigene Files
- **PMI / PRINCE2 Risk Register** -- Risk-Template (Likelihood x Impact, Score-Interpretation)
- **OpenCLAW Governance** (vibercoder79/KI-Masterclass-Koerting) -- Governance-File-Prinzip, Onboarding-Phase 0
- Bestehende Vault-Muster
