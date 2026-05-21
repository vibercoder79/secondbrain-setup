# Claude Desktop — Config-Template

Diese Vorlage richtet Claude Desktop so ein, dass es deinen Obsidian-Vault als
Filesystem-Quelle nutzen kann (per MCP). Optional sind Perplexity (Web-Recherche) und
Sequential-Thinking (langes Reasoning) konfiguriert.

## Wohin gehoert die Datei?

Kopiere `claude_desktop_config.template.json` nach folgendem Pfad und benenne sie
in `claude_desktop_config.json` um:

| OS | Pfad |
|----|------|
| macOS | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| Windows | `%APPDATA%\Claude\claude_desktop_config.json` |
| Linux | `~/.config/Claude/claude_desktop_config.json` |

## Voraussetzungen

- **Node.js** (fuer `npx`) — `brew install node` (macOS) oder von [nodejs.org](https://nodejs.org)
- **Filesystem-MCP-Server** wird via `npx` automatisch geladen, kann aber auch global
  installiert werden:
  ```bash
  npm install -g @modelcontextprotocol/server-filesystem
  ```

## Pfad anpassen

In `claude_desktop_config.template.json` ist der Filesystem-Server auf
`~/Obsidian/SecondBrain/` voreingestellt. Passe den Pfad an deinen Vault-Speicherort an,
falls er anderswo liegt.

> Hinweis: Manche Claude-Desktop-Versionen erwarten **absolute Pfade** statt `~`. Wenn
> die Tilde nicht aufgeloest wird, ersetze sie durch deinen vollen Pfad
> (z.B. `/Users/<dein-user>/Obsidian/SecondBrain/` auf macOS).

## Sicherheitswarnung — API-Keys

**Lege NIEMALS echte API-Keys im Klartext in der Config ab.** Auch nicht "nur kurz zum
Testen". Die Datei wird in Backups, Cloud-Syncs und Crash-Reports erfasst.

Empfohlene Patterns:

### 1. macOS Keychain + Shell-Wrapper (sicherste Variante)

```bash
# Key in Keychain speichern:
security add-generic-password -s "perplexity-api" -a "$USER" -w "DEIN-KEY-HIER"

# Wrapper-Script `~/bin/perplexity-mcp.sh`:
#!/usr/bin/env bash
export PERPLEXITY_API_KEY="$(security find-generic-password -s perplexity-api -a $USER -w)"
exec npx -y @perplexity-ai/mcp-server "$@"
```

In der Config dann `"command": "/Users/<user>/bin/perplexity-mcp.sh"` statt `npx`.

### 2. `.env`-Datei mit strikten Permissions

```bash
echo 'PERPLEXITY_API_KEY=DEIN-KEY' > ~/.config/claude-secrets.env
chmod 600 ~/.config/claude-secrets.env
```

Dann ueber ein Wrapper-Script laden — nicht direkt in der JSON-Config.

### 3. Gar nicht im Repo

Wenn du nicht sicher bist: lass den optionalen MCP-Server (z.B. Perplexity) einfach weg.
Das Filesystem-MCP funktioniert ohne API-Keys.

## Nach Aenderung: Claude Desktop neu starten

**Wichtig:** Claude Desktop laedt die Config nur beim App-Start. Nach jeder Aenderung:

1. Claude Desktop **komplett beenden** (nicht nur Fenster schliessen)
   - macOS: `Cmd+Q` oder Rechtsklick im Dock → "Beenden"
   - Windows: Rechtsklick im Tray → "Beenden"
2. Claude Desktop neu oeffnen
3. In einer neuen Konversation pruefen ob das MCP-Tool verfuegbar ist
   (Symbol mit Steckdose unten links)

## Optionale MCP-Server entfernen

Wenn du Perplexity oder Sequential-Thinking nicht brauchst: einfach den entsprechenden
Block aus `mcpServers` loeschen. Die Config bleibt gueltiges JSON, solange die Klammern
und Kommas stimmen.

## Fehlersuche

- **Server taucht nicht auf:** Prueft Claude Desktop Logs (macOS: `~/Library/Logs/Claude/`)
- **`npx` schlaegt fehl:** Node.js installiert? `which node` und `which npx` pruefen.
- **Filesystem-Server kann Pfad nicht lesen:** absoluter Pfad statt `~` versuchen.
- **API-Key wird nicht erkannt:** Shell-Wrapper-Pfad in der Config muss absolut sein
  und das Script muss ausfuehrbar sein (`chmod +x`).
