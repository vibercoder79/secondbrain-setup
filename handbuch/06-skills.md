# 06 — Skills: projekt-init, lint, ingest im Detail

> Kurzfassung: Drei Vault-zentrische Claude Code Skills. `projekt-init` legt neue
> Projekte sauber an. `lint` haelt das Vault gesund. `ingest` vernetzt neue Notizen
> mit dem Bestand. Zusammen setzen sie Karpathys LLM-Wiki-Pattern um.

## Was sind Skills?

Skills sind Claude-Code-eigene Erweiterungen — Slash-Commands mit eigenem Workflow
und Tool-Set. Sie liegen unter `~/.claude/skills/<name>/` und bestehen mindestens
aus einer `SKILL.md` mit Frontmatter:

```yaml
---
name: projekt-init
description: ...
version: 1.2.0
user-invocable: true
allowed-tools: [Read, Edit, Write, Bash, Glob, Grep, AskUserQuestion]
---
```

Wenn du einen Skill aufrufst (`/projekt-init` oder via Trigger-Satz "lege ein
Projekt an"), liest Claude die `SKILL.md` als Workflow-Anleitung und fuehrt sie aus.

In diesem Repo: `skills/projekt-init/`, `skills/lint/`, `skills/ingest/`.

## Skill 1: `/projekt-init` — Projekt anlegen

**Trigger:** "lege ein Projekt an", "neues Projekt", "Projekt anlegen", "erstelle
ein Projekt fuer ...", oder `/projekt-init` explizit.

### Was er tut

Orchestriert das saubere Anlegen eines neuen Projekts im Vault:

1. **Phase 0 — Onboarding** (10 Fragen in einem Block, siehe Kapitel 05)
2. **Phase 1 — Validierung** (Ordner-Konflikt? Tags ableiten?)
3. **Phase 2 — Backlog-Discovery** (Linear via MCP, Teams via M365-MCP, GitHub via gh CLI, oder none)
4. **Phase 3 — Ordnerstruktur anlegen** (gemaess Whitelist: Meetings/, Decisions/, Research/, assets/)
5. **Phase 4 — Templates befuellen** (PMO HUB + Projekt-Governance mit echten Werten)
6. **Phase 5 — Opt-ins anwenden** (Risk-Tracking? Financials?)
7. **Phase 6 — Verifikation** (Whitelist-Check, Wikilinks valide, Dataview-Syntax)

### Methodik-Trennung

Die **Methodik** (die 10 Fragen, Defaults, Sprach-Logik) liegt KI-agnostisch im
Vault: `00 Kontext/Workflows/Projekt-Anlegen.md`. Andere KIs (Gemini, Codex) lesen
dieselbe Datei und fahren den Workflow manuell durch.

Die **Automation** (MCP-Discovery, Auto-Create) lebt im Skill — sie ist
Claude-Code-spezifisch (weil nur Claude Code MCP-Server fuer Linear/M365 hat).

### Backlog-Tool-Discovery

Je nach Antwort auf Frage 6:

| Tool | Workflow |
| ---- | -------- |
| `linear` | Linear MCP: `list_projects`, Auto-Create mit Bestaetigung, Labels anlegen |
| `teams-kanban` (M365) | M365 MCP, analog. Tool-Namen zur Laufzeit ermittelt |
| `github-issues` | `gh` CLI, Repo-Validation, Label-Setup |
| `notion` | User-Input (kein MCP konfiguriert in Default-Setup) |
| `none` | Hub bekommt "Pre-Backlog Action Items"-Sektion |

**Graceful Degradation:** Wenn MCP-Tool nicht antwortet (Auth-Fehler etc.) →
User-Input mit Link, kein hartes Fehlschlagen.

### Wie der Skill verhindert was schiefgehen kann

Erfahrungswerte aus Tobias' Vault, die in den Skill eingeflossen sind:

- **Kein `README.md` im Projektwurzel** (Whitelist-Verstoss) — der Hub ist die Landing Page
- **Keine Einzeldatei-Projekte** — immer Ordner mit Hub + Subordnern
- **`Projekt-Governance.md` ist Pflicht** — Tool-Stack und Backlog-Anbindung pro Projekt
- **Hub-Datei MUSS auf `- PMO HUB.md` enden** — wegen Naming-Konvention fuer Wikilinks
- **Default `backlog_tool: none`** wenn nicht explizit gewaehlt

### Versionshistorie

| Version | Aenderungen |
| ------- | ----------- |
| 1.2.0 | References zu Stubs umgebaut, Vault-Methodik wird Quelle der Wahrheit |
| 1.1.x  | Mehrsprachigkeit (DE/EN), Sprach-Wahl als Frage 0 |
| 1.0.0  | Initial: 7-Phasen-Workflow, Backlog-Hybrid-Strategie |

### Details

→ [`skills/projekt-init/SKILL.md`](../skills/projekt-init/SKILL.md)
→ [`skills/projekt-init/README.md`](../skills/projekt-init/README.md)

## Skill 2: `/lint` — Vault-Health-Check

**Trigger:** "lint", "vault check", "pruefe das vault", "gesundheitscheck",
"verwaiste notizen", "orphans", "projekt-compliance", oder `/lint` explizit.

### Was er tut

Pruefe das gesamte Vault auf Hygiene, Drift und Konventions-Verstoesse:

1. **Verwaiste Notizen finden** — Glob alle `*.md`, fuer jede pruefen ob mind. ein
   `[[Wikilink]]` darauf zeigt. Ausnahmen: Daily Notes, `00 Kontext/`, `CLAUDE.md`,
   Start-Dateien.
2. **Fehlende Verknuepfungen vorschlagen** — Themen-Matching zwischen Notizen, pro
   Vorschlag einzeln bestaetigen.
3. **Vault-Hygiene** — Inbox-Stand, abgeschlossene-Projekte-Kandidaten,
   Frontmatter-Check, Synthese-Seiten-Pflicht.
4. **Projekt-Compliance** — gegen die Governance aus
   `00 Kontext/Projekt-Struktur.md`:
   - Whitelist Projektwurzel (nur PMO HUB, Governance, Financials erlaubt)
   - `README.md` im Wurzel verboten
   - Pflicht-Dateien existieren
   - Naming-Konvention `* - PMO HUB.md`
   - Kaputte Wikilinks im PMO HUB
   - Decisions-Frontmatter-Konsistenz (`status` ↔ `entschieden_am`)
   - Pre-Backlog-Items aelter als 30 Tage
5. **Report erstellen** — `01 Inbox/YYYY-MM-DD Vault Lint Report.md`,
   Log-Eintrag in `log.md`.
6. **Vault-Index regenerieren** — `Index.md` als Wiki-Cover (siehe Kapitel 05).

### Container-Ordner-Logik

Wenn ein Projektordner mit Underscore beginnt (z.B. `_KUNDEN/`), wird er als
**Container** behandelt — Sammelordner fuer Sub-Projekte. Der Container selbst
hat keinen PMO HUB; stattdessen wird jeder direkte Sub-Ordner als eigenes Projekt
geprueft.

### Wichtige Regeln

- **IMMER fragen** bevor Notizen veraendert werden
- **NIE loeschen** — bestehende Inhalte werden nur ergaenzt
- **07 Anhaenge/ komplett ignorieren** — keine Bilder/PDFs durchsuchen
- **Daily Notes sind keine Orphans** — sie stehen fuer sich
- **Log ist append-only** — nie bestehende Eintraege aendern
- **Index.md ist atomar** — komplett ueberschreiben, keine inkrementellen Edits

### Teilmodi

| Aufruf | Verhalten |
| ------ | --------- |
| `/lint` | Vollstaendiger Check (alle 6 Schritte) |
| `/lint orphans` | Nur Schritt 1 |
| `/lint inbox` | Nur Inbox-Check von Schritt 3 |
| `/lint projekte` | Nur Schritt 4 |
| `/lint index` | Nur Schritt 6 (Index regenerieren) |

### Versionshistorie

| Version | Aenderungen |
| ------- | ----------- |
| 1.3.x | Index-Regenerierung (Karpathy LLM-Wiki-Cover) |
| 1.2.x | Projekt-Compliance-Sektion |
| 1.1.x | Frontmatter-Description erweitert |
| 1.0.0 | Initial: 4-Phasen-Workflow |

### Details

→ [`skills/lint/SKILL.md`](../skills/lint/SKILL.md)
→ [`skills/lint/README.md`](../skills/lint/README.md)

## Skill 3: `/ingest` — Notizen vernetzen

**Trigger:** `/ingest "<Notiz-Titel>"` oder "vernetze diese Notiz", "ingest das",
"link das im Vault".

### Was er tut

Verarbeitet eine einzelne neue Notiz und integriert sie in den Bestand:

1. **Vault durchsuchen** — Themen-Extraktion aus der neuen Notiz, Suche nach
   bestehenden Notizen mit Themen-Ueberschneidung.
2. **Wikilinks setzen** — **bidirektional**:
   - In der neuen Notiz: Wikilinks zu den thematisch verwandten Notizen
   - In den verwandten Notizen: Wikilink zurueck zur neuen Notiz
3. **Synthese-Seite aktualisieren** — die Start-Datei des thematischen Ordners
   (z.B. `04 Ressourcen/Cybersecurity/Cybersecurity.md`) bekommt einen neuen Absatz
   oder eine neue Sektion mit der Erkenntnis aus der neuen Notiz.
4. **log.md** ergaenzen — Chronologie-Eintrag.

### Warum kein Hook

Ein Hook auf jeden File-Edit waere:

- **Zu teuer** — bei 1247 Notizen waere bei jedem Edit eine LLM-Analyse fuellig
- **Zu laut** — Synthese-Seiten wuerden bei jedem trivialen Edit aktualisiert
- **Zu autonom** — du verlierst Kontrolle wann was verarbeitet wird

Stattdessen: **manueller Aufruf**. Du entscheidest welche Notiz wertvoll genug
ist fuer eine Vernetzung.

### Variante B — bestehende Start-Dateien als Synthese-Seiten

Statt einen neuen `wiki/` Ordner anzulegen, nutzt Ingest die bestehenden
**Start-Dateien** in `04 Ressourcen/` als Synthese-Seiten. Jeder Themenordner
hat eine gleichnamige Start-Datei (`04 Ressourcen/Gemini/Gemini.md`,
`04 Ressourcen/Claude Code/Claude Code.md`). Diese Dateien sind die lebenden
Wiki-Knoten.

Vorteile:

- Kein neues System parallel zur bestehenden Struktur
- Start-Dateien sind sowieso schon Konvention (siehe Kapitel 03)
- `/lint` prueft, dass jeder Themenordner eine Start-Datei hat

### Details

→ [`skills/ingest/SKILL.md`](../skills/ingest/SKILL.md)
→ [`skills/ingest/README.md`](../skills/ingest/README.md)

## Zusammenspiel: Karpathy in Praxis

Die drei Skills setzen Karpathys [LLM-Wiki-Pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
um:

| Karpathy-Operation | Dieses Setup |
| ------------------ | ------------ |
| **Ingest** — neue Quelle verarbeiten | `/ingest <Notiz>` |
| **Query** — Wiki durchsuchen, Antworten synthetisieren | Wikilinks in Notizen + Synthese-Seiten ermoeglichen Token-effiziente Queries |
| **Lint** — Gesundheitschecks | `/lint` (woechentlich oder auf Bedarf) |

Plus das Anlege-Pattern fuer Projekte:

| Pattern | Dieses Setup |
| ------- | ------------ |
| Strukturierte, schema-konforme Anlage | `/projekt-init` mit Onboarding + Verifikation |

## Skills installieren

Voraussetzung: Claude Code installiert.

```bash
# Aus diesem Repo
cp -r ~/Documents/GitHub/secondbrain-setup/skills/projekt-init ~/.claude/skills/
cp -r ~/Documents/GitHub/secondbrain-setup/skills/lint ~/.claude/skills/
cp -r ~/Documents/GitHub/secondbrain-setup/skills/ingest ~/.claude/skills/
```

Verifikation:

```bash
ls ~/.claude/skills/
# projekt-init  lint  ingest
```

In Claude Code: `/projekt-init` — wenn der Trigger erkannt wird, ist alles
installiert.

## Eigene Skills bauen

Wenn du eigene Skills bauen willst (gleicher Lifecycle: lokal entwickeln → GitHub
publishen → SecondBrain dokumentieren), schau in den `skill-creator`-Skill aus
Tobias' Hauptrepo `vibercoder79/claudecodeskills`. Dort sind die Konventionen,
das Publish-Script und der Skill-Lifecycle-Workflow dokumentiert.

## Naechstes Kapitel

→ [07 — Anpassen: Eigene Pfade, eigene Tools, Migration](07-anpassen.md)
