> # Projekt-Anlegen Workflow — Template
> Diese Datei gehoert in `~/Obsidian/SecondBrain/00 Kontext/Workflows/Projekt-Anlegen.md`.
> Sie ist Teil des SecondBrain-Setup-Templates. Original-Repo:
> https://github.com/vibercoder79/secondbrain-setup

---
tags: [workflow, projekt, secondbrain, ki-agnostisch]
zweck: methodik fuer projekt-anlage im secondbrain
gilt-fuer: alle KIs mit vault-zugriff (Claude, Gemini, ...)
quelle: destilliert aus skill projekt-init v1.1.1
aktualisiert: 2026-04-29
---

# Workflow: Projekt anlegen

Single Source of Truth fuer die Methodik. Diese Datei beschreibt **was** zu tun ist —
nicht **wie** es technisch automatisiert wird. Die Automatisierung (Skill, Script,
manueller Ablauf) haengt von der jeweiligen KI ab.

## Trigger

- "neues Projekt"
- "lege ein Projekt an"
- "erstelle ein Projekt fuer ..."
- "/projekt-init" (Claude-Skill-Slash-Command)

## Vault-Struktur

| Element | Pfad |
|---------|------|
| Vault-Wurzel | `~/Obsidian/SecondBrain/` |
| Projekt-Wurzel | `02 Projekte/<Projektname>/` |
| Templates DE | `00 Kontext/Projekt-Struktur.md` |
| Templates EN | `00 Kontext/Projekt-Struktur.en.md` |
| User-Story-Template DE | `00 Kontext/User-Story-Template.md` |
| User-Story-Template EN | `00 Kontext/User-Story-Template.en.md` |

Templates IMMER aus `Projekt-Struktur.md` lesen — nicht woanders kopiert halten.

## Phase 0: Onboarding-Fragen

Diesen Block als **eine** Message stellen — niemals einzeln fragen.

```
Bevor ich das Projekt anlege, brauche ich kurz Kontext:

PFLICHT:
0. Projekt-Sprache?
   a) Deutsch (default)
   b) Englisch
1. Projektname?
2. Ein-Satz-Beschreibung (worum geht es)?
3. Konkretes Ziel / gewuenschter Endzustand?
4. Projekt-Typ?
   a) Software / Entwicklung
   b) Beratung / Kundenprojekt
   c) Marketing / Content
   d) Persoenlich / Lernen
   e) Anderes
5. Stakeholder / Kunde? (intern / Name extern)
6. Backlog-Tool?
   a) Linear (empfohlen fuer Software)
   b) Teams-Kanban / M365 (empfohlen fuer Beratung)
   c) GitHub Issues
   d) noch nicht entschieden → none

OPTIONAL (leer lassen ist ok):
7. GitHub-Repo-URL (falls Code)?
8. Risk-Tracking aktivieren? (default: nein)
9. Financials-Tracking aktivieren? (default: nein)
```

### Sprach-Logik (Frage 0)

| Antwort | Template-Quelle | Frontmatter | Inhalts-Sprache | User-Story-Template |
|---------|-----------------|-------------|-----------------|---------------------|
| `a` Deutsch (default) | `[[Projekt-Struktur]]` | `language: de`, `status: aktiv`, `phase: konzeption` | Deutsch | `[[User-Story-Template]]` |
| `b` Englisch | `[[Projekt-Struktur.en]]` | `language: en`, `status: active`, `phase: discovery` | Englisch | `[[User-Story-Template.en]]` |

Datei- und Ordnernamen bleiben in beiden Sprachen GLEICH (Whitelist) — nur der **Inhalt** ist uebersetzt.

### Antworten parsen

- Format flexibel: nummerierte Liste oder Fliesstext
- Wenn Antwort fehlt oder unklar: Default aus Sektion "Defaults pro Projekt-Typ" verwenden, in der Zusammenfassung erwaehnen
- Nicht nochmal nachfragen

### Spezialfall: "Standard" / "ohne Fragen" / "default" / "schnell"

→ Onboarding ueberspringen, Defaults verwenden, NUR Projektname erfragen.

### Spezialfall: Kontext-Hinweise im Trigger

Wenn der Nutzer beim Trigger schon Kontext gibt (z.B. *"lege ein Projekt fuer das Web-Redesign an"*):
→ Hinweise als Default fuer Frage 1, 2, 5 verwenden, vorbefuellte Werte zur Bestaetigung zeigen, nur fehlende Fragen explizit stellen.

## Phase 1: Validierung

```bash
test -d "~/Obsidian/SecondBrain/02 Projekte/<Projektname>"
```

Bei Konflikt: Vorschlag fuer alternativen Namen (Suffix oder Praefix).

**Tags und `related: [[...]]` aus Kontext ableiten:**
- "Beispiel-Programm-Projekt" → tag `beispiel-programm`, related `[[Beispiel-Programm]]`
- Default-Tags pro Typ: siehe "Defaults pro Projekt-Typ" weiter unten
- Mutter-Projekt im `related`-Feld via Wikilink, vorher pruefen ob die Datei existiert

## Phase 2: Backlog-Setup

Je nach Antwort auf Frage 6:

| Tool | Workflow |
|------|----------|
| `linear` | Bei Claude: MCP-Discovery + Auto-Create-Fallback. Bei Gemini/anderen KIs: User-Input fuer Linear-Project-URL und ID-Praefix. |
| `teams-kanban` (M365) | Bei Claude: MCP-Discovery (Tool-Namen zur Laufzeit). Bei Gemini/anderen: User-Input fuer Plan-URL/Bucket. |
| `github-issues` | Bei Claude: `gh` CLI. Bei Gemini/anderen: User-Input fuer Repo-URL. |
| `notion` | User-Input (kein MCP standardisiert) |
| `none` | Hub bekommt "Pre-Backlog Action Items" Sektion, kein Discovery |

**Graceful Degradation:** Bei Tool-Fehler (Auth etc.) → User-Input mit Link, nie hart fehlschlagen.

**Auto-Create:** NIE ohne expliziten "Ja" anlegen. Immer bestaetigen lassen.

## Phase 3: Ordnerstruktur

```bash
PROJ="~/Obsidian/SecondBrain/02 Projekte/<Projektname>"
mkdir -p "$PROJ/Meetings" "$PROJ/Decisions" "$PROJ/Research" "$PROJ/assets"
```

- Wenn Antwort 8 = ja (Risk-Tracking): zusaetzlich `mkdir -p "$PROJ/Risks"`
- Wenn Antwort 9 != none (Financials): kein Ordner, nur Datei (siehe Phase 5)

## Phase 4: Templates befuellen

Templates aus [`Projekt-Struktur.md`](../Projekt-Struktur.md) (oder `.en.md`) lesen
und mit **echten Werten** aus Phase 0 befuellen — KEINE Platzhalter wie `"Was ist das Projekt?"`.

**Pflicht-Dateien:**

1. `<Projektname> - PMO HUB.md` — Hub mit:
   - `tags`, `status: aktiv`, `phase: konzeption`, `erstellt: <heute>`, `aktualisiert: <heute>`
   - `governance: "[[Projekt-Governance]]"`, `related` aus Kontext
   - Einzeiler aus Antwort 2, Projektziel aus Antwort 3
   - Stack-Sektion nur wenn Software (Antwort 4a)
   - Repo-Sektion nur wenn Antwort 7 ausgefuellt
   - Dataview-Bloecke fuer Decisions, Action Items, (Top-Risiken wenn aktiv)
   - Backlog-Sektion: Link zu Tool oder "Pre-Backlog Action Items" wenn `none`

2. `Projekt-Governance.md` — Governance mit:
   - `backlog_tool`, `backlog_url`, `backlog_filter`, `backlog_id_prefix` aus Phase 2
   - `risk_register: enabled|disabled` aus Antwort 8
   - `financials_tool`, `financials_url` aus Antwort 9
   - Owner aus Antwort 5

## Phase 5: Opt-ins anwenden

**Wenn `risk_register: enabled`:**
- `Risks/` Ordner ist bereits angelegt (Phase 3)
- Im Hub: Top-Risiken-Block aktiv lassen (sonst entfernen)

**Wenn `financials_tool != none`:**
- `Financials.md` mit Template aus Projekt-Struktur anlegen
- `financials_tool`, `financials_url`, `budget_total` (wenn vom Nutzer angegeben) befuellen
- Im Hub: Verweis auf `[[Financials]]` ergaenzen

## Phase 6: Verifikation + Zusammenfassung

**Verifikation:**
- Whitelist-Check: nur erlaubte Files im Wurzel
- Pflicht-Dateien existieren (PMO HUB, Governance)
- Wikilinks im Hub valide (Pfade existieren)
- Dataview-Syntax ok (Code-Bloecke korrekt geoeffnet/geschlossen)

**Zusammenfassung-Schema:**

```
Projekt "[Projektname]" angelegt.

Struktur:
  - <Projektname> - PMO HUB.md       (Landing Page)
  - Projekt-Governance.md            (Tool-Stack)
  - Meetings/, Decisions/, Research/, assets/  (leer)
  [- Risks/                          (leer, opt-in aktiv)]
  [- Financials.md                   (Budget-Template, opt-in aktiv)]

Backlog:
  - Tool: <Linear/M365/GitHub/none>
  - URL: <url-oder-pre-backlog>
  [- Linear-Project ID: <id>         (auto-created)]

Naechste Schritte:
  1. Erstes Meeting? (lege Meeting in Meetings/ an)
  2. [Backlog-Tool URL ausfuellen falls leer]
  3. Erste Entscheidung dokumentieren? ("neue Decision")
```

## Defaults pro Projekt-Typ

Verwendet wenn Antworten leer bleiben oder "Standard" gesagt wurde.

| Projekt-Typ | Backlog | Risks | Financials | Default-Tags |
|-------------|---------|-------|------------|--------------|
| **Software / Entwicklung** | Linear | nein | nein | `[entwicklung, software]` |
| **Beratung / Kundenprojekt** | Teams-Kanban | **ja** | **ja** | `[beratung, kunde]` |
| **Marketing / Content** | none oder Notion | nein | optional | `[marketing, content]` |
| **Persoenlich / Lernen** | none | nein | nein | `[lernen, persoenlich]` |
| **Anderes** | none | nein | nein | `[]` (leer, vom Nutzer ergaenzen) |

### Begruendung

- **Software → Linear:** Standard-Backlog fuer Entwicklungs-Projekte
- **Beratung → Teams-Kanban (M365):** Beratungs-Kunden arbeiten ueblicherweise im M365-Stack. Risks und Financials sind kritisch (Liability, Budget)
- **Marketing/Content → none/Notion:** Tasks oft kreativ, schwer in starres Backlog zu pflegen
- **Persoenlich → none:** Kein Tool-Overhead fuer private Projekte

### Default-Frontmatter

**Hub-Datei:**
```yaml
---
tags: <typ-defaults>
status: aktiv
phase: konzeption
erstellt: <heute YYYY-MM-DD>
aktualisiert: <heute YYYY-MM-DD>
source: <claude|gemini|...>
chat_url: unbekannt
governance: "[[Projekt-Governance]]"
related: <abgeleitet aus Kontext>
---
```

**Projekt-Governance:**
```yaml
---
type: governance
project: "[[<Projektname>]]"
backlog_tool: <gemaess Default-Matrix>
backlog_url: ""
backlog_filter: ""
backlog_id_prefix: ""
risk_register: <enabled wenn Default ja, sonst disabled>
financials_tool: <gemaess Default-Matrix oder none>
financials_url: ""
pipeline_workflow_id: ""
erstellt: <heute>
aktualisiert: <heute>
source: <claude|gemini|...>
chat_url: unbekannt
---
```

### Sonderfaelle

**Projekt-Typ "Anderes":**
- Backlog: `none`, Risks/Financials: disabled
- Tags leer lassen — Nutzer ergaenzt manuell
- In Zusammenfassung anmerken: *"Tags und Backlog-Tool habe ich offen gelassen — bitte ergaenzen"*

**Projekt-Typ "Beratung" + externer Kundenname:**
- `related: ["[[<Kundenname>]]"]` — pruefen ob Notiz existiert
- Wenn nicht: in Zusammenfassung vorschlagen *"Soll ich eine Kundenseite [[<Kundenname>]] anlegen?"*

## Regeln

1. **Templates IMMER aus Projekt-Struktur.md lesen** — nicht im Workflow oder Skill kopiert halten
2. **Onboarding ist Pflicht** — Ausnahme: explizit "Standard"
3. **Echte Werte einsetzen** — keine Platzhalter wie `"..."` stehen lassen
4. **Tool-Fehler graceful** — bei MCP-/CLI-Fehler immer User-Input-Fallback
5. **Bestaetigen vor Auto-Create** — Linear/M365 Project nie ohne expliziten "Ja"
6. **Sprache:** gemaess Frage 0 (Default Deutsch)

## Hinweise pro KI

**Claude (mit `projekt-init` Skill):**
- Voller Workflow automatisiert via Skill, MCP-Discovery, Scripts
- Trigger via Slash-Command `/projekt-init` oder Trigger-Phrasen

**Gemini (manuell):**
- Workflow manuell nachfahren mit Bash + Write-Tools
- MCP-Discovery nicht verfuegbar → User-Input fuer Backlog-URLs
- Frontmatter-Feld `source: gemini` setzen
