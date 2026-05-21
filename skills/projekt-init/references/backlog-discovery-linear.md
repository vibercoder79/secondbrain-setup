# Backlog-Discovery: Linear (Hybrid-Strategie)

Wenn `backlog_tool: linear` aus Onboarding gewaehlt wurde.

## Linear MCP Tools

Server-ID: depends on local Linear MCP configuration (siehe `~/.claude/settings.json`).

| Tool | Zweck |
|------|-------|
| `list_projects` | Linear-Projekte listen, mit `query` filtern |
| `get_project` | Projekt-Details holen |
| `save_project` | Neues Projekt anlegen oder updaten |
| `list_teams` | Teams listen |
| `list_issue_labels` | Labels in Linear pruefen |
| `create_issue_label` | Label anlegen |
| `save_issue` | Issue anlegen |

## Workflow

### Schritt 1: MCP-Verfuegbarkeit pruefen

Test-Call `list_teams` mit `limit: 1`.
- **Erfolg:** Linear MCP aktiv → weiter zu Schritt 2
- **Fehler / Auth-Problem:** → User-Input-Fallback (Schritt 4)

### Schritt 2: Discovery

```
list_projects(query="<Projektname>", limit=5)
```

**Match-Auswertung:**

| Treffer | Aktion |
|---------|--------|
| 0 | Weiter zu Schritt 3 (Auto-Create-Angebot) |
| 1 | Nutzer fragen: "Ich habe Project '[Name]' (ID: [id]) gefunden. Soll ich verlinken? [j/n]" |
| 2-5 | Nutzer fragen: "Ich habe diese Projekte gefunden — welches passt? Liste anzeigen, ggf. neues anlegen?" |

Bei Verlinkung: Project-ID und URL in `Projekt-Governance.md` eintragen:
```yaml
backlog_tool: linear
backlog_url: https://linear.app/<workspace>/project/<slug>
backlog_filter: project:<id>
backlog_id_prefix: <team-key>-
```

### Schritt 3: Auto-Create-Angebot (bei kein Match)

Nutzer fragen:
```
Kein passendes Linear-Project gefunden.
Soll ich ein neues Project "[Projektname]" in Linear anlegen?
- Team: <Default-Team aus list_teams oder fragen>
- Description: <aus Onboarding-Antwort 2>
[j/n]
```

Bei **Ja:**
```
list_teams(limit=10) → Wenn nur 1 Team: nutzen. Sonst Nutzer fragen welches Team.

save_project({
  name: "<Projektname>",
  description: "<Onboarding-Antwort 2>",
  team: "<team-id>"
})
```

Project-ID in Governance eintragen.

**Labels anlegen** (falls nicht vorhanden):
- `meeting-action` (Farbe: blue)
- `decision` (Farbe: purple)
- `risk-mitigation` (Farbe: red, nur wenn risk_register: enabled)

```
list_issue_labels(team: <id>, query: "meeting-action")
→ wenn leer: create_issue_label({name: "meeting-action", color: "#0066cc", team: <id>})
```

Bei **Nein:** weiter zu Schritt 4 (User-Input).

### Schritt 4: User-Input-Fallback

```
Bitte gib die Linear-Project-URL ein (oder leer lassen — wir setzen "Pre-Backlog" im Hub):
```

User-Input-URL parsen, Project-ID extrahieren wenn moeglich (Pattern: `/project/<slug>`).
In Governance eintragen, kein MCP-Call.

## GitHub Issues (analoges Pattern)

Wenn `backlog_tool: github-issues`:
- `gh repo view <repo>` zur Validierung
- `gh label list` fuer Discovery existierender Labels
- `gh label create meeting-action --color 0066cc` (wenn fehlt)
- `gh issue create` waere der spaetere Trigger fuer Action-Item-Uebertrag

URL aus Onboarding-Antwort 7 (GitHub-Repo). In Governance:
```yaml
backlog_tool: github-issues
backlog_url: https://github.com/<owner>/<repo>/issues
backlog_filter: label:meeting-action
backlog_id_prefix: ""  # GitHub nutzt #123
```

## Hinweise

- **Nie ohne Bestaetigung Auto-Create** — auch bei klarem Sigl
- **Bei Mehrfach-Match nie raten** — immer Liste zeigen, Nutzer entscheiden lassen
- **Bei Auto-Create immer Echo** — "Ich habe Project [Name] (ID: [id]) angelegt — Link: [url]"
