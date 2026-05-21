# Lint Skill — SecondBrain Gesundheits-Check

Woechentlicher Vault-Check fuer das SecondBrain Obsidian Vault. Findet verwaiste Notizen, fehlende Verknuepfungen, Vault-Hygiene-Probleme, Projekt-Compliance-Drift — und regeneriert seit v1.3.0 das **Wiki-Cover** (`Index.md`) im Vault-Root.

**Der Kern:** Vorverarbeitung statt Echtzeit-Suche. Statt das Vault bei jeder Session neu zu durchsuchen, liest Claude die `Index.md` und hat sofort den Ueberblick (Karpathy LLM Wiki Pattern). Komplementaer zum [`ingest`](../ingest/) Skill: Ingest verarbeitet einzelne Notizen, Lint prueft das ganze Vault systematisch.

> Workflow-Diagramm: [`lint-overview.excalidraw`](lint-overview.excalidraw)

## Version

**v1.3.2** — siehe [Versionshistorie](#versionshistorie)

## Installation

```bash
cp -r ~/Documents/GitHub/secondbrain-setup/skills/lint ~/.claude/skills/lint
```

Pruefen ob es funktioniert:

```
/lint
```

## Nutzung

| Aufruf | Verhalten |
|--------|-----------|
| `/lint` | Vollstaendiger Vault-Check (alle 6 Schritte) |
| `/lint orphans` | Nur verwaiste Notizen suchen (Schritt 1) |
| `/lint inbox` | Nur Inbox pruefen (Teil von Schritt 3) |
| `/lint projekte` | Nur Projekt-Compliance (Schritt 4) |
| `/lint index` | Nur Vault-Index regenerieren (Schritt 6) |

Weitere Ausloeser: `lint`, `vault check`, `pruefe das vault`, `gesundheitscheck`, `verwaiste notizen`, `orphans`, `projekt-compliance`, `projekt-check`.

## Was der Skill tut (6 Schritte)

### 1. Verwaiste Notizen finden

Glob `**/*.md` im Vault, fuer jede Notiz pruefen ob sie per `[[Wikilink]]` referenziert wird. Daily Notes, `00 Kontext/`, `CLAUDE.md` und Synthese-Start-Dateien sind explizit ausgenommen.

### 2. Fehlende Verknuepfungen vorschlagen

Themen-Matching zwischen Notizen. Pro Vorschlag wird einzeln gefragt — kein Bulk-Apply.

### 3. Vault-Hygiene pruefen

- Inbox-Stand (Warnung > 5)
- Abgeschlossene Projekte als Archiv-Kandidaten
- Notizen ohne Frontmatter / Tags
- Synthese-Seiten pro Ressourcen-Ordner

### 4. Projekt-Compliance pruefen (seit v1.2.0)

Iteration ueber `02 Projekte/*/` gegen die Governance aus `00 Kontext/Projekt-Struktur.md`:

- Whitelist Projektwurzel (nur PMO HUB, Governance, Financials)
- `README.md` im Projektwurzel verboten
- Pflicht-Dateien existieren (`* - PMO HUB.md`, `Projekt-Governance.md`)
- Naming-Konvention `* - PMO HUB.md`
- Markdown in `*/Research/assets/` (sollte ein Level hoeher)
- Kaputte Wikilinks im PMO HUB
- Decisions-Frontmatter-Konsistenz
- Pre-Backlog-Items aelter als 30 Tage

### 5. Report erstellen und Log aktualisieren

Markdown-Report in `01 Inbox/YYYY-MM-DD Vault Lint Report.md` mit allen Findings, plus append-only Eintrag in `log.md`. Korrekturen werden einzeln angeboten, nichts wird automatisch geaendert.

### 6. Vault-Index regenerieren (seit v1.3.0)

Pre-kompilierte `Index.md` im Vault-Root als **Wiki-Cover**:

- Aktive Projekte (mit Status, Phase, letzte Aktualisierung)
- Bereiche (`03 Bereiche/`)
- Synthese-Seiten (`04 Ressourcen/`)
- Kontext-Dokumente (`00 Kontext/`)
- Letzte 5 Daily Notes
- Letzte 3 Lint-Reports
- Vault-Statistik

Statische Wikilinks (kein Dataview), bei jedem Lauf vollstaendig ueberschrieben — der Index ist immer ein Snapshot.

## Hintergrund: Warum dieser Skill?

### Das Problem

Das SecondBrain (PARA-Struktur) waechst organisch. Ohne regelmaessigen Check entstehen:

- Verwaiste Notizen ohne eingehende Links (Compound-Effekt verloren)
- Projekte die der Governance-Konvention nicht mehr folgen (Drift)
- Volle Inbox die nie aufgeraeumt wird
- Claude muss bei jeder Session das ganze Vault neu durchsuchen, weil es keinen Einstiegspunkt gibt

### Die Loesung

`lint` macht zwei Dinge:

1. **Findet Drift** — Konvention-Verstoesse werden sichtbar bevor sie sich aufstauen
2. **Erzeugt einen Einstiegspunkt fuer Claude** — `Index.md` im Vault-Root als vorkompiliertes Wiki-Cover

### Warum keine Dataview-Queries im Index?

Obsidian rendert Dataview im Editor, aber Claude liest die Markdown-Quelle. Dataview-Queries waeren fuer Claude leere Code-Bloecke. Statische Wikilinks bleiben lesbar — und bei jedem Lint-Lauf aktuell.

### Performance-Argument

| Ohne Index | Mit Index |
|-----------|-----------|
| Claude durchsucht das ganze Vault | Claude liest eine Seite |
| Tokens pro Session: hoch | Tokens pro Session: niedrig |
| Findet aktive Projekte per Glob | Hat alle aktiven Projekte sofort |
| Kein zentraler Einstieg | Vault-Cover als Karte |

## Regeln

1. **IMMER fragen** bevor Notizen veraendert werden
2. **NIE loeschen** — bestehende Inhalte werden nur ergaenzt
3. **07 Anhaenge/ komplett ignorieren** — keine Bilder/PDFs durchsuchen
4. **Daily Notes sind keine Orphans** — sie stehen fuer sich
5. **Report ist sachlich** — keine Wertungen, nur Fakten und Vorschlaege
6. **Log ist append-only** — nie bestehende Eintraege aendern
7. **Index.md ist atomar** — komplett ueberschreiben, keine inkrementellen Edits
8. **Sprache: Deutsch** — alle Ausgaben auf Deutsch

## Dateistruktur

```
lint/
├── SKILL.md                  <- Skill-Logik DE (Workflow, Regeln)
├── SKILL.en.md               <- Skill-Logik EN (Kurzfassung)
├── README.md                 <- Diese Datei
└── lint-overview.excalidraw  <- Workflow-Diagramm (Excalidraw-Quelle)
```

## Quellen

- [Karpathy LLM Wiki Gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — das Pattern hinter `Index.md`
- Komplementaerer Skill: [`ingest`](../ingest/) — verarbeitet einzelne Notizen

## Versionshistorie

| Version | Datum | Aenderungen |
|---------|-------|-------------|
| 1.3.2 | 2026-05-05 | Pfad-Sanitisierung fuer oeffentliches Repo |
| 1.3.1 | 2026-05-02 | README.md + Excalidraw-Diagramm nachgezogen |
| 1.3.0 | 2026-05-02 | Schritt 6: Vault-Index regenerieren — pre-kompilierte `Index.md` als Wiki-Cover |
| 1.2.1 | 2026-04-17 | Englische Doku nachgezogen (SKILL.en.md) |
| 1.2.0 | 2026-04-17 | Projekt-Compliance-Sektion (Schritt 4) |
| 1.1.0 | 2026-04-17 | Frontmatter-Description erweitert |
| 1.0.0 | 2026-04-15 | Initial release: 4-Phasen-Workflow |
