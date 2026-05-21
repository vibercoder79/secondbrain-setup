# SecondBrain Skills

Drei Claude-Code-Skills, die das **SecondBrain Obsidian Vault** zu einem lebenden, vernetzten Wissenssystem machen. Sie greifen ineinander: `projekt-init` baut Struktur, `ingest` vernetzt Wissen, `lint` haelt es gesund.

Alle Skills basieren auf einer PARA-Vault-Struktur (`00 Kontext`, `01 Inbox`, `02 Projekte`, `03 Bereiche`, `04 Ressourcen`, `05 Daily Notes`, `06 Archiv`, `07 Anhaenge`) und auf dem **LLM Wiki Pattern** von Andrej Karpathy: Wissen wird beim Ablegen einmal verarbeitet und vernetzt, statt bei jeder Abfrage neu zusammengesucht zu werden.

## Installation aller drei Skills

```bash
cp -r ~/Documents/GitHub/secondbrain-setup/skills/projekt-init ~/.claude/skills/projekt-init
cp -r ~/Documents/GitHub/secondbrain-setup/skills/ingest      ~/.claude/skills/ingest
cp -r ~/Documents/GitHub/secondbrain-setup/skills/lint        ~/.claude/skills/lint
```

Claude Code laedt Skills automatisch aus `~/.claude/skills/`. Kein Restart noetig.

---

## Die drei Skills

### 1. `projekt-init` — Projekte anlegen

> [Skill-README](projekt-init/README.md) · [SKILL.md](projekt-init/SKILL.md) · [EN](projekt-init/README.en.md)

Orchestriert das Anlegen eines neuen Projekts im Vault: Onboarding-Dialog (9 Fragen), Ordnerstruktur gemaess Whitelist, Templates mit echten Werten befuellen, Backlog-Tool intelligent anschliessen (Linear / M365 Teams-Kanban / GitHub Issues / none). Verifikation am Ende prueft Compliance vor der Zusammenfassung.

**Trigger:**
- `/projekt-init`
- "neues Projekt", "lege ein Projekt an", "Projekt anlegen", "erstelle ein Projekt fuer..."
- `/projekt-init Standard` (Schnellmodus mit Defaults)

**Voraussetzungen:**
- Vault unter `~/Obsidian/SecondBrain/`
- `00 Kontext/Projekt-Struktur.md` als Template-Quelle
- Optional: Linear MCP, M365 MCP (`@softeria/ms-365-mcp-server`), `gh` CLI

---

### 2. `ingest` — Notizen vernetzen

> [Skill-README](ingest/README.md) · [SKILL.md](ingest/SKILL.md)

Verarbeitet eine einzelne Notiz und vernetzt sie mit dem restlichen Vault: bidirektionale Wikilinks, Aktualisierung passender Synthese-Seiten in `04 Ressourcen/` (destillierte Erkenntnis, kein Copy-Paste), Eintrag in `log.md`. Der Compound-Effekt: jede neue Quelle macht das Vault reicher.

**Trigger:**
- `/ingest <Notizname>` oder `/ingest <Pfad>`
- "verarbeite diese Notiz", "vernetze das", "link diese Notiz", "integriere das ins Vault"

**Voraussetzungen:**
- Vault unter `~/Obsidian/SecondBrain/`
- Optionale Synthese-Seiten-Konvention: Ordner in `04 Ressourcen/<Thema>/` mit gleichnamiger Start-Datei

---

### 3. `lint` — Vault-Gesundheits-Check

> [Skill-README](lint/README.md) · [SKILL.md](lint/SKILL.md) · [EN](lint/SKILL.en.md)

Woechentlicher 6-Phasen-Check des gesamten Vaults: verwaiste Notizen, fehlende Verknuepfungen, Vault-Hygiene (Inbox, Frontmatter, Synthese-Seiten), Projekt-Compliance gegen die Whitelist aus `Projekt-Struktur.md`, Markdown-Report in `01 Inbox/`, Log-Eintrag, und Regenerierung der `Index.md` im Vault-Root als **Wiki-Cover** fuer Claude (statt das ganze Vault zu durchsuchen).

**Trigger:**
- `/lint` (Voll-Check) oder `/lint orphans`, `/lint inbox`, `/lint projekte`, `/lint index` (Teil-Checks)
- "lint", "vault check", "pruefe das vault", "gesundheitscheck", "verwaiste notizen", "orphans", "projekt-compliance"

**Voraussetzungen:**
- Vault unter `~/Obsidian/SecondBrain/`
- Funktioniert auch ohne `projekt-init`, aber der Projekt-Compliance-Teil setzt die `projekt-init`-Konvention voraus

---

## Wie die drei zusammenspielen

```
projekt-init  →  legt strukturierte Projekte an    →  verhindert Drift beim Anlegen
   ↓
ingest        →  vernetzt Notizen ins Vault         →  baut den Compound-Effekt auf
   ↓
lint          →  findet Drift in bestehenden Notizen → haelt das System sauber
```

Der gemeinsame Nenner: **Vorverarbeitung statt Echtzeit-Suche**. Statt dass Claude bei jeder Frage das ganze Vault scannt, wird beim Ablegen einmal investiert — und die `Index.md` aus `lint` ist die Eintrittskarte fuer jede Session.

## Quellen

- [Karpathy LLM Wiki Gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — das Pattern hinter allen drei Skills
- [PARA Method](https://fortelabs.com/blog/para/) — Tiago Forte, Building a Second Brain
- Michael Nygard, "Documenting Architecture Decisions" (2011) — ADR-Pattern fuer `Decisions/`

## Sprache

Skills und Dokumentation sind ueberwiegend auf Deutsch — die Original-Arbeitssprache. EN-Varianten sind bei `projekt-init` (komplett) und `lint` (Kurzfassung) vorhanden.
