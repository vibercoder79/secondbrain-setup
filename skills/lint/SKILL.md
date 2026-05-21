---
name: lint
description: >
  Woechentlicher Gesundheits-Check des SecondBrain Obsidian Vaults. Findet verwaiste Notizen,
  fehlende Verknuepfungen, volle Inbox, veraltete Projekte und Projekt-Compliance-Drift
  (Whitelist-Verstoesse, kaputte Wikilinks, Naming-Konventionen) und schlaegt Korrekturen vor.
  Verwenden wenn der Nutzer "lint", "vault check", "pruefe das vault", "gesundheitscheck",
  "verwaiste notizen", "orphans", "projekt-compliance", "projekt-check" sagt.
version: 1.3.2
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

# Lint Skill — SecondBrain Gesundheits-Check

Du pruefst das SecondBrain Vault auf Gesundheit und schlaegst Verbesserungen vor.
Komplementaer zum `/ingest` Skill: Waehrend Ingest einzelne Notizen verarbeitet,
pruefst du das gesamte Vault systematisch.

## Vault

- **Pfad:** `~/Obsidian/SecondBrain/`
- **Struktur:** PARA (00 Kontext, 01 Inbox, 02 Projekte, 03 Bereiche, 04 Ressourcen, 05 Daily Notes, 06 Archiv, 07 Anhaenge)
- **Log:** `~/Obsidian/SecondBrain/log.md`

## Aufruf

| Input | Verhalten |
|-------|-----------|
| `/lint` | Vollstaendiger Vault-Check (alle 6 Schritte) |
| `/lint orphans` | Nur verwaiste Notizen suchen (Schritt 1) |
| `/lint inbox` | Nur Inbox pruefen (Teil von Schritt 3) |
| `/lint projekte` | Nur Projekt-Compliance-Sektion (Schritt 4) |
| `/lint index` | Nur Vault-Index regenerieren (Schritt 6) |

## Workflow

### Schritt 1: Verwaiste Notizen finden

1. **Alle Notizen auflisten** — Glob `**/*.md` im Vault (ausser `07 Anhaenge/`)
2. **Fuer jede Notiz pruefen** — Wird sie von mindestens einer anderen Notiz per `[[Wikilink]]` referenziert?
   - Grep im Vault nach `[[Notizname]]` oder `[[Notizname|`
3. **Ausnahmen** — Diese Dateien sind KEINE Orphans, auch ohne eingehende Links:
   - Daily Notes (`05 Daily Notes/`)
   - `CLAUDE.md`, `log.md`, `OTHER_AI.md`
   - Start-Dateien die gleich heissen wie ihr Ordner (z.B. `Claude Code/Claude Code.md`)
   - Dateien in `00 Kontext/`
4. **Ergebnis zeigen:**
   ```
   Verwaiste Notizen (keine eingehenden Links):
   - Setup Web Clipper.md (04 Ressourcen/Claude Code/SecondBrain/Perplexity/)
   - Brain Dump.md (01 Inbox/)
   
   3 von 28 Notizen sind verwaist.
   ```

### Schritt 2: Fehlende Verknuepfungen vorschlagen

1. **Fuer jede verwaiste Notiz** — Kernthemen extrahieren und Vault nach Treffern durchsuchen
2. **Auch gut vernetzte Notizen stichprobenartig pruefen** — Gibt es offensichtliche
   thematische Ueberlappungen ohne bestehenden Link?
3. **Vorschlaege praesentieren:**
   ```
   Fehlende Links:
   - [[Setup Web Clipper]] koennte verlinkt werden von [[SecondBrain Claude Desktop Cowork]]
     (beide erwaehnen Obsidian Web Clipper)
   - [[Memory-Architektur]] koennte verlinkt werden von [[Checkliste v14]]
     (beide erwaehnen CLAUDE.md und Auto Memory)
   ```
4. **Fuer jeden Vorschlag fragen** — "Soll ich diesen Link setzen? (ja/nein)"

### Schritt 3: Vault-Hygiene pruefen

Fuehre diese Checks durch und sammle die Ergebnisse:

**3a) Inbox-Check:**
- Zaehle Notizen in `01 Inbox/`
- Warnung wenn > 5 Notizen (Inbox sollte regelmaessig geleert werden)

**3b) Projekt-Status:**
- Alle Notizen in `02 Projekte/` mit `status: abgeschlossen` im Frontmatter finden
- Vorschlagen: "Diese Projekte koennten nach 06 Archiv/ verschoben werden"

**3c) Frontmatter-Check:**
- Notizen ohne YAML-Frontmatter (`---`) identifizieren
- Notizen ohne `tags` im Frontmatter identifizieren

**3d) Synthese-Seiten-Check:**
- Alle Unterordner in `04 Ressourcen/` auflisten
- Pruefen ob jeder Ordner eine gleichnamige Start-Datei hat
- Fehlende Start-Dateien melden

**Ergebnis zeigen:**
```
Vault-Hygiene:
  ✓ Inbox: 2 Notizen (OK)
  ⚠ Projekte: 1 abgeschlossenes Projekt nicht archiviert
  ✗ Frontmatter: 3 Notizen ohne Tags
  ✓ Synthese-Seiten: Alle Ressourcen-Ordner haben Start-Dateien
```

### Schritt 4: Projekt-Compliance pruefen

Iteriere ueber alle echten Projekt-Ordner und pruefe gegen die Governance
aus `00 Kontext/Projekt-Struktur.md` (File-Whitelist + Naming-Konventionen + Templates).

**Container-Ordner-Erkennung (Pflicht vor 4a-4g):**

Ordner in `02 Projekte/` deren Name mit Underscore beginnt (z.B. `_Beispiel-Container/`, `_Kunde-X/`)
sind **Container** — Sammelordner fuer mehrere zusammengehoerende Sub-Projekte (z.B. alle
Kundenprojekte eines Mandanten). Container haben selbst KEINEN PMO HUB und KEINE Governance.

Logik:

1. Pro Eintrag in `02 Projekte/*/`:
   - Wenn Ordnername mit `_` beginnt → **Container**: ueberspringe Pflicht-Dateien-Pruefung
     fuer den Container selbst. Iteriere stattdessen ueber `<Container>/*/` und behandle
     jeden direkten Sub-Ordner als eigenes Projekt (rekursiv NUR diese eine Ebene).
   - Sonst → **Projekt**: pruefe wie bisher.
2. Container-Ordner werden im Report unter "Container" ausgewiesen, nicht unter
   "Compliance-Verstoesse".
3. Sub-Projekte im Container muessen die volle Struktur haben (PMO HUB + Governance +
   Subordner) — die Konvention vererbt sich nicht abwaerts.
4. Zusaetzliche Container-spezifische Warnung: Wenn ein Container leer ist oder nur
   eine Ebene hat (also ein einziges Sub-Projekt), Hinweis "Container `_X` enthaelt
   nur Y Sub-Projekte — ist die Container-Ebene noch noetig?"

**4a) Whitelist-Check Projektwurzel**

Erlaubte Files im Projekt-Wurzelordner:
- `<Projekt> - PMO HUB.md` (Pflicht)
- `Projekt-Governance.md` (Pflicht)
- `Financials.md` (opt-in)

Files im Wurzel die diesem Muster nicht entsprechen → Warnung.
Spezialfall: `README.md` im Projektwurzel ist explizit verboten — Hinweis "PMO HUB ist die Landing Page".

**4b) Pflicht-Dateien existieren**

Pruefe pro Projekt:
- Existiert `* - PMO HUB.md`? Falls nicht → Error
- Existiert `Projekt-Governance.md`? Falls nicht → Error
- Existieren Subordner `Meetings/`, `Decisions/`, `Research/`, `assets/`? Falls nicht → Warnung

**4c) Naming-Konvention Hub-Datei**

Hub-Datei MUSS auf `- PMO HUB.md` enden. Andere Hub-Namen (alte `- Hub.md`, oder einfach `<Projektname>.md`)
→ Warnung mit Vorschlag fuer Umbenennung.

**4d) Markdown im falschen Ordner**

`*/Research/assets/*.md` finden — Markdown-Dateien sollten direkt in `Research/` liegen,
nur Bilder/SVG/PDF in `Research/assets/`.

**4e) Kaputte Wikilinks im PMO HUB**

Aus jedem PMO HUB alle `[[...]]` extrahieren und pruefen ob die Ziel-Datei existiert
(via Glob `**/<Treffer>.md`). Tote Links → Warnung mit Pfad-Angabe.

**4f) Decisions-Frontmatter-Konsistenz**

Pruefe alle Files in `*/Decisions/` auf:
- `status: entschieden` aber `entschieden_am` leer → Warnung
- `type` fehlt oder nicht "entscheidung" → Warnung

**4g) Pre-Backlog-Items aelter als 30 Tage**

In jedem PMO HUB die Sektion "Pre-Backlog Action Items" pruefen.
Wenn Items vorhanden und der Hub `aktualisiert:` Datum > 30 Tage alt → Hinweis
"Backlog-Tool aktivieren oder Items pflegen?"

**Ergebnis zeigen:**

```
Projekt-Compliance:
  ✓ Whitelist: 5/6 Projekte sauber
  ✗ Whitelist: Beispiel-Projekt — README.md im Wurzel
  ✓ Pflicht-Dateien: Alle Projekte haben PMO HUB + Governance
  ⚠ Naming: 1 Projekt hat Hub ohne "- PMO HUB" Suffix
  ⚠ Markdown in assets/: 4 Files in 1 Projekt
  ✗ Kaputte Wikilinks: 5 Links in 1 PMO HUB
  ✓ Decisions-Frontmatter: alle konsistent
  ⚠ Pre-Backlog: 1 Projekt mit Items > 30 Tage alt
```

### Schritt 5: Report erstellen und Log aktualisieren

1. **Report als Notiz** in `01 Inbox/` ablegen:

```markdown
---
tags: [system, lint-report]
date: YYYY-MM-DD
---

# Vault Lint Report — YYYY-MM-DD

## Zusammenfassung

X von Y Notizen sind verwaist | Z fehlende Links vorgeschlagen |
Inbox: N Notizen | M Notizen ohne Frontmatter |
Projekt-Compliance: K Verstoesse in J Projekten

## Verwaiste Notizen
- ...

## Fehlende Verknuepfungen
- ...

## Vault-Hygiene
- ...

## Projekt-Compliance

### Whitelist-Verstoesse
- [Projekt X] `README.md` im Wurzel — sollte geloescht oder verschoben werden
- [Projekt Y] `notes.md` im Wurzel — gehoert in einen Subordner

### Pflicht-Dateien fehlen
- [Projekt Z] `Projekt-Governance.md` fehlt

### Naming-Konvention
- [Projekt A] Hub heisst `<Projekt>.md` statt `<Projekt> - PMO HUB.md`

### Kaputte Wikilinks
- [Projekt B, PMO HUB Zeile 88] `[[04 Ressourcen/Research/...]]` zeigt ins Leere

### Markdown in falschem Ordner
- [Projekt C] `Research/assets/01-...md` — sollte ein Level hoeher liegen

### Pre-Backlog veraltet
- [Projekt D] 5 Items aelter als 30 Tage — Backlog-Tool aktivieren?

## Empfohlene Aktionen
1. ...
```

2. **Log-Eintrag** in `log.md` ergaenzen:

```markdown
## [YYYY-MM-DD] lint | Vault Gesundheits-Check

- **Orphans:** X verwaiste Notizen gefunden
- **Fehlende Links:** Y Vorschlaege
- **Projekt-Compliance:** K Verstoesse in J Projekten
- **Korrekturen:** Z Links gesetzt, W Notizen angepasst
- **Report:** [[YYYY-MM-DD Vault Lint Report]]
```

3. **Korrekturen anbieten** — Fuer jeden Finding fragen ob korrigiert werden soll.
   Einzeln abarbeiten, nicht alles auf einmal.

### Schritt 6: Vault-Index regenerieren

Erzeuge eine vorkompilierte `Index.md` im Vault-Wurzelverzeichnis. Sie ist **das
Wiki-Cover des Vaults** — Claude liest sie beim Session-Start, statt das ganze Vault
zu durchsuchen. Token-Effizienz statt Echtzeit-Suche (Karpathy LLM Wiki Pattern).

**Pfad:** `~/Obsidian/SecondBrain/Index.md`

**Wichtig:** Datei wird bei jedem Lauf vollstaendig **ueberschrieben** — keine
Dataview-Queries, sondern statische Wikilinks (Claude rendert kein Dataview).

**Inhalt der Index.md:**

```markdown
---
tags: [system, vault-index]
auto_generated: true
generated_at: YYYY-MM-DD HH:MM
generated_by: /lint
source: claude
chat_url: unbekannt
---

> [!warning] Auto-generiert von `/lint`
> Diese Datei wird bei jedem Lint-Lauf neu erzeugt. Manuelle Aenderungen gehen verloren.
> Quelle der Wahrheit sind die einzelnen Notizen, nicht dieser Index.

# SecondBrain Index

Cover-Seite des Vaults. Claude liest diese Seite beim Session-Start, um das Vault
ohne Volltextsuche zu navigieren.

## Aktive Projekte (`02 Projekte/`)

Glob `02 Projekte/*/` — pro Ordner ein Eintrag mit Wikilink zur PMO HUB Datei plus
`status` und `phase` aus dem Hub-Frontmatter.

- [[<Projekt> - PMO HUB]] — `aktiv` | `umsetzung` | aktualisiert YYYY-MM-DD
- ...

## Bereiche (`03 Bereiche/`)

Glob `03 Bereiche/*/` — pro Ordner ein Eintrag mit Wikilink zur gleichnamigen Start-Datei
(falls vorhanden) oder Ordnerverweis.

- [[Skills]] — Claude Code Skill Doku
- [[Lifelong Learning]]
- ...

## Synthese-Seiten (`04 Ressourcen/`)

Glob `04 Ressourcen/*/` — pro Themenordner die gleichnamige Start-Datei (Synthese-Seite
nach Variante B des LLM Wiki Patterns).

- [[Claude Code]] — Synthese aller Claude-Code-Notizen
- [[Perplexity]]
- ...

## Kontext (`00 Kontext/`)

Alle Markdown-Dateien direkt in `00 Kontext/` (rekursiv ohne Subordner-Inhalte).

- [[Über mich]]
- [[Branding]]
- [[Schreibstil]]
- [[ICP]]
- [[Angebot]]
- [[Projekt-Struktur]]

## Letzte Daily Notes

Letzte 5 Dateien aus `05 Daily Notes/`, sortiert absteigend nach Dateiname.

- [[2026-05-01]]
- [[2026-04-30]]
- ...

## Letzte Lint-Reports

Letzte 3 Dateien `* Vault Lint Report*` aus `01 Inbox/`, sortiert absteigend.

- [[YYYY-MM-DD Vault Lint Report]]
- ...

## Vault-Statistik

- Notizen gesamt: N
- Verwaiste Notizen (letzter Lint): X
- Aktive Projekte: K
- Inbox-Stand: N Eintraege
```

**Generierungs-Regeln:**

1. **Pro Sektion:** Glob laufen lassen, Frontmatter lesen wo relevant (`status`, `phase`,
   `aktualisiert` aus PMO HUB-Files), als Wikilink-Liste schreiben.
2. **Wikilink-Form:** Nur den Notiz-Namen ohne Ordner-Pfad in `[[ ]]` — Obsidian-Konvention.
3. **Sortierung:** Aktive Projekte: nach `aktualisiert` absteigend. Daily Notes/Lint-Reports:
   nach Dateiname absteigend. Bereiche/Synthese/Kontext: alphabetisch.
4. **Filter:** Nur PMO HUB-Files mit `status: aktiv` listen — abgeschlossene/pausierte ueberspringen
   (sie sind im Archiv oder im Hub-Frontmatter sichtbar).
5. **Statistik-Werte:** aus Schritt 1 (Orphans) und 3 (Inbox) wiederverwenden, nicht neu zaehlen.
6. **Atomic Write:** Erst kompletten Inhalt aufbauen, dann mit `Write` ueberschreiben — keine
   inkrementellen Edits. Index ist immer ein Snapshot.
7. **Bei `/lint index`:** Nur Schritt 6 ausfuehren (Statistik-Werte dann aus letztem Report ziehen
   oder als "—" markieren wenn nicht vorhanden).

**Log-Eintrag fuer Schritt 6** (in den bestehenden Log-Block aus Schritt 5 einbetten):

```markdown
- **Index:** Index.md regeneriert (K aktive Projekte, M Synthese-Seiten)
```

## Regeln

1. **IMMER fragen** bevor Notizen veraendert werden
2. **NIE loeschen** — bestehende Inhalte werden nur ergaenzt
3. **07 Anhaenge/ komplett ignorieren** — keine Bilder/PDFs durchsuchen
4. **Daily Notes sind keine Orphans** — sie stehen fuer sich
5. **Report ist sachlich** — keine Wertungen, nur Fakten und Vorschlaege
6. **Log ist append-only** — nie bestehende Eintraege aendern
7. **Sprache: Deutsch** — alle Ausgaben auf Deutsch
