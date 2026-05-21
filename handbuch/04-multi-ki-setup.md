# 04 — Multi-KI-Setup: jede KI ans Vault anschliessen

> Kurzfassung: Vier KIs, vier Konfig-Patterns. Claude Code via globale CLAUDE.md mit
> @-Import. Gemini CLI dito. Codex CLI ebenso. Claude Desktop via Filesystem-MCP-Server.
> Perplexity hat keine native Anbindung — Workaround via Obsidian Web Clipper mit
> OpenRouter-Interpreter.

## Voraussetzung: das Vault existiert

Bevor du KIs anschliesst, muss das Vault existieren:

1. [Obsidian](https://obsidian.md) installieren (kostenlos)
2. Neues Vault anlegen unter `~/Obsidian/SecondBrain/` (oder eigenem Pfad — dann
   ueberall in den Configs anpassen)
3. Die Templates aus `templates/vault/` in den Vault kopieren:
   - `templates/vault/CLAUDE.md` → `~/Obsidian/SecondBrain/CLAUDE.md`
   - `templates/vault/AGENTS.md` → `~/Obsidian/SecondBrain/AGENTS.md` (nur wenn Codex genutzt)
   - `templates/vault/00 Kontext/` → `~/Obsidian/SecondBrain/00 Kontext/`
4. Acht PARA-Ordner anlegen (siehe Kapitel 03): `mkdir -p "01 Inbox" "02 Projekte" ...`
5. **Empfohlene Obsidian-Plugins:**
   - **Dataview** (Pflicht — die Hub-Dateien nutzen Dataview-Queries)
   - **Templater** (optional, fuer eigene Templates)
   - **Excalidraw** (optional, fuer eingebettete Diagramme)
   - **Obsidian Web Clipper** (separat als Browser-Extension — siehe Perplexity unten)

## Claude Code

Claude Code ist die CLI-Variante von Claude und der "Default" dieses Setups (deshalb
heisst die Vault-Datei `CLAUDE.md`).

### Setup

1. Claude Code installieren (siehe [docs.claude.com/claude-code](https://docs.claude.com/claude-code))
2. Globale Config anlegen:
   ```bash
   mkdir -p ~/.claude
   cp <repo>/templates/claude/CLAUDE.md ~/.claude/CLAUDE.md
   ```
3. In `~/.claude/CLAUDE.md` den Vault-Pfad pruefen — er muss auf dein tatsaechliches
   Vault zeigen.

### Was Claude Code besonders macht

- **Skills** via Slash-Commands: `/projekt-init`, `/lint`, `/ingest` etc.
  Die drei Vault-zentrischen Skills sind in `skills/` in diesem Repo.
- **MCP-Server** fuer externe Integrationen (Linear, M365, etc.).
- **Sub-Agents** fuer parallele komplexe Tasks.

### Verifikation

Starte Claude Code in einem beliebigen Verzeichnis und sag:

```
"Was steht in meiner Inbox?"
```

Wenn Claude die Inbox-Notizen aus `01 Inbox/` listet, funktioniert die Anbindung.

## Gemini CLI

Gemini CLI ist Googles offizielles CLI-Tool fuer Gemini-Modelle.

### Setup

1. Gemini CLI installieren (`npm install -g @google/generative-ai` oder nach offizieller Doku)
2. Globale Config anlegen:
   ```bash
   mkdir -p ~/.gemini
   cp <repo>/templates/gemini/GEMINI.md ~/.gemini/GEMINI.md
   ```
3. Verzeichnis fuer Gemini-Chat-Archive im Vault anlegen:
   ```bash
   mkdir -p ~/Obsidian/SecondBrain/04\ Ressourcen/Gemini/
   ```

### Was Gemini besonders macht

- **Lange Kontextfenster** — eignet sich fuer Whole-Vault-Analysen
- **Multimodal** — kann mit Bildern, Audio, Video arbeiten
- **Aber: keine Skills/Slash-Commands** — du faehrst Workflows manuell mit Bash/Write

### Was Gemini nicht kann

- Claude-Skill-Slash-Commands (`/projekt-init`, `/lumen-strategist`, ...)
- TodoWrite / AskUserQuestion (Claude-spezifisch)
- Publish-Script-Workflow

→ Fuer Skill-getriebene Automation: Claude Code. Gemini ist eine **alternative
Konversations-Schnittstelle** auf demselben Vault.

### Chat-Archivierung

Damit Gemini-Sessions im Vault auffindbar bleiben, gibt es eine Konvention:

- **Default-Speicherort:** `04 Ressourcen/Gemini/`
- **Naming:** `YYYY-MM-DD-HHMM-kurzthema.md`
- **Frontmatter:** `tags: [gemini-chat]`, `datum:`, `thema:`, `source: gemini`,
  `chat_url:`
- **Trigger:** bei Session-Ende proaktiv anbieten

Das Pattern ist in der GEMINI.md selbst dokumentiert — Gemini liest die Datei beim
Start und kennt die Regel.

## Codex CLI (OpenAI)

OpenAI Codex CLI ist seit Anfang 2026 die offizielle Coding-CLI von OpenAI.

### Setup

1. Codex CLI installieren:
   ```bash
   brew install codex
   # oder
   npm install -g @openai/codex
   ```
2. Login: `codex login` (legt `~/.codex/auth.json` an)
3. Globale Config anlegen:
   ```bash
   mkdir -p ~/.codex
   cp <repo>/templates/codex/AGENTS.md ~/.codex/AGENTS.md
   ```
4. Optional: Verzeichnis fuer Codex-Chat-Archive:
   ```bash
   mkdir -p "~/Obsidian/SecondBrain/04 Ressourcen/Codex - OpenAI/"
   ```
5. Optional: Vault-spezifische Codex-Config — kopiere `templates/vault/AGENTS.md`
   nach `~/Obsidian/SecondBrain/AGENTS.md` damit Codex eine spezifische "Codex-Brille"
   beim Lesen der Vault-Regeln hat.

### Was Codex besonders macht

- **MCP-Server-Support** (siehe `~/.codex/config.toml`)
- **SQLite-basierter Session-Verlauf** — interne History, Vault-Archiv ist der lesbare Spiegel
- **CI/CD-Pipeline-Modus** — Codex kann als Build-Schritt laufen

### Verifikation

```bash
cd ~  # oder beliebiges Verzeichnis
codex
```

Im Codex-Chat: *"Was steht in meiner Inbox?"* — Codex sollte `01 Inbox/` lesen.

## Claude Desktop

Claude Desktop ist die GUI-Variante von Claude (macOS, Windows). Sie greift via
**MCP-Server** auf das Vault zu.

### Setup

1. Claude Desktop installieren (von [claude.com/download](https://claude.com/download))
2. Filesystem-MCP-Server fuer das Vault konfigurieren — Config-Pfad:
   - **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
   - **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`
3. Template-Inhalt aus `templates/claude-desktop/claude_desktop_config.template.json`
   uebernehmen — der relevante Block ist:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "~/Obsidian/SecondBrain"
      ]
    }
  }
}
```

4. **Claude Desktop komplett schliessen und neu starten** (nicht nur Tab/Chat
   schliessen — die Config wird nur beim App-Start geladen).
5. Im neuen Chat: rechts unten am Eingabe-Feld sollte das MCP-Server-Icon
   aufleuchten. Wenn ja, ist Filesystem aktiv.

### Sicherheitswarnung: niemals API-Keys in dieser Datei

Wenn du andere MCP-Server (Perplexity, Pencil etc.) hinzufuegst, brauchen sie oft
API-Keys. **Niemals den Key im Klartext in die Config schreiben.** Bessere
Patterns:

- **macOS Keychain** + Shell-Wrapper-Script, das den Key zur Laufzeit liest
- **env-var-Datei** mit `chmod 600` und Shell-Wrapper
- **Externalisieren** in eine separate Datei ausserhalb der Config (z.B.
  `~/.secrets/perplexity.env`) und im MCP-Server-Wrapper laden

Die Datei `claude_desktop_config.json` ist **lesbar fuer jeden Prozess unter deinem
User** — kein Schutz vor Malware, anderen Apps, oder versehentlichem Sharing.

### Was Claude Desktop besonders macht

- **Persistente App** — laeuft im Hintergrund, kann waehrend du arbeitest fragen
- **Computer Use** (in einigen Versionen) — Claude steuert deinen Bildschirm
- **Chrome-Extension Pairing** (in einigen Versionen) — Web-Recherche im Browser

Aber: **kein direkter Zugriff auf Claude-Skills** wie die CLI-Variante. Wenn du
`/projekt-init`-aehnliche Automation brauchst, ist Claude Code die richtige Wahl.

## Perplexity — der Sonderfall

Perplexity hat **keine native Vault-Anbindung**. Du kannst nicht einfach eine
Config-Datei anlegen wie bei den anderen KIs. Der Workaround: **Obsidian Web
Clipper als Browser-Extension**.

### Setup: Obsidian Web Clipper

1. **Plugin in Obsidian aktivieren:** Settings → Community Plugins → "Obsidian
   Web Clipper"
2. **Browser-Extension installieren:**
   - [Chrome / Edge / Brave (Chromium)](https://chromewebstore.google.com/detail/obsidian-web-clipper/cnjifjpddelmedmihgijeibhnjfabmlf)
   - [Firefox](https://addons.mozilla.org/firefox/addon/obsidian-web-clipper/)
   - [Safari](https://apps.apple.com/app/obsidian-web-clipper/id6720708363)
3. Im Browser: Extension oeffnen → mit dem Obsidian-Vault verbinden (zeigt einen
   QR-Code oder Pfad-Auswahl).

### Template fuer Perplexity-Research

In der Web-Clipper-Extension: neue Vorlage anlegen mit folgenden Werten.

**Vorlagen-Name:** `Perplexity Research`

**Trigger:** URL enthaelt `perplexity.ai`

**Notiz-Name (Filename-Template):**

```
{{date|date:"YYYY-MM-DD"}} {{"Was ist das konkrete Thema dieser Research? Antworte NUR mit 3-5 Stichworten, z.B. 'NIST CSF Tier 3 Analyse' oder 'KI Markt Europa Vergleich' oder 'Cybersecurity Framework ROI Studie'"}}
```

Der Teil in `{{"..."}}` ist ein **LLM-Interpreter-Call** — siehe naechster Abschnitt.

**Speicherort:** `04 Ressourcen/Research/`

**Frontmatter:**

```yaml
---
tags: [perplexity, research]
datum: {{date|date:"YYYY-MM-DD"}}
source: perplexity
chat_url: {{url}}
---
```

**Notiz-Inhalt-Template:**

```markdown
## Zusammenfassung

{{content}}

## Quellen

Siehe Perplexity-Zitationen im Text.
```

### Interpreter: OpenRouter + Gemini 3.1 Flash Lite

Der `{{"..."}}` Block im Filename-Template ist ein **LLM-Call** der zur Clip-Zeit
ausgefuehrt wird. Web Clipper unterstuetzt mehrere Anbieter — empfohlen ist
**OpenRouter mit Gemini 3.1 Flash Lite Preview** (guenstig, schnell, gut fuer
kurze Zusammenfassungen).

**Setup:**

1. In Web-Clipper-Settings: Interpreter aktivieren
2. Provider: **OpenRouter**
3. Model: `google/gemini-flash-1.5-8b` oder aehnliches Flash-Lite-Modell
4. API-Key: dein OpenRouter-Key
   - **Wichtig:** Der Key wird im Browser gespeichert. Nutze einen Key der
     **nur fuer Web Clipper gedacht ist** und ein striktes Budget-Limit hat
     ([openrouter.ai/credits](https://openrouter.ai/credits))
5. **Erweiterter Interpreter-Kontext** (in der Vorlage):

```
Hier ist der Inhalt einer Perplexity Deep Research:

{{content|slice:0,2000}}

Extrahiere das spezifische Kernthema. Antworte NUR mit 3-5 konkreten Stichworten
auf Deutsch. Keine Saetze, keine generischen Begriffe.
Beispiele: 'NIST CSF Tier 3 Analyse', 'React Performance Optimierung',
'B2B SaaS Pricing Strategien'
```

### Was du bekommst

Du klickst auf einer Perplexity-Ergebnis-Seite den Web-Clipper-Button. Die
Extension:

1. Schickt die ersten 2000 Zeichen des Research-Inhalts an OpenRouter
2. Bekommt 3-5 Stichworte zurueck (z.B. "NIST CSF Tier 3 Analyse")
3. Baut den Dateinamen: `2026-05-21 NIST CSF Tier 3 Analyse.md`
4. Legt die Datei in `04 Ressourcen/Research/` ab mit Frontmatter und Inhalt

Ergebnis: Perplexity-Recherchen landen automatisch und konsistent benannt im Vault.

### Fuer andere Tools ohne Vault-Anbindung

Das gleiche Pattern funktioniert fuer:

- **ChatGPT-Sessions** (Vorlage: URL enthaelt `chat.openai.com`)
- **Claude.ai Web-Chats** (URL enthaelt `claude.ai`)
- **Beliebige Artikel** (kein Trigger, manueller Clip)

Pro Quelle eine eigene Web-Clipper-Vorlage mit angepassten Frontmatter-Werten
(`source: chatgpt`, `source: claude`, etc.).

## Mehrere KIs gleichzeitig — wer schreibt wann?

Wenn zwei KIs gleichzeitig laufen, kann es theoretisch zu Schreib-Konflikten
kommen. In der Praxis ist das selten ein Problem, weil:

1. KIs schreiben meist **append-only** oder erstellen neue Files
2. Wenn doch konkurrierend: Obsidian erkennt File-Aenderungen extern und reloadt

**Sicherheitsventil:** Bei wirklich kritischen Aenderungen (z.B. `CLAUDE.md`
selbst aendern) — nur eine KI zur Zeit lassen.

## Naechstes Kapitel

→ [05 — Workflows: Daily Notes, Projekte, Deep Research, Ingest, Lint](05-workflows.md)
