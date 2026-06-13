# Synthesize Skill — SecondBrain Verdichtung

Verdichtet Notizen eines Themen-Clusters im SecondBrain Obsidian Vault zu einer Synthese-Seite oder einem MOC (Map of Content). Hebt Roh-Material aus der Roh-Schicht in die kuratierte Schicht. Quartalsweise Nutzung.

> Workflow-Diagramm: [`synthesize-overview.png`](synthesize-overview.png) (Quelle: [`synthesize-overview.excalidraw`](synthesize-overview.excalidraw)).

## Version

**v1.0.0** (Juni 2026) — Initial release

## Installation

```bash
cp -r ~/Documents/GitHub/claudecodeskills/synthesize ~/.claude/skills/synthesize
```

Pruefen ob es funktioniert:

```
/synthesize
```

## Nutzung

| Aufruf | Verhalten |
|--------|-----------|
| `/synthesize cluster:"04 Ressourcen/KI"` | Synthese fuer den Ordner-Cluster |
| `/synthesize tag:#thema` | Synthese fuer alle Notizen mit diesem Tag |
| `/synthesize "Pfad/zum/Ordner"` | Synthese fuer einen Ordnerpfad |
| `/synthesize` | Per Rueckfrage Cluster waehlen |

Weitere Ausloeser: `synthesize`, `verdichte das wissen`, `synthese fuer`, `MOC fuer`, `map of content fuer`, `fasse das cluster zusammen`.

## Was der Skill tut (6 Schritte)

### 1. Cluster waehlen

Argument auswerten (Ordnerpfad, Tag oder bestehender MOC). Ohne Argument: Rueckfrage mit drei Optionen. Cluster-Groesse melden, ab 30 Notizen Hinweis auf moegliche Unterteilung.

### 2. Notizen sammeln

Alle Markdown-Dateien aus dem Cluster vollstaendig lesen (ausser `07 Anhaenge/`). Frontmatter, Kernaussagen und Entitaeten erfassen.

### 3. Analyse

- Kernaussagen pro Notiz extrahieren
- Themen-Cluster bilden (Sub-Themen)
- Widersprueche zwischen Notizen markieren (mit Quellen-Verweis)
- Luecken benennen (was waere noch zu beantworten)
- Schwach belegte Aussagen markieren (nur eine Quelle)

### 4. Vorschlag erstellen

Wahl zwischen Synthese-Notiz (fokussierter Cluster) und MOC (breiter Cluster mit Sub-Themen). Default-Empfehlung: ab 4 Sub-Themen MOC, sonst Synthese. Pflicht-Frontmatter `layer: curated`, `date`, `source`, `chat_url`, `related`.

### 5. Preview und Bestaetigung

Kompletter Markdown-Output wird im Chat gezeigt, Ziel-Pfad sichtbar. Nutzer waehlt: schreiben, anpassen, verwerfen. **Kein Auto-Write.**

### 6. Schreiben, verlinken, loggen

Datei wird geschrieben. Pro Quell-Notiz Rueckverlink unter `## Verwandte Notizen` ergaenzt (idempotent). Log-Eintrag in `log.md` (append-only).

## Hintergrund: Warum dieser Skill?

### Das Problem

Die Roh-Schicht im Vault (Inbox, Daily Notes, KI-Outputs) waechst schnell. Ohne Verdichtung bleibt das Wissen verteilt: viele kleine Notizen, keine kuratierte Antwort auf "Was wissen wir eigentlich ueber X?".

### Die Loesung

Zwei-Schichten-Architektur. Die Roh-Schicht sammelt, die kuratierte Schicht (MOCs, Synthesen, ADRs, 00 Kontext) destilliert. `/synthesize` ist der kuratorische Schritt: aus vielen Notizen wird eine verbindliche Seite, mit Quellenangaben, Widerspruechen und Luecken sichtbar.

### Abgrenzung zu Schwester-Skills

| Skill | Zweck | Granularitaet |
|-------|-------|---------------|
| `/ingest` | Verlinkt einzelne Notiz ins Vault | Eine Notiz |
| `/lint` | Hygiene und Compliance | Ganzes Vault |
| `/synthesize` | Verdichtet Cluster zu MOC oder Synthese | Themen-Cluster |
| `/decay` | Markiert veraltete Inhalte | Ganzes Vault |
| `/prune` | Schlaegt Loeschungen vor | Ganzes Vault |

### Rhythmus

Quartalsweise pro aktivem Themen-Cluster. Trigger: Lint-Reports (volle Inbox, viele Daily-Note-Eintraege im gleichen Tag-Bereich) oder expliziter Nutzer-Wunsch.

## Regeln

1. **KEIN Auto-Write** — Datei wird erst nach Bestaetigung geschrieben
2. **KEIN Auto-Delete** — Quell-Notizen werden nur ergaenzt
3. **NIE duplizieren** — Rueckverlinkungen pruefen vor dem Setzen
4. **Quell-Treue** — jede Aussage zeigt auf eine Quelle
5. **Widersprueche bleiben sichtbar** — werden nicht aufgeloest
6. **07 Anhaenge/ ignorieren**
7. **Log ist append-only**
8. **Sprache: Deutsch** (Schweizer Hochdeutsch, ss statt ß)

## Quellen

- Standortbestimmung: `SecondBrain/04 Ressourcen/Wissensmanagement/2026-06-13 Kuratierung im KI-Zeitalter.md`
- Komplementaere Skills: [`ingest`](../ingest/), [`lint`](../lint/), [`decay`](../decay/), [`prune`](../prune/)
- Pattern-Inspiration: Andy Matuschak (Evergreen Notes), Nick Milo (MOCs)

## Dateistruktur

```
synthesize/
├── SKILL.md                          <- Skill-Logik DE (Workflow, Regeln, Templates)
├── SKILL.en.md                       <- Skill-Logik EN (Kurzfassung)
├── README.md                         <- Diese Datei (DE)
├── README.en.md                      <- README EN
├── synthesize-overview.excalidraw    <- Big Picture DE (Quelle)
├── synthesize-overview.png           <- DE Render
├── synthesize-overview.en.excalidraw <- Big Picture EN (Quelle)
└── synthesize-overview.en.png        <- EN Render
```

## Versionshistorie

| Version | Datum | Aenderungen |
|---------|-------|-------------|
| 1.0.0 | 2026-06-13 | Initial release: 6-Schritte-Workflow, Synthese und MOC, zweisprachig |
