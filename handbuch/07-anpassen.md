# 07 — Anpassen: Eigene Pfade, eigene Tools, Migration

> Kurzfassung: Vault-Pfad anpassen, eigene Workflows hinzufuegen, Sprache waehlen,
> aus einem bestehenden PARA-Vault migrieren, eigene Skills bauen. Was du anfassen
> darfst und was nicht.

## Was du anfassen kannst

Alles in deinem eigenen Vault gehoert dir. Drei Stellen sind besonders relevant:

### 1. Vault-Pfad

Default in den Templates ist `~/Obsidian/SecondBrain/`. Wenn du einen anderen
Pfad willst (z.B. `~/Vaults/Brain/` oder `~/Documents/Knowledge/`), aenderst du
ihn:

**In den globalen Configs:**

- `~/.claude/CLAUDE.md` — Pfad in der "Zweites Gehirn"-Sektion
- `~/.gemini/GEMINI.md` — `@-Import`-Pfad
- `~/.codex/AGENTS.md` — Verweis-Pfad
- `~/Library/Application Support/Claude/claude_desktop_config.json` — Filesystem-MCP-Argument

**In der Vault-CLAUDE.md selbst:**

Wenn du absolute Pfade in der Vault-CLAUDE.md hast (Beispiel-Pfade in Workflows
etc.), aktualisieren. Die Templates in diesem Repo nutzen Tilde-Notation
(`~/Obsidian/SecondBrain/`) — wenn du beim Tilde bleibst, brauchst du oft nur
die globalen Configs anzupassen.

### 2. Persoenliches Profil

Die Dateien in `00 Kontext/` sind dein Inhalt:

- `Über mich.md` — wer du bist, beruflicher Hintergrund, Schwerpunkte
- `ICP.md` — wenn du Kunden hast: ideale Zielgruppe
- `Angebot.md` — was du anbietest
- `Schreibstil.md` — Tonalitaet, Stil-Regeln (KIs nutzen das fuer Texte in deinem Stil)
- `Branding.md` — Markenwerte, Farben, Designprinzipien

Diese Dateien sind im Repo **nicht enthalten** — sie sind individuell. Lege sie
selbst an. Tipp: erst minimal anfangen (3-4 Saetze pro Datei), spaeter ergaenzen.

### 3. Workflow-Datei

`00 Kontext/Workflows/Projekt-Anlegen.md` ist im Template enthalten und du kannst
sie anpassen:

- Andere Fragen im Onboarding
- Andere Defaults pro Projekt-Typ
- Andere Pflicht-Ordner (z.B. wenn du immer einen `Documents/` Ordner willst)

Solange das Pattern KI-agnostisch bleibt (alle KIs lesen dieselbe Datei und
fahren denselben Workflow), kannst du es nach Belieben aendern.

**Wenn du eigene Workflows hinzufuegst** (z.B. `Meeting-Vorbereiten.md`,
`Newsletter-Schreiben.md`), legst du eine neue Datei in
`00 Kontext/Workflows/` an. Die Vault-CLAUDE.md (Wurzel) verweist im jeweiligen
Sektions-Abschnitt darauf — Beispiel:

```markdown
## Newsletter schreiben

Methodik: [[00 Kontext/Workflows/Newsletter-Schreiben]]
```

Alle KIs sehen dann den neuen Workflow.

## Was du nicht anfassen solltest

### `Index.md`

Wird vom `/lint` regeneriert. Manuelle Aenderungen gehen verloren. Quelle der
Wahrheit sind die einzelnen Notizen.

### `log.md`

Append-only. Verarbeitungs-Chronologie von `/ingest` und `/lint`. Aendere keine
bestehenden Eintraege. Wenn du etwas falsch geloggt hast, schreibe einen
Korrektur-Eintrag drunter, nicht oben drauf.

### Frontmatter-Pflichtfelder

`source:`, `chat_url:`, `tags:` — diese sind Konvention. Wenn du sie weglaesst,
verlieren die Skills die Faehigkeit, die Notizen zu verwalten (`/lint` warnt,
Dataview-Queries finden nichts).

## Sprache: Deutsch oder Englisch?

Das Setup laeuft auf Deutsch (Tobias' Default). Die Templates haben aber
englische Varianten:

- `Projekt-Struktur.md` (DE) + `Projekt-Struktur.en.md` (EN)
- `User-Story-Template.md` (DE) + `User-Story-Template.en.md` (EN)

Wenn du das Setup primaer auf Englisch nutzen willst:

1. EN-Templates ueberall aktivieren
2. In der `Workflows/Projekt-Anlegen.md` die Default-Sprache auf `en` setzen
3. In den globalen Configs Sprach-Hinweise auf Englisch aendern
4. Vault-CLAUDE.md: optional komplett auf Englisch uebersetzen (Pflicht ist es
   nicht — Mehrsprachigkeit ist ok)

Das Setup hat eine eingebaute **Sprach-Logik** in der Projekt-Anlage-Workflow:
Frage 0 ist die Sprach-Wahl, und die KI generiert dann DE- oder EN-Inhalte je
Projekt. Datei- und Ordnernamen bleiben gleich (Whitelist), nur Inhalte sind
uebersetzt.

## Migration aus einem bestehenden PARA-Vault

Wenn du schon ein Obsidian-Vault hast (oder ein Notion/Logseq), das halbwegs
PARA-aehnlich strukturiert ist:

### Schritt 1: Sichern

```bash
cp -r ~/Obsidian/MeinVault ~/Obsidian/MeinVault.backup
```

### Schritt 2: Pflicht-Ordner ergaenzen

```bash
cd ~/Obsidian/MeinVault
mkdir -p "00 Kontext" "01 Inbox" "02 Projekte" "03 Bereiche" "04 Ressourcen" "05 Daily Notes" "06 Archiv" "07 Anhaenge"
```

Wenn du andere Ordner-Namen hattest ("Projekte" statt "02 Projekte"), kannst du
sie umbenennen ODER die Templates anpassen (in der Vault-CLAUDE.md und in
`Projekt-Anlegen.md`).

### Schritt 3: CLAUDE.md anlegen

Kopiere `templates/vault/CLAUDE.md` nach `~/Obsidian/MeinVault/CLAUDE.md`. Passe
Pfade an wenn deine Ordner anders heissen.

### Schritt 4: 00 Kontext befuellen

Lege die Profil-Dateien an (auch wenn nur skizzenhaft).

Kopiere `templates/vault/00 Kontext/Projekt-Struktur.md` und
`Workflows/Projekt-Anlegen.md`.

### Schritt 5: Bestehende Projekte angleichen

Pro existierendem Projekt:

- Sicherstellen, dass es einen Ordner gibt (kein loses Einzelfile)
- Hub-Datei umbenennen zu `<Projekt> - PMO HUB.md`
- `Projekt-Governance.md` ergaenzen (auch wenn minimal: `backlog_tool: none`)
- Subordner `Meetings/`, `Decisions/`, `Research/`, `assets/` anlegen

Wenn du 20+ Projekte hast: nicht alle auf einmal. Schritt fuer Schritt.

### Schritt 6: KIs anschliessen

Siehe Kapitel 04.

### Schritt 7: `/lint`

Wenn du Claude Code hast und den Lint-Skill installiert: laufen lassen. Er
zeigt dir alle Compliance-Verstoesse, die du noch fixen musst.

## Andere Backlog-Tools

Default-Unterstuetzung in `/projekt-init`: Linear, M365 Teams-Kanban, GitHub
Issues, none.

### Notion

Aktuell nicht via MCP integriert in Default-Setup. Workaround:

- In Frage 6 antworten: `none`
- Hub bekommt "Pre-Backlog Action Items"-Sektion
- Du schiebst Items manuell ins Notion-Board

Wenn du Notion-MCP-Integration willst: gibt es Community-MCPs (z.B.
[mcp-notion](https://github.com/danhilse/notion_mcp)), du kannst eine eigene
Discovery-Reference im Skill ergaenzen.

### Asana, ClickUp, Jira

Selbes Pattern: keine Default-Unterstuetzung, aber wenn ein MCP existiert,
laesst sich die Hybrid-Strategie analog umsetzen (siehe Skill-Reference
`backlog-discovery-linear.md` als Vorlage).

## Eigene Skills bauen

Wenn du das Vault-Pattern erweitern willst — z.B. ein `/newsletter-init`-Skill
oder `/cv-update`-Skill:

1. Methodik **zuerst in `00 Kontext/Workflows/`** dokumentieren (KI-agnostisch)
2. Claude-Skill in `~/.claude/skills/<name>/` bauen, der die Methodik
   automatisiert
3. Bei Bedarf MCP-Discovery-Patterns ergaenzen
4. Doku im Vault unter `03 Bereiche/Skills/<name>.md`

Detaillierter Lifecycle-Workflow im `skill-creator`-Skill aus Tobias'
Hauptrepo: [vibercoder79/claudecodeskills](https://github.com/vibercoder79/claudecodeskills)
(Skill `skill-creator`).

## Versionierung deines Vaults

Empfohlen: das Vault selbst unter Git verwalten. Nicht fuer Backup (Obsidian
Sync, iCloud, OneDrive sind dafuer da), sondern fuer Historie.

```bash
cd ~/Obsidian/SecondBrain
git init
echo ".obsidian/workspace.json" >> .gitignore  # Workspace-State nicht versionieren
echo "07 Anhaenge/" >> .gitignore               # optional: Bilder/PDFs nicht versionieren
git add CLAUDE.md AGENTS.md Index.md log.md "00 Kontext" "02 Projekte" "03 Bereiche" "04 Ressourcen" "05 Daily Notes" "06 Archiv"
git commit -m "Initial Vault"
```

Pro Daily-Note-Sitzung kannst du commiten. Oder einmal pro Woche. Das ist
Geschmackssache.

**Wichtig:** Wenn dein Vault Secrets enthaelt (es sollte nicht), pruefe vor
jedem Commit. Generelle Vault-Inhalte sind aber typischerweise nicht-sensitiv.

## Performance bei grossen Vaults

Tobias' Vault hat ueber 1200 Notizen. Bis dahin laeuft alles fluessig. Wenn du
ueber ~3000-5000 Notizen kommst, koennten Schwierigkeiten auftauchen:

- `/lint` wird langsamer (Glob ueber alle Files)
- Index.md koennte zu lang werden
- KI-Token-Budget wird knapp beim Session-Start

Mitigations:

- `06 Archiv/` aggressiver nutzen
- `Index.md` filtern (nur `aktiv`-Status-Projekte)
- Externe Such-Tools wie [qmd](https://github.com/karpathy/llm.c) (BM25/Vektor-Suche
  ueber lokales Markdown) als Ergaenzung

## Wenn du das Setup verlaesst

Das schoene an diesem Setup ist: **du hast nichts zu verlieren**. Es ist alles
Markdown in Ordnern. Wenn du morgen kein Obsidian mehr willst, oeffnest du es
mit jedem Texteditor. Wenn du keine KIs mehr willst, loescht du die globalen
Configs — das Vault bleibt.

Die einzige Hoehrabhaengigkeit ist Obsidians **Dataview-Plugin** fuer die Hub-
Queries. Wenn du Dataview verlierst, sehen die Hubs nur den rohen Code-Block
statt der ausgewerteten Ergebnisse. Aber die Daten (Daily Notes, ADRs, etc.)
bleiben les- und durchsuchbar.

## Ende

Du hast jetzt alles. Bau dir dein Zweites Gehirn. Wenn etwas im Handbuch unklar
ist, oeffne ein Issue im Repo. Wenn dir ein Workflow fehlt, schick einen Pull
Request.

→ Zurueck zur Uebersicht: [README.md](../README.md)
