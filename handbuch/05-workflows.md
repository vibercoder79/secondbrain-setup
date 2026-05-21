# 05 — Workflows: Wie du das Vault im Alltag nutzt

> Kurzfassung: Sieben wiederkehrende Workflows. Session-Start liest die Index.md.
> Daily Notes sind das Tageslogbuch. Projekt-Anlage folgt einem 9-Fragen-Onboarding.
> Deep Research kennt zwei Muster. /ingest verarbeitet neue Notizen. /lint pruefte
> das Vault. Session-Ende archiviert.

## Workflow 1: Session-Start

Wenn du eine neue KI-Session startest, machst du **nichts manuell** — die KI tut
es. Aus der Vault-CLAUDE.md:

> ### Bei Session-Start
> 1. Lies `Index.md` im Vault-Root als **Vault-Cover** (vom `/lint` regeneriert).
> 2. Pruefe `01 Inbox/` auf neue Notizen, zeige was drin liegt.

Die KI liest beim Start die `Index.md` — eine vorkompilierte Uebersicht aktiver
Projekte, Bereiche, Synthese-Seiten, letzter Daily Notes, Vault-Statistik. Das spart
Tokens und Zeit gegenueber Glob-Scans oder Volltextsuche. Das Pattern stammt von
[Karpathys LLM-Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).

Beispiel-Inhalt einer `Index.md`:

```markdown
# SecondBrain Index

## Aktive Projekte (`02 Projekte/`)

- [[Beispiel-Projekt - PMO HUB]] — `aktiv` | umsetzung | 2026-05-19
- [[Mein-Newsletter - PMO HUB]] — `aktiv` | konzeption | 2026-05-18
...

## Bereiche (`03 Bereiche/`)

- [[Skills]]
- [[Lifelong Learning]]
...

## Synthese-Seiten (`04 Ressourcen/`)

- [[Claude Code]] — Synthese aller Claude-Code-Notizen
- [[Gemini]]
...

## Vault-Statistik

- Notizen gesamt: 1247
- Aktive Projekte: 15
- Inbox-Stand: 2
```

Die `Index.md` wird vom `/lint`-Skill regeneriert (Schritt 6) — manuelle Aenderungen
gehen verloren.

## Workflow 2: Daily Notes — SSoT fuer Tagesaktivitaeten

Eine Datei pro Tag, benannt `YYYY-MM-DD.md`. Die KI bietet beim Session-Ende an,
einen Eintrag zu erstellen oder den heutigen zu ergaenzen.

### Schreib-Regeln

1. **Ein File pro Tag** — `05 Daily Notes/YYYY-MM-DD.md`
2. **Projekt-Sektionen** — pro Projekt/Thema eine H2-Sektion mit Tag:
   `## Mein-Projekt #mein-projekt-tag`
3. **Tags im Frontmatter** — pro beruehrtem Projekt ein Tag (plus `daily`)
4. **Wikilink zum Hub** — `> [!info] Via Claude — [[Mein-Projekt - PMO HUB]]`
5. **Inhalt pro Sektion** — was gemacht, Entscheidungen (mit Wikilinks), offene Punkte

### Projekt-Hub zieht via Dataview

Jeder Projekt-Hub hat eine Sektion `## Tagesaktivitaeten`:

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

Der Hub zeigt automatisch die letzten 30 Tage Aktivitaet — du pflegst die Daily
Note, der Hub aktualisiert sich von selbst. Keine doppelte Pflege.

### SSoT-Regeln (was wird WO geschrieben)

| Datenart | SSoT (schreiben) | Wo sichtbar |
| -------- | ---------------- | ----------- |
| Tagesaktivitaeten | `05 Daily Notes/YYYY-MM-DD.md` | Projekt-Hub §Tagesaktivitaeten (Dataview) |
| Entscheidungen | `02 Projekte/<projekt>/Decisions/ADR-XX.md` | Hub §ADRs (Index-Tabelle) |
| Meetings | `02 Projekte/<projekt>/Meetings/YYYY-MM-DD.md` | Hub §Meetings (Dataview oder Wikilinks) |
| Research | `02 Projekte/<projekt>/Research/*.md` | Hub §Research (manuelle Verweise) |

**Regel:** Schreiben im SSoT, Hub zeigt nur. Wenn Inhalt an mehreren Stellen
stehen muss → Wikilink statt Copy-Paste.

## Workflow 3: Projekt anlegen — 9-Fragen-Onboarding

Wenn du ein neues Projekt startest, sagst du der KI:

> "Lege ein Projekt fuer Web-Redesign an."

Die KI stellt **10 Fragen** in einem Block (alle auf einmal, nicht einzeln):

```
0. Projekt-Sprache?           (a) Deutsch / (b) Englisch
1. Projektname?
2. Ein-Satz-Beschreibung?
3. Konkretes Ziel?
4. Projekt-Typ?               (Software / Beratung / Marketing / Persoenlich / Anderes)
5. Stakeholder / Kunde?
6. Backlog-Tool?              (Linear / Teams-Kanban / GitHub / none)
7. GitHub-Repo-URL?           (optional)
8. Risk-Tracking aktivieren?  (default: nein)
9. Financials-Tracking?       (default: nein)
```

Nach den Antworten:

- **Ordner** wird angelegt: `02 Projekte/Web-Redesign/`
- **Pflicht-Dateien:** `Web-Redesign - PMO HUB.md` + `Projekt-Governance.md`
- **Subordner:** `Meetings/`, `Decisions/`, `Research/`, `assets/`
- **Opt-in:** `Risks/` (wenn Antwort 8 = ja), `Financials.md` (wenn Antwort 9 != none)
- **Backlog-Tool:** wenn Linear/Teams → MCP-Discovery, Auto-Create mit Bestaetigung;
  wenn GitHub → `gh` CLI; wenn none → "Pre-Backlog Action Items"-Sektion im Hub
- **Verifikation:** Whitelist-Check (kein `README.md` im Projektwurzel), Wikilinks valide,
  Dataview-Syntax ok

Die komplette Methodik liegt in `00 Kontext/Workflows/Projekt-Anlegen.md` —
KI-agnostisch, von allen KIs lesbar. Claude Code automatisiert das via `/projekt-init`,
Gemini und Codex fahren es manuell durch (gleiche Fragen, gleiches Ergebnis).

### Schnell-Modus

Wenn du "Standard" oder "ohne Fragen" sagst, ueberspringt die KI das Onboarding und
nutzt Defaults aus der Methodik-Datei. Nur den Projektnamen erfragt sie.

### Projekt-Hub-Anatomie

Ein typischer `<Projekt> - PMO HUB.md`:

```markdown
---
tags: [projekt]
status: aktiv
phase: konzeption
erstellt: 2026-05-21
aktualisiert: 2026-05-21
source: claude
chat_url: https://claude.ai/chat/...
governance: "[[Projekt-Governance]]"
---

# Web-Redesign

> Ein-Satz-Beschreibung des Projekts.

## Projektziel
Konkretes Ziel...

## Stack
(nur wenn Software-Projekt)

## Tagesaktivitaeten
(Dataview-Query, automatisch gefuellt)

## Offene Entscheidungen
(Dataview-Query auf Decisions/ mit status: offen)

## Letzte Entscheidungen
(Dataview-Query auf Decisions/ mit status: entschieden, LIMIT 5)

## Backlog
Link zum Backlog-Tool oder "Pre-Backlog Action Items"
```

Der Hub ist die **Landing Page** des Projekts. Wer das Projekt verstehen will,
liest den Hub.

## Workflow 4: Deep Research ablegen

Wenn du eine ausfuehrliche Recherche machst (Perplexity, ChatGPT Deep Research,
Gemini Long Context etc.), gibt es zwei Ablage-Muster.

### Einfache Research — eine Datei

Direkt als Einzeldatei in `04 Ressourcen/Research/`:

```
2026-05-21 KI Markt Europa Vergleich.md
```

Frontmatter mit `source:`, `chat_url:`, `tags:`. Fertig.

### Komplexe Research — ein Ordner

Wenn mehrere zusammenhaengende Dokumente oder Grafiken anfallen:

```
2026-05-21 NIST CSF Tier 3 Analyse/
├── README.md                  ← Einstiegs-Zusammenfassung mit Wikilinks
├── 01-Dokument-Name.md        ← Original-Dokument 1 (vollstaendig)
├── 02-Dokument-Name.md        ← Original-Dokument 2 (vollstaendig)
├── 03-Synthese.md             ← Eigene Synthese
└── assets/
    └── grafik.svg
```

Regeln:

- `README.md` ist der Einstieg
- Alle Original-Artefakte **vollstaendig** ablegen — nicht paraphrasieren
- Grafiken nach `assets/`, eingebettet via `![[grafik.svg]]`
- Unter-Dokumente nutzen `parent: "[[README]]"` im Frontmatter
- Dateinamen mit Praefix-Nummern (`01-`, `02-`) fuer Lesereihenfolge

**Trigger-Saetze** fuer das Komplex-Muster:

- "archiviere das komplett"
- "leg das als Research-Paket ab"
- "speicher das vollstaendig mit allen Dokumenten"

## Workflow 5: Ingest — Notizen verarbeiten und vernetzen

Nach einer Research-Session oder nach dem Anlegen einer wichtigen Notiz:

```
/ingest "Notiz XY"
```

Was passiert:

1. **Vault durchsuchen** — was haengt thematisch zusammen?
2. **Wikilinks setzen** — bidirektional (in der neuen Notiz UND in bestehenden)
3. **Synthese-Seite aktualisieren** — die `04 Ressourcen/<Thema>/<Thema>.md`
   Start-Datei bekommt einen neuen Absatz mit Verweis auf die neue Notiz
4. **log.md aktualisieren** — Chronologie-Eintrag

Das ist der **Compound-Effekt** in Aktion. Statt dass Wissen isoliert in Einzel-
Notizen liegt, vernetzen sie sich. Die Synthese-Seite (`04 Ressourcen/Claude Code/Claude Code.md`)
wird mit jeder neuen Notiz reicher — sie ist Karpathys "lebendiges Wiki".

**Wichtig:** Ingest ist **manuell**, kein Hook. Du entscheidest wann es passiert.
Ein Hook auf jeden Edit waere zu teuer (Tokens) und zu laut (Rauschen).

Details: `skills/ingest/SKILL.md`.

## Workflow 6: Lint — Vault-Health-Check

Woechentlich (oder bei Bedarf) das ganze Vault pruefen:

```
/lint
```

Sechs Schritte:

1. **Verwaiste Notizen finden** — Notizen ohne eingehende Wikilinks
2. **Fehlende Verknuepfungen vorschlagen** — Themen-Matching, einzeln bestaetigen
3. **Vault-Hygiene** — Inbox-Stand, Frontmatter-Check, Synthese-Seiten-Check
4. **Projekt-Compliance** — Whitelist, Pflicht-Dateien, Naming, kaputte Wikilinks,
   Decisions-Konsistenz, Pre-Backlog-Drift
5. **Report erstellen** — `01 Inbox/YYYY-MM-DD Vault Lint Report.md`, Log-Eintrag
6. **Index.md regenerieren** — Vault-Cover (siehe Workflow 1)

`/lint` aendert **nie automatisch**. Pro Finding wird einzeln gefragt: "Soll ich
das korrigieren?"

Teilmodi (wenn nur ein Aspekt geprueft werden soll):

- `/lint orphans` — nur Schritt 1
- `/lint inbox` — nur Inbox-Teil von Schritt 3
- `/lint projekte` — nur Schritt 4
- `/lint index` — nur Schritt 6

Details: `skills/lint/SKILL.md`.

## Workflow 7: Session-Ende

Wenn die KI merkt dass eine Session zu Ende geht oder du beendest:

1. **Daily Note erstellen oder ergaenzen** — Sektion fuer das heutige Projekt
   mit "Was wurde gemacht", "Entscheidungen", "Offen"
2. **Neue Erkenntnisse speichern** — falls etwas Wertvolles in der Session
   entstanden ist, das nicht in der Daily Note Platz hat: eigene Notiz im
   passenden Ordner (`02 Projekte/<projekt>/` oder `04 Ressourcen/<thema>/`)
3. **Chat-Verlauf archivieren** (optional) — KI-spezifisch:
   - Gemini: in `04 Ressourcen/Gemini/`
   - Codex: in `04 Ressourcen/Codex - OpenAI/`
   - Claude (Code/Desktop): meist nicht noetig, weil Claude-eigene History laeuft
4. **Inbox aufraeumen** falls noetig

## Zusammenspiel: typischer Tag

```
Morgens
└── Claude Code Session
    ├── Index.md gelesen, weiss was aktiv ist
    ├── Inbox 2 Notizen → einsortiert
    ├── Arbeit am Projekt: ADR-04 entschieden, in Decisions/
    └── Session-Ende: Daily-Note-Eintrag fuer heute

Mittags
└── Perplexity-Research im Browser
    └── Web Clipper → 04 Ressourcen/Research/2026-05-21 Thema X.md

Nachmittags
└── Claude Code Session
    ├── /ingest "2026-05-21 Thema X" → vernetzt mit bestehendem Wissen
    ├── Daily Note ergaenzt
    └── Session-Ende

Freitags
└── /lint
    ├── 3 Orphans gefunden, 2 verlinkt
    ├── 1 Projekt mit Compliance-Drift gefixt
    └── Index.md regeneriert
```

## Naechstes Kapitel

→ [06 — Skills: projekt-init, lint, ingest im Detail](06-skills.md)
