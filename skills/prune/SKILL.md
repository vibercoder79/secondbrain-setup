---
name: prune
description: >
  Findet Loesch-Kandidaten im SecondBrain Obsidian Vault (Duplikate, alte Orphans,
  ungenutzte Brain Dumps, veraltete Notizen) und schlaegt Loeschung oder Archivierung vor.
  Strikt mit Einzel-Confirmation, kein Auto-Delete. Verwenden wenn der Nutzer
  "prune", "loesch-vorschlaege", "vault entruempeln", "aussortieren",
  "duplikate finden", "alte orphans aufraeumen" sagt.
version: 1.0.1
user-invocable: true
allowed-tools:
  - Read
  - Edit
  - Write
  - Bash
  - Glob
  - Grep
  - AskUserQuestion
runtime: claude-local
layer-target: raw
---

# Prune Skill — SecondBrain Aktive Reduktion

Du findest Loesch-Kandidaten im SecondBrain Vault und schlaegst Loeschung oder Archivierung vor.
Quartalsweise Nutzung. Komplementaer zu `/lint` (Diagnose), `/decay` (Frische-Markierung)
und `/synthesize` (Verdichtung): waehrend Lint nur findet und Decay markiert, raeumt
Prune tatsaechlich auf.

## Vault

- **Pfad:** `/Users/tobiasschmidt/Obsidian/SecondBrain/`
- **Struktur:** PARA (00 Kontext, 01 Inbox, 02 Projekte, 03 Bereiche, 04 Ressourcen, 05 Daily Notes, 06 Archiv, 07 Anhaenge)
- **Log:** `/Users/tobiasschmidt/Obsidian/SecondBrain/log.md`
- **Vault-Gesundheit (Lint-Reports und Prune-Logs):** `03 Bereiche/Vault-Gesundheit/`

## Sicherheits-Defaults (kritisch)

1. **KEIN Auto-Delete.** Jede Loeschung und jede Archivierung wird einzeln per
   AskUserQuestion bestaetigt. Niemals Bulk-Loeschung.
2. **Vor dem ersten Prune-Lauf: Vault-Backup empfohlen.** Beispiel:

   ```bash
   cd /Users/tobiasschmidt/Obsidian/SecondBrain && \
     git add -A && git commit -m "pre-prune backup $(date +%F)"
   ```

   Wenn das Vault unter Git steht, reicht ein Commit. Sonst:

   ```bash
   tar -czf ~/Desktop/SecondBrain-backup-$(date +%F).tar.gz \
     -C /Users/tobiasschmidt/Obsidian SecondBrain
   ```

3. **Bei Unsicherheit: Archivieren statt Loeschen.** Default-Empfehlung ist immer
   `archivieren` wenn der Kandidat aelter als 6 Monate ist oder Inhalt jenseits eines
   reinen Brain Dumps haben koennte.
4. **07 Anhaenge/ komplett ignorieren.** Bilder und PDFs werden nicht angefasst.
5. **Niemals Dateien aus `00 Kontext/`, `CLAUDE.md`, `log.md`, `Index.md` oder
   `03 Bereiche/Skills/` als Kandidaten vorschlagen.** Diese sind systemkritisch.

## Aufruf

| Input | Verhalten |
|-------|-----------|
| `/prune` | Voller Lauf, alle vier Kategorien |
| `/prune duplikate` | Nur Duplikate |
| `/prune orphans` | Nur alte Orphans |
| `/prune inbox` | Nur alte Brain Dumps in `01 Inbox/` |
| `/prune veraltet` | Nur Notizen mit `freshness: veraltet` |
| `/prune scan-only` | Reiner Scan-Modus, schreibt nur Vorschlagsliste, keine Aktionen |
| `/prune scan-only category:duplicates` | Scan-Modus, nur Duplikate |
| `/prune scan-only category:orphans` | Scan-Modus, nur Orphans |
| `/prune scan-only category:brain-dumps` | Scan-Modus, nur alte Brain Dumps |
| `/prune scan-only category:decayed` | Scan-Modus, nur veraltete Notizen |

Wenn nichts angegeben wird, biete vor dem Lauf per AskUserQuestion an, den Scope einzuschraenken.

## Modi

| Modus | Auslosung | Wirkung | Routine-tauglich |
|-------|-----------|---------|------------------|
| Voll-Modus (Default) | manuell | Einzel-Confirmation, echte Loeschungen und Archivierungen | nein (interaktiv) |
| Scan-Modus (`scan-only`) | manuell oder Routine | Vorschlagsliste als Scan-Report, KEINE Aktionen | ja (autonom) |

Scan ist der Sensor, der Voll-Lauf bleibt strikt manuell. Loeschungen und
Archivierungen duerfen niemals automatisierbar sein — der Scan-Modus liefert nur
das Bild, die Entscheidung trifft immer der Nutzer im interaktiven Voll-Lauf.

## Workflow Scan-Modus (`scan-only`)

Wenn der Aufruf `scan-only` enthaelt, gilt folgender verkuerzter, nicht-interaktiver Pfad:

1. **Scope ableiten ohne Rueckfrage.** Default: alle vier Kategorien. Wenn ein
   `category:<name>`-Filter mitgegeben ist (`duplicates`, `orphans`, `brain-dumps`,
   `decayed`), nur diese Kategorie sammeln.
2. **Backup-Check entfaellt.** Es werden keine Aktionen ausgefuehrt, also kein Risiko.
3. **Kandidaten sammeln wie im Voll-Modus** (Schritt 2 unten). Dieselben Heuristiken,
   dieselben Schutzzonen, dieselben Empfehlungs-Regeln.
4. **Scan-Report schreiben** nach
   `03 Bereiche/Vault-Gesundheit/YYYY-MM-DD Prune Scan.md` (Dateiname enthaelt "Scan"
   statt "Log", damit klar vom interaktiven Lauf unterscheidbar).
5. **Keine `rm`-, keine `mv`-Operationen.** Keine `AskUserQuestion`.
6. **Log-Eintrag in `log.md`** mit Praefix `prune-scan` statt `prune`.

Scan-Report-Format:

```markdown
---
tags: [system, prune-scan]
date: YYYY-MM-DD
scope: <alle | duplicates | orphans | brain-dumps | decayed>
source: claude
chat_url: <falls bekannt, sonst unbekannt>
---

# Prune Scan — YYYY-MM-DD

- Lauf-Datum: YYYY-MM-DD
- Scope: <alle | nur duplicates | ...>
- Gesamtzahl Kandidaten: N

## Duplikate

| Pfad A | Pfad B | Aehnlichkeit | Begruendung | Empfehlung |
|--------|--------|--------------|-------------|------------|
| ... | ... | 0.82 | juenger, weniger Backlinks | loeschen |

## Alte Orphans

| Pfad | Begruendung | Empfehlung |
|------|-------------|------------|
| ... | 3/3 Lint-Laeufe, 47 Worte | loeschen |

## Alte Brain Dumps

| Pfad | Begruendung | Empfehlung |
|------|-------------|------------|
| ... | 13 Monate, keine Backlinks | archivieren |

## Veraltete Notizen

| Pfad | Begruendung | Empfehlung |
|------|-------------|------------|
| ... | freshness: veraltet, Update vor 5 Monaten | archivieren |

---

Folge-Schritt: `/prune` manuell starten und Einzel-Confirmation durchgehen.
```

Append-Eintrag in `log.md`:

```markdown
## [YYYY-MM-DD] prune-scan | Scan-Lauf (autonom)

- **Scope:** <alle | nur duplicates | ...>
- **Kandidaten:** N
- **Report:** [[YYYY-MM-DD Prune Scan]]
- **Hinweis:** Keine Aktionen ausgefuehrt. Folge-Schritt: `/prune` manuell.
```

Damit endet der Scan-Modus. Die Schritte 3 bis 7 des Voll-Modus werden uebersprungen.

## Workflow Voll-Modus

### Schritt 1: Scope und Kategorien waehlen

1. Pruefe das Backup. Wenn der Nutzer noch kein Backup gemacht hat: kurz auf die
   Backup-Befehle (siehe Sicherheits-Defaults) hinweisen und fragen ob er fortfahren will.
2. Per AskUserQuestion: "Welche Kategorien pruefen?" mit Multi-Select-Optionen
   (Duplikate, Alte Orphans, Alte Brain Dumps, Veraltete Notizen, Alle). Default: Alle.
3. Notiere die Auswahl.

### Schritt 2: Kandidaten sammeln

#### 2a) Duplikate

Pruefe Title-Matches und Inhalts-Aehnlichkeit:

1. **Title-Match (gleicher Dateiname in mehreren Ordnern):**
   ```bash
   find /Users/tobiasschmidt/Obsidian/SecondBrain -type f -name '*.md' \
     -not -path '*/07 Anhaenge/*' -not -path '*/06 Archiv/*' \
     -exec basename {} \; | sort | uniq -d
   ```
2. **Inhalts-Heuristik:** Fuer jedes Title-Paar `scripts/find_duplicates.py` aufrufen
   (Bigramm-Jaccard auf normalisiertem Text). Schwelle >= 0.6 → Duplikats-Verdacht.
3. **Pro Duplikats-Paar Empfehlung bilden:**
   - Aelteres File mit weniger Backlinks → loeschen
   - Beide gleich gut verlinkt, aber unterschiedlicher Inhalt → archivieren oder mergen
   - Bei Mismatch zwischen Title und Inhalt → behalten, beide

Ausgabe pro Paar: A, B, Aehnlichkeit, Backlink-Count je File, Empfehlung.

#### 2b) Alte Orphans (drei Lint-Laeufe persistent)

1. Liste die letzten drei Lint-Reports aus `03 Bereiche/Vault-Gesundheit/` (Glob
   `* Vault Lint Report*.md`, sortiert absteigend nach Dateiname).
2. Wenn weniger als drei Reports vorhanden: Hinweis an Nutzer "Weniger als drei
   Lint-Laeufe vorhanden — Schnittmenge nicht ableitbar. Fallback: aktuelle Orphans
   aus letztem Lint-Report nehmen, mit Warnung."
3. Schnittmenge bilden: nur Notizen die in allen drei Reports als Orphan markiert sind.
4. **Live-Gegencheck:** fuer jeden Kandidaten per Grep im Vault pruefen ob ein
   `[[Notizname]]` oder `[[Notizname|` existiert. Treffer → vom Kandidaten-Set entfernen.
5. **Ausnahmen** (nie als Orphan-Kandidat vorschlagen):
   - Daily Notes (`05 Daily Notes/`)
   - `00 Kontext/`, `CLAUDE.md`, `log.md`, `Index.md`, `OTHER_AI.md`
   - Synthese-Start-Dateien (gleichnamig wie ihr Ordner)
   - Ordnerwurzel-Hubs in `02 Projekte/*/` und `03 Bereiche/*/`

Empfehlung pro Kandidat: archivieren wenn Inhalt > 200 Worte, sonst loeschen.

#### 2c) Alte Brain Dumps in `01 Inbox/`

1. Glob `01 Inbox/*.md`.
2. Pro Datei: Frontmatter `date` lesen. Fallback Bash `stat -f %m` (Modified Time).
3. Alle Dateien aelter als 12 Monate (heute minus 365 Tage) sammeln.
4. Backlink-Check per Grep: gibt es `[[Dateiname]]` irgendwo im Vault?
5. **Nur die ohne Backlinks** als Kandidaten behalten.

Empfehlung: loeschen wenn < 100 Worte und kein Frontmatter, sonst archivieren.

#### 2d) Veraltete Notizen mit `freshness: veraltet`

1. Grep ueber das ganze Vault (ausser `07 Anhaenge/`, `06 Archiv/`):
   ```
   freshness: veraltet
   ```
2. Pro Treffer: Frontmatter `aktualisiert` oder `date` lesen, wenn das Update mehr
   als 90 Tage zurueckliegt → Kandidat.
3. Empfehlung: immer archivieren (nicht loeschen), ausser explizit als "draft" oder
   "brain dump" markiert.

### Schritt 3: Vorschlagsliste anzeigen

Pro Kategorie ein Block mit pro Kandidat einer Zeile:

```
## Duplikate

1. [[Setup Web Clipper]] (04 Ressourcen/...) vs. [[Setup Web Clipper]] (01 Inbox/)
   - Aehnlichkeit: 0.82
   - Backlinks: A=3, B=0
   - Empfehlung: B loeschen (Inbox-Kopie, juenger, ungenutzt)

## Alte Orphans

2. [[Idee Newsletter Anbieter]] — 01 Inbox/
   - In allen letzten 3 Lint-Reports als Orphan
   - 47 Worte, kein Frontmatter
   - Empfehlung: loeschen

## Alte Brain Dumps

3. [[Gedanke RAG vs. Wiki]] — 01 Inbox/
   - date: 2025-05-12 (13 Monate alt), keine Backlinks
   - 312 Worte
   - Empfehlung: archivieren

## Veraltete Notizen

4. [[Webflow Plan]] — 04 Ressourcen/...
   - freshness: veraltet, letztes Update vor 5 Monaten
   - Empfehlung: archivieren
```

Wenn die Gesamt-Liste > 30 Kandidaten hat: vor dem interaktiven Loop einen Hinweis
"X Kandidaten — willst du eine Kategorie zuerst durcharbeiten oder alles am Stueck?".

### Schritt 4: Einzel-Confirmation per AskUserQuestion

Iteriere ueber die Kandidaten. **Pro Kandidat eine AskUserQuestion** mit den Optionen:

- `loeschen` — File wird per `rm` entfernt
- `archivieren` — File wird per `mv` nach `06 Archiv/` verschoben (Struktur erhalten,
  z.B. `06 Archiv/01 Inbox/<file>.md` oder `06 Archiv/<original-pfad>`)
- `behalten` — File bleibt unangetastet
- `ueberspringen` — Entscheidung auf naechsten Lauf vertagen

Zeige die Begruendung jeweils mit, damit der Nutzer den Kontext im Frage-Prompt sieht.

**Niemals Bulk-Antworten anbieten** wie "alle loeschen". Jede Entscheidung einzeln.

### Schritt 5: Aktionen ausfuehren

Pro Entscheidung:

- **loeschen:**
  ```bash
  rm "<absoluter Pfad>"
  ```
- **archivieren:**
  ```bash
  mkdir -p "06 Archiv/<original-relativer-ordner>" && \
    mv "<absoluter Pfad>" "06 Archiv/<original-relativer-ordner>/"
  ```
  Wenn die Datei aus `01 Inbox/` kommt → Ziel `06 Archiv/01 Inbox/`.
  Wenn aus `04 Ressourcen/<topic>/` → Ziel `06 Archiv/04 Ressourcen/<topic>/`.
- **behalten / ueberspringen:** keine Aktion, nur im Log vermerken.

Bei Fehler (Datei nicht vorhanden, Schreibrechte): abbrechen, im Log "Fehler" notieren,
mit naechstem Kandidaten weiter.

### Schritt 6: Prune-Log schreiben

Lege `03 Bereiche/Vault-Gesundheit/YYYY-MM-DD Prune Log.md` an:

```markdown
---
tags: [system, prune-log]
date: YYYY-MM-DD
source: claude
chat_url: <falls bekannt, sonst unbekannt>
---

# Prune Log — YYYY-MM-DD

## Zusammenfassung

- Kandidaten gesamt: N
- Geloescht: A
- Archiviert: B
- Behalten: C
- Uebersprungen: D

## Duplikate

| Datei A | Datei B | Aehnlichkeit | Entscheidung |
|---------|---------|--------------|--------------|
| ... | ... | 0.82 | B geloescht |

## Alte Orphans

| Datei | Lint-Persistenz | Entscheidung |
|-------|----------------|--------------|
| ... | 3/3 | archiviert nach 06 Archiv/... |

## Alte Brain Dumps

| Datei | Alter | Entscheidung |
|-------|-------|--------------|
| ... | 13 Monate | archiviert |

## Veraltete Notizen

| Datei | freshness | Entscheidung |
|-------|-----------|--------------|
| ... | veraltet | archiviert |

## Fehler

(falls vorhanden — pro Eintrag Datei + Fehlertext)
```

### Schritt 7: Log-Eintrag in `log.md`

Append-only Eintrag:

```markdown
## [YYYY-MM-DD] prune | Vault Aufraeumen

- **Kandidaten:** N
- **Geloescht:** A | **Archiviert:** B | **Behalten:** C | **Uebersprungen:** D
- **Log:** [[YYYY-MM-DD Prune Log]]
```

## Regeln

1. **Kein Auto-Delete.** Jede Aktion einzeln bestaetigt.
2. **Archivieren > Loeschen** bei Zweifel.
3. **Backup vorher empfehlen.**
4. **Schutzzonen einhalten:** `00 Kontext/`, `CLAUDE.md`, `log.md`, `Index.md`,
   `03 Bereiche/Skills/`, `07 Anhaenge/`, Daily Notes.
5. **Synthese-Start-Dateien (Ordnername == Dateiname) nie als Orphan vorschlagen.**
6. **Log ist append-only** in `log.md`. Pro Lauf ein neues Prune-Log-File in
   `03 Bereiche/Vault-Gesundheit/`.
7. **Sprache: Deutsch** in allen Ausgaben.
