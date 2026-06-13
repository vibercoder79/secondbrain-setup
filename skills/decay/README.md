# Decay Skill — SecondBrain Freshness-Check

Findet alte Notizen im SecondBrain, prueft pruefbare Aussagen gegen die aktuelle Realitaet (Web-Suche, Doku-Updates) und markiert den `freshness`-Status in der Frontmatter. Schreibt einen monatlichen Decay-Report ins Vault-Gesundheit-Verzeichnis.

**Der Kern:** Wissen altert. `/lint` prueft Struktur, `/ingest` vernetzt einzelne Notizen — `/decay` prueft Wahrheitsgehalt ueber Zeit. Notizen bleiben unangetastet im Inhalt, nur die Frontmatter wird ergaenzt. Mitigation bleibt bewusst beim Nutzer.

> Workflow-Diagramm: [`decay-overview.excalidraw`](decay-overview.excalidraw) | [`decay-overview.png`](decay-overview.png) — gerendert via `~/.claude/skills/excalidraw-diagram/references/render_excalidraw.py`.

## Version

**v1.0.1** (Juni 2026) — siehe [Versionshistorie](#versionshistorie)

## Installation

```bash
cp -r ~/Documents/GitHub/claudecodeskills/decay ~/.claude/skills/decay
```

Pruefen ob es funktioniert:

```
/decay
```

## Nutzung

| Aufruf | Verhalten |
|--------|-----------|
| `/decay` | Vollstaendiger Check mit Defaults (6 Monate, `04 Ressourcen`) |
| `/decay older-than:12m` | Schwelle anpassen (m=Monate, y=Jahre) |
| `/decay folder:"03 Bereiche"` | Anderen Scope-Ordner waehlen |
| `/decay older-than:3m folder:"02 Projekte"` | Kombinierbare Argumente |
| `/decay note:"Notizname"` | Einzelne Notiz pruefen, unabhaengig vom Alter |
| `/decay scan-only` | Scan-Modus: nur Scan-Report schreiben, keine Frontmatter-Aenderungen, autonom (kein Confirmation-Dialog). Kombinierbar mit `older-than:` und `folder:`. |

Weitere Ausloeser: `decay`, `decay check`, `ist das noch aktuell`, `pruefe alte notizen`, `freshness check`, `wissens-altern`.

## Modi

| Modus | Ausloesung | Wirkung | Routine-tauglich |
|-------|------------|---------|------------------|
| Voll-Modus (Default) | manuell | scannt, validiert, schreibt Frontmatter mit Confirmation, Report | nein (interaktiv) |
| Scan-Modus (`scan-only`) | manuell oder Routine | scannt, validiert, schreibt nur Scan-Report, kein Frontmatter | ja (autonom) |

**Rollenteilung:** Der Scan-Modus ist der Sensor — er laeuft autonom in Routinen (Scheduled Agents), liefert einen Scan-Report und schreibt nichts in die Quell-Notizen. Der Voll-Modus ist die Aktion — er wird manuell ausgeloest, nachdem der Nutzer einen Scan-Report gesichtet hat, und schreibt die Klassifikation in die Frontmatter.

### Beispiele

`/decay`
- Voll-Modus, Defaults (6 Monate, `04 Ressourcen`)
- Output: Preview-Tabelle, Confirmation-Dialog, Frontmatter-Updates in Quell-Notizen, Report `YYYY-MM-DD Decay Report.md`, Log-Eintrag mit Praefix `decay`

`/decay scan-only`
- Scan-Modus, Defaults (6 Monate, `04 Ressourcen`)
- Output: nur Scan-Report `YYYY-MM-DD Decay Scan.md`, Log-Eintrag mit Praefix `decay-scan`. Keine Aenderungen an Quell-Notizen, keine Rueckfragen. Geeignet als Sensor in Scheduled Agents.

`/decay scan-only older-than:12m folder:"03 Bereiche"`
- Scan-Modus mit angepasstem Scope (12 Monate, Bereiche)
- Output: wie oben, nur breiter

## Was der Skill tut (8 Schritte)

### 1. Scope waehlen

Argumente parsen, Defaults setzen (6 Monate, `04 Ressourcen`). Hard-Excludes: `05 Daily Notes/`, `06 Archiv/`, `07 Anhaenge/`, `01 Inbox/`, `00 Kontext/`.

### 2. Kandidaten finden

Glob im Scope, Alter aus `aktualisiert` -> `date` -> `stat` (mtime). Bereits in den letzten 30 Tagen geprueft -> ueberspringen.

### 3. Pruefbare Aussagen extrahieren

Versionen, Tool-Namen, Standards, URLs, Verfuegbarkeitsaussagen, Zahlen mit Quelle. Keine Reflexionen, keine konzeptionellen Argumente.

### 4. Web-Validierung

Pro Notiz maximal 3 Calls. WebSearch zuerst, WebFetch nur fuer konkrete Doku-URLs. Bundeln ueber Notizen hinweg.

Klassifikation: `gueltig`, `ueberpruefen` (Indizien), `veraltet` (klare Belege).

### 5. Preview und Bestaetigung

Gruppierte Tabelle, dann AskUserQuestion: alle uebernehmen, einzeln durchgehen, oder abbrechen.

### 6. Frontmatter schreiben

Edit-Operation, keine bestehenden Felder ueberschrieben:

```yaml
freshness: gueltig | ueberpruefen | veraltet
decay_checked_at: 2026-06-13
decay_notes: kurze Begruendung wenn noetig
```

### 7. Decay-Report

Bericht in `03 Bereiche/Vault-Gesundheit/`. Dateiname haengt vom Modus ab:

- Voll-Modus: `YYYY-MM-DD Decay Report.md`
- Scan-Modus: `YYYY-MM-DD Decay Scan.md`

Aufbau in beiden Faellen identisch: Zusammenfassung, Klassifikations-Listen, Mitigations-Vorschlag pro veralteter Notiz.

### 8. Log-Eintrag

Append-only in `log.md`. Praefix `decay` im Voll-Modus, `decay-scan` im Scan-Modus.

## Hintergrund: Warum dieser Skill?

### Das Problem

Im SecondBrain liegen Notizen zu Tools, Versionen, Standards und Doku-URLs. Diese altern. Eine Notiz ueber "Claude Sonnet 4.5" oder "OWASP Top 10:2025" ist nach einem halben Jahr potenziell ueberholt. Ohne Markierung weiss der Nutzer (oder die naechste KI-Session) nicht, ob ein Eintrag noch belastbar ist.

### Die Loesung

`decay` markiert. Nicht mehr, nicht weniger. Drei Status reichen:

- `gueltig` — Aussagen sind noch aktuell (oder es gibt keine pruefbaren)
- `ueberpruefen` — Indizien sprechen fuer Veraltung, aber kein klarer Beweis
- `veraltet` — klare Belege, dass die Aussagen nicht mehr stimmen

Was mit veralteten Notizen passiert, entscheidet der Nutzer: aktualisieren, archivieren, oder bewusst stehen lassen. Der Skill loescht nichts und korrigiert keinen Inhalt.

### Warum keine automatische Korrektur?

Faktenkorrektur ist eine inhaltliche Entscheidung. Der Skill kann erkennen, dass eine URL 404 zurueckgibt, aber nicht, welcher Nachfolger der richtige ist. Mitigation bleibt beim Nutzer.

### Warum Web-Calls bundeln?

Web-Validierung ist teuer und schwer reproduzierbar. Wenn fuenf Notizen alle "Claude Sonnet 4.5" erwaehnen, reicht eine WebSearch. Der Skill cachet das Ergebnis fuer die laufende Session.

## Komplementaere Skills

| Skill | Zweck |
|-------|-------|
| [`lint`](../lint/) | Vault-Struktur, Orphans, Compliance, Index-Cover |
| [`ingest`](../ingest/) | Einzelnotizen vernetzen, bidirektionale Wikilinks |
| `decay` | Freshness ueber Zeit, Web-Validierung |

Die drei Skills ergeben zusammen das Kuratierungs-Set fuer das SecondBrain.

## Regeln

1. **IMMER Preview vor Schreiben im Voll-Modus** — Frontmatter wird nie ohne Bestaetigung gesetzt
2. **Scan-Modus schreibt nie in Quell-Notizen** — nur Scan-Report und Log-Eintrag
3. **NIE Inhalt aendern** — Decay markiert nur
4. **NIE loeschen oder archivieren** — Mitigation ist Vorschlag
5. **Web-Calls sparsam** — pro Notiz max 3, ueber Notizen hinweg bundeln
6. **Hard-Excludes respektieren** — Daily Notes, Archiv, Inbox, Kontext, Anhaenge nie pruefen
7. **Begruendung Pflicht** bei `ueberpruefen` und `veraltet` (Voll-Modus)
8. **Log append-only** — bestehende Eintraege nie aendern; Praefix `decay` im Voll-Modus, `decay-scan` im Scan-Modus
9. **Sprache: Deutsch** — Ausgaben und Report-Texte auf Deutsch

## Dateistruktur

```
decay/
├── SKILL.md                       <- Skill-Logik DE (Workflow, Regeln)
├── SKILL.en.md                    <- Skill-Logik EN (Kurzfassung)
├── README.md                      <- Diese Datei
├── README.en.md                   <- Englische Fassung
├── decay-overview.excalidraw      <- Workflow-Diagramm DE (Excalidraw-Quelle)
├── decay-overview.png             <- Workflow-Diagramm DE (gerendert)
├── decay-overview.en.excalidraw   <- Workflow-Diagramm EN (Excalidraw-Quelle)
└── decay-overview.en.png          <- Workflow-Diagramm EN (gerendert)
```

## Quellen

- Standortbestimmung: `SecondBrain/04 Ressourcen/Wissensmanagement/2026-06-13 Kuratierung im KI-Zeitalter.md`
- Schwester-Skills: [`lint`](../lint/), [`ingest`](../ingest/)
- Karpathy LLM Wiki Pattern (Vorverarbeitung statt Echtzeit-Suche) — Basis fuer `Index.md` in `/lint`, hier indirekt: Decay-Marker als vorverarbeitete Wahrheitsannotation

## Versionshistorie

| Version | Datum | Aenderungen |
|---------|-------|-------------|
| 1.0.1 | 2026-06-13 | Scan-Modus eingefuehrt fuer Routine-Auslosung (autonom, kein Frontmatter-Write) |
| 1.0.0 | 2026-06-13 | Initial release: 8-Schritte-Workflow mit Web-Validierung, Frontmatter-Markierung, Report in Vault-Gesundheit/ |
