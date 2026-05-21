---
name: projekt-init
description: |
  Orchestriert das Anlegen eines neuen Projekts im SecondBrain Vault. Fuehrt durch
  Onboarding (9 Fragen), legt Ordnerstruktur und Templates an, integriert das
  Backlog-Tool (Linear/M365 via MCP-Discovery, GitHub Issues via gh CLI, oder none).
  Verwenden wenn der Nutzer "neues Projekt", "lege ein Projekt an", "Projekt anlegen",
  "erstelle ein Projekt fuer..." oder "/projekt-init" sagt.
version: 1.2.0
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

# Projekt-Init Skill — SecondBrain Projekt anlegen

Lege ein neues Projekt im SecondBrain Vault an. Onboarding-Dialog → Validierung →
Backlog-Discovery → Ordner anlegen → Templates befuellen → Verifikation.

## Methodik-Quelle (Single Source of Truth)

Die Methodik (Onboarding-Fragen, Sprach-Logik, Defaults pro Projekt-Typ, Frontmatter-Schemas)
liegt **KI-agnostisch im Vault** und wird sowohl vom Claude-Skill als auch von anderen KIs
(z.B. Gemini) genutzt:

**Pfad:** `~/Obsidian/SecondBrain/00 Kontext/Workflows/Projekt-Anlegen.md`

Dieser Skill liefert die **Automation** (MCP-Discovery, Scripts, Auto-Create) auf Basis dieser
Methodik. Die Skill-eigenen References `onboarding-fragen.md` und `defaults-pro-typ.md` sind
nur noch Stubs, die auf die Vault-Datei verweisen — niemals doppelt pflegen.

## Vault

- **Pfad:** `~/Obsidian/SecondBrain/`
- **Projekt-Wurzel:** `02 Projekte/<Projektname>/`
- **Templates DE:** `~/Obsidian/SecondBrain/00 Kontext/Projekt-Struktur.md`
- **Templates EN:** `~/Obsidian/SecondBrain/00 Kontext/Projekt-Struktur.en.md`
  (Single Source of Truth — IMMER von dort lesen, nie kopieren. Sprach-Wahl bestimmt welche Datei.)
- **User-Story-Template:** `00 Kontext/User-Story-Template.md` (DE) / `User-Story-Template.en.md` (EN)

## Aufruf

| Input | Verhalten |
|-------|-----------|
| `/projekt-init` | Vollstaendiger Workflow (alle 7 Phasen) |
| "neues Projekt" / "lege ein Projekt an" | Vollstaendiger Workflow |
| `/projekt-init Standard` | Onboarding ueberspringen, Defaults aus `references/defaults-pro-typ.md` |

## Workflow

### Phase 0: Onboarding-Dialog

Den 10-Fragen-Block aus der Vault-Methodik-Datei als 1 Message stellen
(Frage 0 ist die Sprach-Wahl, danach 1-9). Niemals einzeln fragen — alle auf einmal.

**Quelle (lesen):** `~/Obsidian/SecondBrain/00 Kontext/Workflows/Projekt-Anlegen.md`
Sektion "Phase 0: Onboarding-Fragen" enthaelt den exakten Frage-Block, die Sprach-Logik und alle Spezialfaelle.

Wenn der Nutzer "Standard" oder "ohne Fragen" sagt → Phase ueberspringen,
Defaults aus der Sektion "Defaults pro Projekt-Typ" derselben Datei verwenden, Sprache = Deutsch.

**Sprach-Wahl (Frage 0) bestimmt komplette Generierung:**
- Antwort `de` (default) → Templates aus `[[Projekt-Struktur]]`, Frontmatter `language: de`, alle Inhalte Deutsch
- Antwort `en` → Templates aus `[[Projekt-Struktur.en]]`, Frontmatter `language: en`, alle Inhalte Englisch

Datei- und Ordnernamen bleiben in beiden Sprachen GLEICH (Whitelist unveraendert).
Nur der Inhalt der Dateien ist uebersetzt. Details siehe Vault-Datei, Sektion "Sprach-Logik".

### Phase 1: Validierung

```bash
# Pruefen ob Ordner schon existiert
test -d "$HOME/Obsidian/SecondBrain/02 Projekte/<Projektname>"
```

Bei Konflikt: Vorschlag fuer alternativen Namen (mit Suffix oder Praefix).

Tags und `related: [[...]]` aus Kontext ableiten:
- Kunden- oder Container-Kontext im Trigger → tag passend ableiten (z.B. `kunde-x`), related `[[Kunde-X]]`
- Default-Tags pro Typ: siehe Vault-Methodik-Datei, Sektion "Defaults pro Projekt-Typ"

### Phase 2: Backlog-Discovery (Hybrid-Strategie)

Je nach `backlog_tool`-Antwort aus Phase 0 unterschiedlicher Workflow:

| Tool | Workflow | Reference |
|------|----------|-----------|
| `linear` | MCP-Discovery first, Auto-Create Fallback | `references/backlog-discovery-linear.md` |
| `teams-kanban` (M365) | MCP-Discovery first (Tool-Namen zur Laufzeit), Fallback User-Input | `references/backlog-discovery-m365.md` |
| `github-issues` | `gh` CLI (siehe `references/backlog-discovery-linear.md` Sektion gh) | — |
| `notion` | Aktuell User-Input (kein MCP konfiguriert) | — |
| `none` | Hub bekommt "Pre-Backlog Action Items" Sektion, kein Discovery | — |

**Graceful Degradation:** Wenn MCP-Tool nicht antwortet (Auth-Fehler etc.) → User-Input mit Link.

### Phase 3: Ordnerstruktur anlegen

Gemaess Whitelist aus `Projekt-Struktur.md`:

```bash
PROJ="$HOME/Obsidian/SecondBrain/02 Projekte/<Projektname>"
mkdir -p "$PROJ/Meetings" "$PROJ/Decisions" "$PROJ/Research" "$PROJ/assets"
```

Wenn Onboarding-Antwort 8 = ja (Risk-Tracking): `mkdir -p "$PROJ/Risks"`

Wenn Onboarding-Antwort 9 != none (Financials): kein Ordner, nur Datei (Phase 5).

### Phase 4: Templates befuellen

Lese die Templates aus `00 Kontext/Projekt-Struktur.md` und befuelle mit echten Werten
aus Phase 0 — KEINE Platzhalter wie "Was ist das Projekt?".

**Pflicht-Dateien:**
1. `<Projektname> - PMO HUB.md` — Hub-Template aus Projekt-Struktur, befuellt mit:
   - `tags`, `status: aktiv`, `phase: konzeption`, `erstellt: <heute>`, `aktualisiert: <heute>`
   - `governance: "[[Projekt-Governance]]"`, `related` aus Kontext
   - Einzeiler aus Antwort 2, Projektziel aus Antwort 3
   - Stack-Sektion nur wenn `Software` (Antwort 4a)
   - Repo-Sektion nur wenn Antwort 7 ausgefuellt
   - Dataview-Bloecke fuer Decisions, Action Items, (Top-Risiken wenn aktiv)
   - Backlog-Sektion mit Link zu Tool oder "Pre-Backlog Action Items" wenn `none`
2. `Projekt-Governance.md` — Governance-Template, befuellt mit:
   - `backlog_tool`, `backlog_url`, `backlog_filter`, `backlog_id_prefix` aus Phase 2
   - `risk_register: enabled|disabled` aus Antwort 8
   - `financials_tool`, `financials_url` aus Antwort 9
   - Owner aus Antwort 5

### Phase 5: Opt-ins anwenden

**Wenn `risk_register: enabled`:**
- `Risks/` Ordner ist bereits angelegt (Phase 3)
- Im Hub-Template: Top-Risiken-Block aktiv lassen (sonst entfernen)

**Wenn `financials_tool != none`:**
- `Financials.md` mit Template aus Projekt-Struktur anlegen
- `financials_tool`, `financials_url`, `budget_total` (wenn vom Nutzer angegeben) befuellen
- Im Hub: Verweis auf `[[Financials]]` ergaenzen

### Phase 6: Verifikation + Zusammenfassung

Pruefe gemaess `references/verifikation-checks.md`:
- Whitelist-Check: Nur erlaubte Files im Wurzel
- Pflicht-Dateien existieren (PMO HUB, Governance)
- Wikilinks im Hub valide (Pfade existieren)
- Dataview-Syntax ok (Code-Bloecke korrekt geoeffnet/geschlossen)

**Zusammenfassung ausgeben:**
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

## Regeln

1. **Templates IMMER aus Projekt-Struktur.md lesen** — nicht im Skill kopiert halten
2. **Onboarding ist Pflicht** — Ausnahme: Operator sagt explizit "Standard"
3. **Echte Werte einsetzen** — keine Platzhalter wie "..." stehen lassen
4. **MCP graceful** — bei MCP-Fehler immer User-Input-Fallback, nie hart fehlschlagen
5. **Bestaetigen vor Auto-Create** — Linear/M365 Project nie ohne expliziten "Ja" anlegen
6. **Sprache: Deutsch** — alle Ausgaben auf Deutsch

## Erweiterte Funktionen

**Methodik (KI-agnostisch, Vault-Single-Source-of-Truth):**
- **Onboarding-Fragen + Sprach-Logik + Spezialfaelle + Defaults pro Projekt-Typ:**
  `~/Obsidian/SecondBrain/00 Kontext/Workflows/Projekt-Anlegen.md`

**Skill-spezifische Automation (Claude-Code-only):**
- **Linear-Discovery-Workflow:** Siehe [references/backlog-discovery-linear.md](references/backlog-discovery-linear.md)
- **M365-Discovery-Workflow:** Siehe [references/backlog-discovery-m365.md](references/backlog-discovery-m365.md)
- **Verifikations-Checks:** Siehe [references/verifikation-checks.md](references/verifikation-checks.md)

Die References `onboarding-fragen.md` und `defaults-pro-typ.md` sind Stubs, die auf die
Vault-Methodik-Datei verweisen — keine inhaltliche Pflege mehr dort.
