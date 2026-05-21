# Backlog-Discovery: M365 / Teams-Kanban (Hybrid-Strategie)

Wenn `backlog_tool: teams-kanban` aus Onboarding gewaehlt wurde.

## M365 MCP Server

Konfiguriert in `~/.claude/settings.json`:
```json
"ms365": {
  "command": "npx",
  "args": ["-y", "@softeria/ms-365-mcp-server", "--org-mode"]
}
```

Package: https://github.com/softeria/ms-365-mcp-server (Microsoft Graph API)

## Tool-Discovery zur Laufzeit

Die exakten Tool-Namen sind nicht hardcoded — der Server-Identifier ist eine Hash-ID.
Beim ersten Aufruf des Skills:

1. Liste verfuegbare MCP-Tools auf (via Tool-Inventar)
2. Suche nach Mustern: `planner`, `tasks`, `teams`, `m365`, `graph`
3. Wenn gefunden → in `~/.claude/skills/projekt-init/references/m365-tools.cache.md` cachen
4. Wenn nicht gefunden → Auth-Problem? `--org-mode` Setup? → User-Input-Fallback

**Erwartete M365-Tool-Kategorien** (basierend auf @softeria/ms-365-mcp-server):

| Kategorie | Erwartete Tools |
|-----------|-----------------|
| Planner | `list-planner-plans`, `get-planner-plan`, `create-planner-task`, `list-planner-buckets` |
| Tasks (To Do) | `list-todo-lists`, `create-todo-task` |
| Teams | `list-teams`, `list-channels`, `send-message` |
| Outlook | `send-mail`, `list-messages` |
| Files | `list-drive-items`, `download-file` |

## Workflow (analog zu Linear)

### Schritt 1: MCP-Verfuegbarkeit pruefen

Test-Call eines Listing-Tools (z.B. `list-planner-plans` oder `list-teams`).
- **Erfolg:** weiter zu Schritt 2
- **Fehler:** User-Input-Fallback

### Schritt 2: Discovery

```
list-planner-plans(filter="<Projektname>") oder ohne Filter, dann lokal matchen
```

Match-Auswertung wie bei Linear:
- 0 Match → Auto-Create-Angebot
- 1 Match → Verlinken-Bestaetigung
- mehrere → Auswahl

### Schritt 3: Auto-Create-Angebot

```
Soll ich einen neuen Planner-Plan "[Projektname]" in M365 anlegen?
- Team / Group: <Auswahl noetig>
- Buckets-Standardset: "To Do", "In Progress", "Done"
[j/n]
```

Bei Ja: Plan + 3 Standard-Buckets anlegen via entsprechende MCP-Tools.

In Governance eintragen:
```yaml
backlog_tool: teams-kanban
backlog_url: https://tasks.office.com/<tenant>/Home/PlanViews/<plan-id>
backlog_filter: plan:<plan-id>
backlog_id_prefix: ""  # Planner hat keine eindeutigen IDs
```

### Schritt 4: User-Input-Fallback

```
Bitte gib die Planner-Plan-URL ein (oder leer lassen):
```

URL kann z.B. so aussehen:
- `https://tasks.office.com/...` (Web-View)
- `https://teams.microsoft.com/l/entity/...` (Teams-Link)

URL in Governance eintragen, ohne weitere Calls.

## Spezialfall: --org-mode

Der Server laeuft mit `--org-mode` Flag — das bedeutet:
- Org-weite Authentication (vermutlich Application-Permissions)
- Kann auf alle Plans zugreifen, nicht nur eigene
- Discovery sollte alle Plans der Organisation finden

**Falls Tool-Calls fehlschlagen** mit Permission-Errors:
- Skill darf NICHT versuchen Permissions zu fixen
- Stattdessen: User-Input-Fallback + Hinweis "M365 MCP Auth-Problem — bitte pruefen"

## Hinweise

- Konkrete Tool-Namen werden bei ersten Skill-Lauf ermittelt und gecached
- `--org-mode` heisst: Auto-Create geht in den ganzen Tenant, nicht nur in eigenen Account → bei Auto-Create vorsichtig sein, immer expliziter Bestaetigung
- Wenn der Skill einen Plan in einem fremden Team anlegen soll: zusaetzlich nachfragen welches Team
