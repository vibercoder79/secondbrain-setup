# projekt-init

> Orchestriert das Anlegen eines neuen Projekts im SecondBrain Obsidian Vault — mit
> Onboarding-Dialog, automatischer Ordnerstruktur und intelligentem Backlog-Tool-Anschluss
> (Linear, M365 Teams-Kanban, GitHub Issues).

## Was der Skill loest

Beim Anlegen eines neuen Projekts im SecondBrain mussten bisher viele Schritte
manuell erledigt werden: Ordnerstruktur, Hub-Datei, Governance-Datei, Templates,
Backlog-Tool-Verknuepfung, Risk- und Financials-Setup. Bei jedem Anlegen bestand
das Risiko, etwas zu vergessen oder die File-Whitelist zu verletzen.

`projekt-init` automatisiert das vollstaendig:
- Onboarding-Dialog (9 Fragen) sammelt den Kontext
- Ordnerstruktur wird gemaess Whitelist angelegt
- Templates aus `Projekt-Struktur.md` werden mit echten Werten gefuellt
- Backlog-Tool wird intelligent verknuepft (Discovery via MCP, Auto-Create mit Bestaetigung, User-Input als Fallback)
- Verifikation prueft Compliance vor der Zusammenfassung

## Installation

Der Skill liegt unter `~/.claude/skills/projekt-init/` und wird automatisch von Claude Code geladen.

```bash
cp -r ~/Documents/GitHub/secondbrain-setup/skills/projekt-init ~/.claude/skills/projekt-init
```

## Nutzung

### Trigger-Saetze

Claude erkennt diese Saetze automatisch:

- "lege ein Projekt an"
- "neues Projekt"
- "Projekt anlegen"
- "erstelle ein Projekt fuer..."
- `/projekt-init` (expliziter Slash-Command)

### Schnell-Modus (Onboarding ueberspringen)

Beim Trigger den Zusatz "Standard" oder "ohne Fragen" angeben:

```
/projekt-init Standard
neues Projekt ohne Fragen
```

→ Claude verwendet Defaults aus `references/defaults-pro-typ.md`. Nur den Projektnamen
muss er erfragen.

## Modi und Features

### Phase 0: Onboarding-Dialog

9 Fragen, alle in einem Block:
1. Projektname?
2. Ein-Satz-Beschreibung?
3. Konkretes Ziel?
4. Projekt-Typ? (Software / Beratung / Marketing / Persoenlich / Anderes)
5. Stakeholder / Kunde?
6. Backlog-Tool? (Linear / Teams-Kanban / GitHub / none)
7. GitHub-Repo-URL? (optional)
8. Risk-Tracking aktivieren? (default: nein)
9. Financials-Tracking aktivieren? (default: nein)

### Phase 2: Backlog-Tool-Anschluss (Hybrid-Strategie)

Je nach gewaehltem Tool:

- **Linear:** Discovery via Linear MCP (`list_projects`), Auto-Create mit Bestaetigung, Labels (`meeting-action`, `decision`, `risk-mitigation`) automatisch anlegen
- **M365 / Teams-Kanban:** Discovery via M365 MCP (`@softeria/ms-365-mcp-server`, `--org-mode`), analoges Pattern. Tool-Namen werden zur Laufzeit ermittelt
- **GitHub Issues:** Via `gh` CLI, Repo-Validation, Label-Setup
- **none:** Hub bekommt "Pre-Backlog Action Items" Sektion

**Graceful Degradation:** MCP nicht verfuegbar → User-Input mit Link.

### Phase 3-5: Anlegen und Befuellen

- Ordnerstruktur gemaess Whitelist (`Meetings/`, `Decisions/`, `Research/`, `assets/`)
- PMO HUB mit Live-Dataview-Sichten
- `Projekt-Governance.md` mit Tool-Stack
- Opt-in: `Risks/` und `Top-Risiken`-Block bei `risk_register: enabled`
- Opt-in: `Financials.md` bei `financials_tool != none`

### Phase 6: Verifikation

- Whitelist-Check (keine ungeladenen Files im Wurzel)
- Pflicht-Dateien existieren
- Wikilinks valide (zeigen auf existierende Notizen)
- Dataview-Bloecke korrekt
- Frontmatter komplett

## Hintergrund

Inspiriert vom OpenCLAW Bootstrap-Pattern (siehe https://github.com/vibercoder79/KI-Masterclass-Koerting-/tree/main/bootstrap),
das fuer Software-Entwicklungs-Projekte das gleiche Prinzip etabliert hat:
strukturierte Phasen, Onboarding-First, Templates statt Platzhalter,
maschinell erzwungene Compliance.

`projekt-init` adaptiert das Prinzip fuer den SecondBrain-Vault-Kontext: weniger
Software-Engineering-Last (kein Linter, keine Hooks), aber gleiche Disziplin bei
Struktur und Tool-Anbindung.

## Quellen

- **OpenCLAW Bootstrap:** https://github.com/vibercoder79/KI-Masterclass-Koerting-/tree/main/bootstrap
- **PARA Method:** Tiago Forte, Building a Second Brain
- **ADR-Pattern:** Michael Nygard, "Documenting Architecture Decisions" (2011)
- **PMI / PRINCE2 Risk Register:** Standard-PMO-Risk-Format
- **Dann Berg Meeting Template:** Inspiration fuer Meeting-Struktur

## Voraussetzungen

- Obsidian SecondBrain Vault unter `~/Obsidian/SecondBrain/`
- `Projekt-Struktur.md` als Single Source of Truth fuer Templates
- Optional: Linear MCP fuer Discovery
- Optional: M365 MCP fuer Teams-Kanban (`@softeria/ms-365-mcp-server`)
- Optional: `gh` CLI fuer GitHub Issues

## Dateistruktur

```
projekt-init/
├── SKILL.md                              <-- Hauptlogik (max 300 Zeilen)
├── README.md                             <-- diese Datei
├── projekt-init-overview.excalidraw      <-- Visuelles Big Picture
├── projekt-init-overview.png             <-- PNG-Render des Diagramms
└── references/
    ├── onboarding-fragen.md              <-- die 9 Fragen + Parsing
    ├── defaults-pro-typ.md               <-- Default-Tabelle pro Projekt-Typ
    ├── backlog-discovery-linear.md       <-- Linear-Discovery-Workflow
    ├── backlog-discovery-m365.md         <-- M365-Discovery (Tool-Discovery zur Laufzeit)
    └── verifikation-checks.md            <-- Whitelist + Wikilink + Dataview-Checks
```

## Verknuepfung mit anderen Skills

- **`lint`** (Vault-Health-Check) findet Compliance-Drift in bereits angelegten Projekten —
  `projekt-init` verhindert Drift beim Anlegen, `lint` findet ihn nachtraeglich
- **`ingest`** ist der Gegenspieler fuer einzelne Notizen — `projekt-init` ist fuer Projekte
- **`obsidian-markdown`** wird fuer die Markdown-Generierung verwendet
