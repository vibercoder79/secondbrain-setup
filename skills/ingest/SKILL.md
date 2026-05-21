---
name: ingest
description: >
  Verarbeitet Notizen im SecondBrain Obsidian Vault und vernetzt sie mit dem restlichen Wissen.
  Setzt bidirektionale Wikilinks, aktualisiert Synthese-Seiten und fuehrt ein Verarbeitungs-Log.
  Verwenden wenn der Nutzer "ingest", "verarbeite diese Notiz", "vernetze das",
  "link diese Notiz", "integriere das ins Vault" sagt.
version: 1.0.0
user-invocable: true
allowed-tools:
  - Read
  - Edit
  - Write
  - Bash
  - Glob
  - Grep
  - AskUserQuestion
---

# Ingest Skill — SecondBrain Vernetzung

Du verarbeitest Notizen im SecondBrain und vernetzt sie mit dem restlichen Vault.
Das Ziel: Aus isolierten Notizen ein vernetztes Wissenssystem machen.

Inspiriert von Andrej Karpathys LLM Wiki Pattern — Vorverarbeitung statt Echtzeit-Suche.

## Vault

- **Pfad:** `~/Obsidian/SecondBrain/`
- **Struktur:** PARA (00 Kontext, 01 Inbox, 02 Projekte, 03 Bereiche, 04 Ressourcen, 05 Daily Notes, 06 Archiv, 07 Anhaenge)
- **Log:** `~/Obsidian/SecondBrain/log.md`

## Aufruf

| Input | Verhalten |
|-------|-----------|
| `/ingest Notizname` | Verarbeitet die genannte Notiz |
| `/ingest /pfad/zur/notiz.md` | Verarbeitet die Notiz am Pfad |
| `/ingest` (ohne Argument) | Fragt welche Notiz verarbeitet werden soll |

## Workflow

Fuehre diese 4 Schritte der Reihe nach aus:

### Schritt 1: Notiz analysieren und Vault durchsuchen

1. **Notiz identifizieren** — Wenn kein Argument: Frage den Nutzer welche Notiz.
   Bei Name ohne Pfad: Suche die Notiz per Glob im Vault.
2. **Notiz lesen** — Vollstaendig lesen, Kernthemen und Entitaeten extrahieren.
3. **Verwandte Notizen finden** — Fuer jedes Kernthema:
   - Grep nach dem Thema/Begriff im Vault (ausser 07 Anhaenge/)
   - Glob nach Dateinamen die das Thema enthalten
   - Tags aus dem Frontmatter mit Tags anderer Notizen abgleichen
4. **Ergebnis zeigen** — Dem Nutzer die Liste verwandter Notizen praesentieren:
   ```
   Gefundene Zusammenhaenge fuer "Memory-Architektur":
   - [[Claude Code Checklist]] (02 Projekte) — erwaehnt Memory, CLAUDE.md
   - [[SecondBrain Claude Desktop Cowork]] (04 Ressourcen) — erwaehnt Vault, Memory
   - [[2026-04-14]] (05 Daily Notes) — erwaehnt Memory-Architektur
   ```

### Schritt 2: Wikilinks setzen (bidirektional)

1. **Links fuer die neue Notiz vorschlagen** — Zeige welche [[Wikilinks]] eingefuegt werden.
2. **Ruecklinks vorschlagen** — Zeige welche bestehenden Notizen einen Link zurueck bekommen.
3. **Nutzer fragen** — "Sollen diese Links gesetzt werden? (ja/nein/anpassen)"
4. **Erst nach Bestaetigung** — Links einfuegen:
   - In der Quell-Notiz: [[Wikilinks]] an passender Stelle (Ende oder im Text)
   - In verwandten Notizen: `[[Quell-Notiz]]` unter einem Abschnitt "Verwandte Notizen"
   - Bestehende Links NICHT duplizieren — vorher pruefen ob Link schon existiert

**Link-Format:**
- Standard: `[[Notizname]]` (Obsidian findet nach Name, nicht Pfad)
- Bei Mehrdeutigkeit: `[[Ordner/Notizname|Anzeigename]]`

### Schritt 3: Synthese-Seite aktualisieren

1. **Passende Synthese-Seite finden** — Pruefe ob in `04 Ressourcen/` ein Themen-Ordner
   existiert der zum Thema passt. Die Start-Datei des Ordners ist die Synthese-Seite.
   Beispiel: Notiz ueber Claude Code → `04 Ressourcen/Claude Code/Claude Code.md`
2. **Wenn Synthese-Seite existiert:**
   - Notiz lesen, Kernerkenntnisse destillieren (NICHT copy-paste!)
   - Pruefen welcher Abschnitt der Synthese-Seite ergaenzt werden soll
   - Dem Nutzer den vorgeschlagenen Abschnitt zeigen
   - Nach Bestaetigung: Ergaenzung einfuegen mit Datum und Quell-Link
   - Format: `**[2026-04-15]** Erkenntnis aus [[Quell-Notiz]]: ...`
3. **Wenn keine Synthese-Seite existiert:**
   - Fragen: "Es gibt noch keine Synthese-Seite fuer [Thema]. Soll ich eine anlegen?"
   - Wenn ja: Neue Seite in `04 Ressourcen/[Thema]/[Thema].md` erstellen mit Frontmatter,
     initialem Ueberblick und erster Erkenntnis aus der Quell-Notiz

**Was eine gute Synthese ist:**
- Destillierte Erkenntnis, nicht Zusammenfassung
- Verbindet neue Information mit bestehendem Wissen
- Eigene Formulierung, nicht Copy-Paste aus der Quelle
- Kurz (2-5 Saetze pro Eintrag)

### Schritt 4: Log aktualisieren

Append-only Eintrag in `~/Obsidian/SecondBrain/log.md`:

```markdown
## [2026-04-15] ingest | Notizname

- **Quelle:** [[Pfad/zur/Notiz]]
- **Links gesetzt:** [[Notiz A]], [[Notiz B]], [[Notiz C]]
- **Ruecklinks:** [[Notiz A]] ← [[Quell-Notiz]], [[Notiz B]] ← [[Quell-Notiz]]
- **Synthese aktualisiert:** [[Thema]] — Abschnitt "XY" ergaenzt
```

Wenn `log.md` nicht existiert: Erstelle sie mit Header:
```markdown
---
tags: [system, log]
---

# SecondBrain Ingest Log

Chronologisches Verzeichnis aller Ingest-Vorgaenge.

```

## Regeln

1. **IMMER fragen** bevor Links gesetzt oder Notizen veraendert werden
2. **NIE loeschen** — bestehende Inhalte werden nur ergaenzt, nie entfernt
3. **NIE duplizieren** — vor jedem Link pruefen ob er schon existiert
4. **Synthese ≠ Copy-Paste** — eigene Formulierung, destillierte Erkenntnis
5. **Log ist append-only** — nie bestehende Eintraege aendern
6. **07 Anhaenge/ ignorieren** — Bilder, PDFs etc. nicht durchsuchen
7. **Sprache: Deutsch** — alle Ausgaben und Ergaenzungen auf Deutsch
