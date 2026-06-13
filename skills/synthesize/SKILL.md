---
name: synthesize
description: >
  Verdichtet Notizen eines Themen-Clusters im SecondBrain Obsidian Vault zu einer Synthese-Seite
  oder MOC (Map of Content). Findet Widersprueche und Luecken. Hebt Roh-Material in die
  kuratierte Schicht. Verwenden wenn der Nutzer "synthesize", "verdichte das wissen",
  "MOC fuer", "fasse das cluster zusammen" sagt.
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
runtime: claude-local
layer-target: curated
---

# Synthesize Skill — SecondBrain Verdichtung

Du verdichtest die Roh-Notizen eines Themen-Clusters im SecondBrain zu einer Synthese-Seite
oder einem MOC (Map of Content). Damit hebst du Roh-Material aus der Roh-Schicht
(Inbox, Daily Notes, KI-Outputs) in die kuratierte Schicht (MOCs, Synthesen, ADRs, 00 Kontext).

Komplementaer zu den Schwester-Skills:

- `/ingest` verlinkt einzelne Notizen
- `/lint` prueft Hygiene
- `/decay` und `/prune` halten die Schicht sauber

`/synthesize` ist der kuratorische Schritt: aus Vielem wird Wenig, aber Verbindliches.

## Vault

- **Pfad:** `/Users/tobiasschmidt/Obsidian/SecondBrain/`
- **Struktur:** PARA (00 Kontext, 01 Inbox, 02 Projekte, 03 Bereiche, 04 Ressourcen, 05 Daily Notes, 06 Archiv, 07 Anhaenge)
- **Zwei-Schichten-Architektur:** Roh-Schicht (Inbox, Daily Notes, KI-Outputs) und kuratierte Schicht (MOCs, Synthesen, ADRs, 00 Kontext)
- **Log:** `/Users/tobiasschmidt/Obsidian/SecondBrain/log.md`

## Aufruf

| Input | Verhalten |
|-------|-----------|
| `/synthesize cluster:"04 Ressourcen/KI"` | Synthese fuer den Ordner-Cluster |
| `/synthesize tag:#thema` | Synthese fuer alle Notizen mit diesem Tag |
| `/synthesize "Pfad/zum/Ordner"` | Synthese fuer einen Ordnerpfad |
| `/synthesize` (ohne Argument) | Per AskUserQuestion fragen |

Trigger-Saetze: "synthesize", "verdichte das wissen", "synthese fuer", "MOC fuer",
"map of content fuer", "fasse das cluster zusammen".

## Workflow

Fuehre diese 6 Schritte der Reihe nach aus.

### Schritt 1: Cluster-Wahl

1. **Argument auswerten:**
   - `cluster:"<Pfad>"` oder reiner Pfad → Ordner-Cluster
   - `tag:#<tag>` → Tag-Cluster
   - Ohne Argument → AskUserQuestion mit drei Optionen (Ordner, Tag, bestehender MOC zum Aktualisieren)
2. **Cluster verifizieren:**
   - Bei Ordner: Glob `<Pfad>/**/*.md`, melden wie viele Notizen drin sind
   - Bei Tag: Grep `tags:.*<tag>` im ganzen Vault (ausser `07 Anhaenge/`), Treffer-Liste zeigen
   - Bei MOC: Wikilinks aus bestehendem MOC extrahieren, plus neue Notizen die thematisch passen
3. **Confirm:** Nutzer sieht die Notiz-Liste vor der Analyse. Bei mehr als 30 Notizen Hinweis,
   dass Cluster moeglicherweise zu gross ist und in Unter-Cluster geteilt werden sollte.

### Schritt 2: Notizen sammeln und lesen

1. **Alle Notizen aus Schritt 1 lesen** — vollstaendig, nicht nur Frontmatter
2. **Pro Notiz erfassen:**
   - Pfad, Dateiname
   - Frontmatter (date, tags, source, status)
   - Kernaussagen (2 bis 5 pro Notiz)
   - Verwendete Konzepte und Entitaeten
3. **07 Anhaenge/ ignorieren** — Bilder und PDFs nicht durchsuchen

### Schritt 3: Analyse

Erzeuge intern eine Arbeitstabelle und werte sie aus.

**3a) Themen-Cluster bilden:**
Gruppiere Kernaussagen nach Sub-Themen. Beispiel im Cluster `04 Ressourcen/KI`:
Modelle, Tooling, Workflow, Governance.

**3b) Widersprueche markieren:**
Wenn zwei Notizen das gleiche Sub-Thema unterschiedlich behandeln, beide nennen und
die Quellen verlinken. Beispiel:
```
Widerspruch: Memory-Strategie
- [[Notiz A]] empfiehlt globales Memory pro User
- [[Notiz B]] empfiehlt projekt-lokales Memory
```

**3c) Luecken benennen:**
Themen die im Cluster anklingen, aber nicht beantwortet werden. Beispiel:
```
Luecke: Wie skaliert das Pattern bei mehr als 10 Projekten?
- In keiner Notiz behandelt
```

**3d) Dichte pruefen:**
Sub-Themen mit nur einer Quelle bekommen eine Confidence-Markierung "schwach belegt".

### Schritt 4: Vorschlag erstellen (kein Auto-Write)

Wahl zwischen zwei Formaten:

**Variante A — Synthese-Notiz** (wenn Cluster fokussiert ist, ein Kernthema):
Pfad-Vorschlag: gleicher Ordner wie Cluster, Dateiname `Synthese - <Thema>.md`

**Variante B — MOC** (wenn Cluster breit ist, mehrere Sub-Themen):
Pfad-Vorschlag: gleicher Ordner wie Cluster, Dateiname `_MOC.md` oder
`<Thema> MOC.md`

Frag den Nutzer welche Variante. Default-Empfehlung: ab 4 Sub-Themen MOC, sonst Synthese.

**Template Synthese-Notiz:**

```markdown
---
layer: curated
type: synthese
date: YYYY-MM-DD
tags: [synthese, <cluster-tag>]
source: claude
chat_url: <url-oder-unbekannt>
related:
  - "[[Quell-Notiz 1]]"
  - "[[Quell-Notiz 2]]"
---

# Synthese — <Thema>

## Kernaussagen

- Aussage 1 (belegt durch [[Quell A]], [[Quell B]])
- Aussage 2 (belegt durch [[Quell C]])

## Widersprueche

- Memory-Strategie: [[Notiz A]] global vs [[Notiz B]] projekt-lokal

## Luecken

- Skalierung ueber 10 Projekte ist offen

## Quellen

- [[Quell A]]
- [[Quell B]]
- [[Quell C]]
```

**Template MOC:**

```markdown
---
layer: curated
type: moc
date: YYYY-MM-DD
tags: [moc, <cluster-tag>]
source: claude
chat_url: <url-oder-unbekannt>
---

# <Thema> MOC

Map of Content fuer alle Notizen im Cluster `<Pfad>`.

## Sub-Themen

### Modelle
- [[Notiz A]] — Kernaussage in einem Satz
- [[Notiz B]] — Kernaussage in einem Satz

### Tooling
- [[Notiz C]] — Kernaussage

### Workflow
- [[Notiz D]] — Kernaussage

## Widersprueche im Cluster

- Memory-Strategie: [[Notiz A]] global vs [[Notiz B]] projekt-lokal

## Offene Luecken

- Skalierung ueber 10 Projekte
- Kosten-Vergleich der Tools

## Schwach belegt (eine Quelle)

- [[Notiz E]] — Behauptung X nur hier
```

### Schritt 5: Preview und Bestaetigung

1. **Preview zeigen** — kompletter Markdown-Output im Chat, plus Ziel-Pfad
2. **Mit AskUserQuestion fragen:**
   - schreiben (Datei anlegen plus Rueckverlinkungen setzen)
   - anpassen (Nutzer gibt Aenderungen, neue Preview)
   - verwerfen (kein Schreibvorgang, Log nur als Vorschlag)
3. **KEIN Auto-Write** ohne explizite Bestaetigung.

### Schritt 6: Schreiben, verlinken, loggen

Erst nach Bestaetigung:

1. **Datei schreiben** an den vorgeschlagenen Pfad
2. **Rueckverlinkungen setzen:**
   - Pro Quell-Notiz aus dem Cluster pruefen ob bereits ein Link auf die Synthese
     besteht. Falls nicht: Abschnitt `## Verwandte Notizen` am Ende der Quell-Notiz
     anlegen oder ergaenzen mit `- [[<Synthese-Datei>]]`
   - Nicht duplizieren
3. **Log-Eintrag** in `log.md` ergaenzen (append-only):

```markdown
## [YYYY-MM-DD] synthesize | <Thema>

- **Cluster:** <Pfad oder Tag>
- **Notizen verarbeitet:** N
- **Output:** [[<Datei>]] (Variante: synthese / moc)
- **Widersprueche:** K
- **Luecken:** M
- **Rueckverlinkungen gesetzt:** L Quell-Notizen ergaenzt
```

## Regeln

1. **KEIN Auto-Write** — Datei wird erst nach Bestaetigung geschrieben
2. **KEIN Auto-Delete** — Quell-Notizen bleiben unangetastet, nur ergaenzt
3. **NIE duplizieren** — vor jedem Rueckverlink pruefen ob er schon existiert
4. **Quell-Treue** — jede Aussage in der Synthese muss auf eine Quelle zeigen
5. **Widersprueche nicht aufloesen** — sie werden sichtbar gemacht, der Nutzer entscheidet
6. **07 Anhaenge/ ignorieren** — keine Bilder, PDFs durchsuchen
7. **Log ist append-only** — bestehende Eintraege nie aendern
8. **Sprache: Deutsch** — alle Ausgaben und Synthesen auf Deutsch (Schweizer Hochdeutsch, ss statt ß)
9. **Frontmatter Pflicht:** `layer: curated`, `date`, `source: claude`, `chat_url`, `related` bei Synthesen

## Verwendung im Quartal

Empfohlener Rhythmus: einmal pro Quartal pro aktivem Themen-Cluster. Trigger sind
Lint-Reports (volle Inbox, viele neue Daily-Note-Eintraege im gleichen Tag-Bereich)
oder ein expliziter Nutzer-Wunsch.

## Hintergrund

Standortbestimmung im Vault: `04 Ressourcen/Wissensmanagement/2026-06-13 Kuratierung im KI-Zeitalter.md`
