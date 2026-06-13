# Prune Skill — Aktive Reduktion im SecondBrain

`/prune` findet Loesch-Kandidaten im SecondBrain Obsidian Vault und schlaegt Loeschung
oder Archivierung vor. Quartalsweise Nutzung. Strikt mit Einzel-Confirmation, kein
Auto-Delete.

Teil des Kuratierungs-Patterns mit `/lint` (Diagnose), `/synthesize` (Verdichtung),
`/decay` (Frische-Markierung) und `/prune` (Reduktion).

> Workflow-Diagramm: [`prune-overview.excalidraw`](prune-overview.excalidraw) — PNG-Render
> wird in einem Folge-Patch nachgezogen.

## Version

**v1.0.1** (Juni 2026) — Scan-Modus eingefuehrt fuer Routine-Auslosung.

## Installation

```bash
cp -r ~/Documents/GitHub/claudecodeskills/prune ~/.claude/skills/prune
```

Pruefen:

```
/prune
```

## Nutzung

| Aufruf | Verhalten |
|--------|-----------|
| `/prune` | Voller Lauf, alle vier Kategorien |
| `/prune duplikate` | Nur Duplikate |
| `/prune orphans` | Nur persistente Orphans (drei Lint-Laeufe) |
| `/prune inbox` | Nur alte Brain Dumps in `01 Inbox/` |
| `/prune veraltet` | Nur `freshness: veraltet` Notizen |
| `/prune scan-only` | Scan-Modus, schreibt nur Vorschlagsliste, keine Aktionen |
| `/prune scan-only category:duplicates` | Scan-Modus, nur Duplikate |
| `/prune scan-only category:orphans` | Scan-Modus, nur Orphans |
| `/prune scan-only category:brain-dumps` | Scan-Modus, nur alte Brain Dumps |
| `/prune scan-only category:decayed` | Scan-Modus, nur veraltete Notizen |

Weitere Ausloeser: `loesch-vorschlaege`, `vault entruempeln`, `aussortieren`,
`duplikate finden`, `alte orphans aufraeumen`.

## Modi

| Modus | Auslosung | Wirkung | Routine-tauglich |
|-------|-----------|---------|------------------|
| Voll-Modus (Default) | manuell | Einzel-Confirmation, echte Loeschungen und Archivierungen | nein (interaktiv) |
| Scan-Modus (`scan-only`) | manuell oder Routine | Vorschlagsliste als Scan-Report, KEINE Aktionen | ja (autonom) |

Scan ist der Sensor, der Voll-Lauf bleibt strikt manuell. Loeschungen und
Archivierungen duerfen niemals automatisierbar sein. Der Scan-Modus liefert nur
das Bild, die Entscheidung trifft immer der Nutzer im Voll-Lauf.

### Beispiel: Scan-Lauf

```
/prune scan-only
```

Sample-Output (gekuerzt):

```markdown
# Prune Scan — 2026-06-13

- Lauf-Datum: 2026-06-13
- Scope: alle
- Gesamtzahl Kandidaten: 12

## Duplikate

| Pfad A | Pfad B | Aehnlichkeit | Begruendung | Empfehlung |
|--------|--------|--------------|-------------|------------|
| 04 Ressourcen/.../Setup Web Clipper.md | 01 Inbox/Setup Web Clipper.md | 0.82 | juenger, weniger Backlinks | loeschen |

## Alte Brain Dumps

| Pfad | Begruendung | Empfehlung |
|------|-------------|------------|
| 01 Inbox/Gedanke RAG vs. Wiki.md | 13 Monate, keine Backlinks | archivieren |

---

Folge-Schritt: `/prune` manuell starten und Einzel-Confirmation durchgehen.
```

Es werden keine Dateien geloescht oder verschoben. Der Scan-Report liegt unter
`03 Bereiche/Vault-Gesundheit/YYYY-MM-DD Prune Scan.md`.

## Kategorien

### 1. Duplikate

Title-Match plus Inhalts-Aehnlichkeit (Bigramm-Jaccard, Schwelle >= 0.6) ueber
[`scripts/find_duplicates.py`](scripts/find_duplicates.py). Empfehlung pro Paar:
juengere Kopie mit weniger Backlinks loeschen.

### 2. Persistente Orphans

Schnittmenge der letzten drei Lint-Reports aus `03 Bereiche/Vault-Gesundheit/` plus
Live-Gegencheck via Grep. Empfehlung: archivieren wenn > 200 Worte, sonst loeschen.

### 3. Alte Brain Dumps

`01 Inbox/`-Dateien aelter als 12 Monate ohne Backlinks. Empfehlung: loeschen bei
< 100 Worten und ohne Frontmatter, sonst archivieren.

### 4. Veraltete Notizen

Notizen mit `freshness: veraltet` im Frontmatter, deren letztes Update > 90 Tage
zurueckliegt. Empfehlung: immer archivieren.

## Sicherheits-Defaults

1. **Kein Auto-Delete.** Jede Aktion wird einzeln per AskUserQuestion bestaetigt.
2. **Backup vor erstem Lauf empfohlen.** Wenn das Vault unter Git steht:

   ```bash
   cd /Users/tobiasschmidt/Obsidian/SecondBrain && \
     git add -A && git commit -m "pre-prune backup $(date +%F)"
   ```

   Sonst:

   ```bash
   tar -czf ~/Desktop/SecondBrain-backup-$(date +%F).tar.gz \
     -C /Users/tobiasschmidt/Obsidian SecondBrain
   ```

3. **Bei Unsicherheit: archivieren statt loeschen.**
4. **Schutzzonen:** `00 Kontext/`, `CLAUDE.md`, `log.md`, `Index.md`,
   `03 Bereiche/Skills/`, `07 Anhaenge/`, Daily Notes.
5. **Scan-Modus ist die einzige autonomisierbare Variante.** Loeschung und
   Archivierung bleiben strikt interaktiv. Eine Routine darf `/prune scan-only`
   ausfuehren, niemals `/prune`. Damit ist sichergestellt, dass kein Routine-Lauf
   jemals Dateien anfassen kann.

## Workflow

1. Scope und Kategorien waehlen
2. Kandidaten pro Kategorie sammeln
3. Vorschlagsliste mit Begruendung anzeigen
4. Einzel-Confirmation per AskUserQuestion (loeschen / archivieren / behalten / ueberspringen)
5. Aktionen ausfuehren (`rm` oder `mv` nach `06 Archiv/`)
6. Prune-Log in `03 Bereiche/Vault-Gesundheit/YYYY-MM-DD Prune Log.md`
7. Append-Eintrag in `log.md`

## Hintergrund

### Das Problem

Lint markiert Drift, Decay markiert Frische, Synthesize verdichtet. Aber niemand
loescht. Das Vault waechst monoton: alte Brain Dumps, doppelte Notizen, persistente
Orphans bleiben liegen. Signal-Rausch-Verhaeltnis sinkt. Claude verliert Effizienz
beim Vault-Scan, der Nutzer findet relevante Inhalte schlechter.

### Die Loesung

Quartalsweises Prune raeumt aktiv auf, aber unter strikter Kontrolle:

- Kandidaten werden nur **vorgeschlagen**, nie automatisch geloescht
- Pro Kandidat eine **explizite Frage** mit vier klaren Optionen
- **Archivierung** als sichere Default-Wahl bei Zweifel
- **Prune-Log** als revisionssicheres Protokoll jeder Entscheidung

### Quellen

- Standortbestimmung: `04 Ressourcen/Wissensmanagement/2026-06-13 Kuratierung im KI-Zeitalter.md`
- Schwester-Skills: [`lint`](../lint/), [`ingest`](../ingest/), `decay`, `synthesize`

## Dateistruktur

```
prune/
├── SKILL.md                      <- Skill-Logik DE
├── SKILL.en.md                   <- Skill-Logik EN
├── README.md                     <- Diese Datei
├── README.en.md                  <- EN-Version
├── prune-overview.excalidraw     <- Workflow-Diagramm DE (Excalidraw-Quelle)
├── prune-overview.png            <- Workflow-Diagramm DE (gerendert, ToDo)
├── prune-overview.en.excalidraw  <- Workflow-Diagramm EN
├── prune-overview.en.png         <- Workflow-Diagramm EN (ToDo)
└── scripts/
    └── find_duplicates.py        <- Bigramm-Jaccard-Heuristik fuer Duplikate
```

## Versionshistorie

| Version | Datum | Aenderungen |
|---------|-------|-------------|
| 1.0.0 | 2026-06-13 | Initial release: 4-Kategorien-Workflow mit Einzel-Confirmation |
| 1.0.1 | 2026-06-13 | Scan-Modus eingefuehrt fuer Routine-Auslosung (autonom, kein rm/mv). Voll-Modus unveraendert. |
