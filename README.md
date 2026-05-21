# SecondBrain Setup

> Ein gemeinsames Markdown-Vault als Wissens-Hub fuer alle deine KIs.
> PARA gibt die Ordnung, Karpathys LLM-Wiki-Pattern die Lebendigkeit, drei kleine
> Skills die Automation. Claude Code, Claude Desktop, Gemini CLI, Codex CLI und
> Perplexity schreiben in dasselbe Vault, ohne sich auf die Fuesse zu treten.

🇩🇪 Deutsch · [🇬🇧 English](README.en.md)

---

## Warum dieses Repo

Wenn du zwei oder mehr KIs ernsthaft im Alltag nutzt — Claude fuer Code, Gemini
fuer Texte, Perplexity fuer Research — merkst du irgendwann: dein Wissen liegt
verstreut. Jede KI ist eine Insel. Erkenntnisse aus dem einen Chat sind im
naechsten unbekannt. Kein Compound-Effekt.

Dieses Setup loest das mit **einem zentralen Markdown-Vault** als Single Source
of Truth. Alle KIs lesen und schreiben dort. Du bleibst Eigner deines Wissens —
keine Vendor-Datenbank, keine proprietaeren Formate.

Inspiriert von:

- **Tiago Forte — Building a Second Brain (PARA)** — gibt das Skelett: 4
  Ordner-Typen sortiert nach Handlungsdruck
- **Andrej Karpathy — [LLM-as-a-Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)** —
  gibt die Lebendigkeit: Ingest/Query/Lint-Pattern fuer vernetztes Wissen

## Was du bekommst

- **Drei Claude Code Skills:** `/projekt-init` (Projekt anlegen), `/lint`
  (Vault-Health), `/ingest` (Notizen vernetzen)
- **Templates:** Globale Configs fuer Claude Code, Gemini CLI, Codex CLI, Claude
  Desktop. Plus Vault-Templates fuer Projekte, ADRs, Meetings, User Stories.
- **Handbuch:** 7 Kapitel zu Philosophie, Architektur, Multi-KI-Anbindung und
  Anpassung. Komplett dokumentiert.
- **Diagramme:** Hub-and-Spoke, Drei-Ebenen-Modell, Karpathy-Datenfluss als
  Excalidraw + PNG.

## Quickstart (15 Minuten)

```bash
# 1. Repo clonen
git clone https://github.com/vibercoder79/secondbrain-setup ~/Documents/GitHub/secondbrain-setup
cd ~/Documents/GitHub/secondbrain-setup
```

### Schritt 1: Obsidian-Vault anlegen

Falls noch nicht vorhanden:

1. [Obsidian](https://obsidian.md) installieren
2. Neues Vault unter `~/Obsidian/SecondBrain/` (oder eigenem Pfad — dann ueberall
   in den Templates anpassen)
3. Plugins aktivieren: **Dataview** (Pflicht), Templater + Excalidraw (optional)

### Schritt 2: Vault-Struktur initialisieren

```bash
VAULT=~/Obsidian/SecondBrain  # oder dein Pfad
cd "$VAULT"

# PARA-Ordner anlegen
mkdir -p "00 Kontext/Workflows" "01 Inbox" "02 Projekte" "03 Bereiche" \
         "04 Ressourcen/Research" "05 Daily Notes" "06 Archiv" "07 Anhaenge"

# Templates kopieren
cp ~/Documents/GitHub/secondbrain-setup/templates/vault/CLAUDE.md "$VAULT/CLAUDE.md"
cp ~/Documents/GitHub/secondbrain-setup/templates/vault/AGENTS.md "$VAULT/AGENTS.md"  # nur wenn Codex genutzt
cp -r ~/Documents/GitHub/secondbrain-setup/templates/vault/"00 Kontext"/* "$VAULT/00 Kontext/"
```

### Schritt 3: Mindestens eine KI anschliessen

**Claude Code (empfohlen):**

```bash
mkdir -p ~/.claude
cp ~/Documents/GitHub/secondbrain-setup/templates/claude/CLAUDE.md ~/.claude/CLAUDE.md
```

**Skills installieren** (drei Slash-Commands):

```bash
cp -r ~/Documents/GitHub/secondbrain-setup/skills/projekt-init ~/.claude/skills/
cp -r ~/Documents/GitHub/secondbrain-setup/skills/lint ~/.claude/skills/
cp -r ~/Documents/GitHub/secondbrain-setup/skills/ingest ~/.claude/skills/
```

**Weitere KIs?** Siehe [Handbuch Kapitel 04 — Multi-KI-Setup](handbuch/04-multi-ki-setup.md).

### Schritt 4: Verifikation

Starte Claude Code in einem beliebigen Verzeichnis:

```
"Was steht in meiner Inbox?"
```

Wenn Claude die Inbox-Notizen aus `01 Inbox/` listet, funktioniert die Anbindung.

Lege ein Test-Projekt an:

```
"lege ein Projekt fuer Test123 an"
```

Claude stellt das 10-Fragen-Onboarding. Nach Beantwortung steht der Projekt-
Ordner mit Hub + Governance + Subordnern.

### Schritt 5: Eigenen Kontext eintragen

`00 Kontext/` mit deinem Profil befuellen (siehe [Handbuch Kapitel 03](handbuch/03-vault-struktur.md)):

- `Über mich.md`
- `ICP.md` (wenn du Kunden hast)
- `Schreibstil.md` (Tonalitaet)
- `Branding.md` (wenn relevant)

Diese Dateien sind nicht im Repo — sie sind dein Inhalt.

## Das Ganze auf einen Blick

```
                ~/.claude/CLAUDE.md          (Claude Code)
                       │
                       │ @-Import
                       │
~/.gemini/GEMINI.md ───┤
        │              │
        │ @-Import     ▼
        │      ┌──────────────────────────────────────┐
        │      │ ~/Obsidian/SecondBrain/CLAUDE.md     │
        │      │ Single Source of Truth (KI-agnostisch)│
        │      └──────────────────────────────────────┘
        │              ▲
        │              │ @-Import / Filesystem-MCP
        │              │
~/.codex/AGENTS.md ────┤
                       │
                Claude Desktop (Filesystem-MCP)
```

Detail-Diagramme in [`diagramme/`](diagramme/).

## Handbuch

Sieben Kapitel, jeweils 5-15 Minuten Lesedauer:

1. [Philosophie — Warum dieses Setup existiert](handbuch/01-philosophie.md)
2. [Architektur — Hub-and-Spoke und das Drei-Ebenen-Modell](handbuch/02-architektur.md)
3. [Vault-Struktur — PARA in Praxis](handbuch/03-vault-struktur.md)
4. [Multi-KI-Setup — Claude, Gemini, Codex, Claude Desktop, Perplexity](handbuch/04-multi-ki-setup.md)
5. [Workflows — Daily Notes, Projekte, Deep Research, Ingest, Lint](handbuch/05-workflows.md)
6. [Skills — projekt-init, lint, ingest im Detail](handbuch/06-skills.md)
7. [Anpassen — Eigene Pfade, eigene Tools, Migration](handbuch/07-anpassen.md)

## Repo-Struktur

```
secondbrain-setup/
├── README.md, README.en.md        Quickstart in DE + EN
├── handbuch/                       Tiefe (DE)
├── handbook/                       Tiefe (EN)
├── templates/
│   ├── claude/CLAUDE.md            Globale Claude Code Config
│   ├── codex/AGENTS.md             Globale Codex CLI Config
│   ├── gemini/GEMINI.md            Globale Gemini CLI Config
│   ├── claude-desktop/             Claude Desktop Config + README
│   ├── vault/                      Vault-Inhalte (CLAUDE.md, AGENTS.md, 00 Kontext)
│   └── projekt/                    Projekt-Templates (PMO HUB, Governance, ADR, Meeting)
├── skills/                         Drei Skills: projekt-init, lint, ingest
├── diagramme/                      Excalidraw + PNG (DE + EN)
└── setup.sh                        Optionaler Setup-Helfer
```

## Sicherheitshinweise

- **Keine API-Keys im Repo.** Alle Templates nutzen Platzhalter (`YOUR_API_KEY_HERE`).
  Verwende Keychain/env-vars fuer echte Secrets.
- **Pfade sind sanitisiert** auf `~/...` — keine absoluten Userland-Pfade.
- **Vault-Inhalte sind generisch** — keine personenbezogenen Daten, keine
  Beispielprojekte mit Kundennamen.

Vor jedem eigenen Push: `git diff --staged` lesen und auf eigene Secrets pruefen.

## Lizenz

MIT — siehe [LICENSE](LICENSE).

## Beitragen

Issues und Pull Requests willkommen. Bei groesseren Aenderungen vorher ein
Issue oeffnen, damit wir die Richtung abstimmen koennen.

## Inspiration & Quellen

- [Andrej Karpathy — LLM-as-a-Wiki Gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- Tiago Forte — Building a Second Brain (Buch, 2022)
- Michael Nygard — [Documenting Architecture Decisions (ADR)](https://www.cognitect.com/blog/2011/11/15/documenting-architecture-decisions) (2011)
- Vault-zentrische Skills inspiriert vom [OpenCLAW Bootstrap-Pattern](https://github.com/vibercoder79/KI-Masterclass-Koerting-/tree/main/bootstrap)
