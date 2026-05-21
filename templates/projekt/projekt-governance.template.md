> # Projekt-Governance — Template
> Kopiere diese Datei in `~/Obsidian/SecondBrain/02 Projekte/<dein-projekt>/`
> und benenne sie um in `Projekt-Governance.md`. Befuelle dann die Platzhalter.
> Original-Repo: https://github.com/vibercoder79/secondbrain-setup

---
type: governance
project: "[[<Projektname>]]"
language: de                 # de | en
backlog_tool: none           # linear | teams-kanban | github-issues | jira | notion | none
backlog_url: ""
backlog_filter: ""
backlog_id_prefix: ""
risk_register: disabled      # enabled | disabled
financials_tool: none        # excel | accounting-tool | stripe | none
financials_url: ""
pipeline_workflow_id: ""     # n8n-Workflow-ID wenn aktiv, sonst leer
erstellt: <JJJJ-MM-TT>
aktualisiert: <JJJJ-MM-TT>
source: claude
chat_url: unbekannt
---

# Projekt-Governance — <Projektname>

> Tool-Stack und Konventionen fuer dieses Projekt. Single Source of Truth fuer Claude bei allen Backlog-/Risk-/Financials-Aktionen.

## Tool-Stack

| Funktion | Tool | URL / Pfad |
|----------|------|-----------|
| Backlog | Linear / Teams-Kanban / none | https://... |
| Code | GitHub | https://github.com/... |
| Kommunikation | Slack / Teams / Mail | #channel |
| Risk-Register | Obsidian Risks/ (wenn enabled) / extern | — |
| Financials | Excel / Accounting / none | Pfad oder URL |
| Doku | Obsidian | dieses Vault |

## Backlog-Konvention

> Nur ausfuellen wenn `backlog_tool != none`.

- **Project / Board:** ...
- **Labels:** `meeting-action`, `decision`, `risk-mitigation`, `feature`, `bug`
- **ID-Prefix:** ...
- **Owner:** @...

## Workflows

### Meeting Action Items uebertragen
Trigger-Saetze: "uebertrag Action Items", "leg Tasks aus Meeting an"
1. Lies neueste Datei in `Meetings/`
2. Extrahiere offene Checkboxes als Tasks
3. Lege im Backlog-Tool an mit Label `meeting-action`
4. Schreib Issue-IDs zurueck ins Meeting-File: `- [ ] Aufgabe @Person → [PROJ-142](url)`

### Decision in User Story uebersetzen
Trigger-Saetze: "leg User Story aus letzter Decision an"
1. Lies neueste Datei in `Decisions/`
2. Wenn technische Konsequenzen → Tasks im Backlog-Tool anlegen mit Label `decision`
3. Trage Issue-IDs in `backlog_issues` der Decision-Datei ein

### Risk-Mitigation in Backlog uebertragen
> Nur wenn `risk_register: enabled` und `backlog_tool != none`.
Trigger-Satz: "leg Mitigations aus Risiko XYZ an"
1. Lies Risk-File in `Risks/`
2. Extrahiere Mitigation-Liste
3. Lege im Backlog-Tool an mit Label `risk-mitigation`
4. Trage Issue-IDs in `backlog_issues` der Risk-Datei ein

### Status-Sync (manuell auf Anfrage)
Trigger-Satz: "sync den Backlog-Status"
- Lies Backlog-Tool
- Hake erledigte Action Items in den Meeting-Files ab
- Markiere geschlossene Decisions als `entschieden`

## Verantwortliche

- Owner: @...
- Stakeholder: ...
