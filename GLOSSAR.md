# Glossar

Begriffe die in diesem Repo benutzt werden, sortiert alphabetisch. Wenn du
unsicher bist, schau hier nach.

---

## ADR (Architecture Decision Record)

Eine Markdown-Datei pro Entscheidung. Statt Entscheidungen in Chat-Logs oder
Meeting-Protokollen zu vergraben, bekommt jede wichtige Entscheidung eine
nummerierte Datei (`ADR-03 Datenbank-Wahl.md`) mit Kontext, Optionen und Begruendung.
Konzept stammt von Michael Nygard (2011) — ueblich in Software-Teams.

## CLI (Command Line Interface)

Programme die du im Terminal ausfuehrst, nicht in einer App mit Maus. Beispiele:
`git`, `npm`, `claude` (Claude Code), `gemini` (Gemini CLI), `codex` (Codex CLI).
Wenn du noch nie ein Terminal benutzt hast, ist dieses Setup ohne Lernkurve nicht
nutzbar.

## Compound-Effekt

Begriff von [Karpathys LLM-Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).
Idee: Wissen wird **mit der Zeit besser** weil jede neue Quelle in bestehende
Notizen einfliesst (Wikilinks gesetzt, Synthese-Seiten erweitert). Statt 1000
einzelner unverbundener Notizen entsteht ein vernetztes Wiki, das mehr ist als
die Summe seiner Teile.

## Dataview

Obsidian-Plugin (kostenlos, Community). Macht aus deinem Vault eine Datenbank.
Mit Dataview kannst du Queries schreiben:

````markdown
```dataview
LIST file.link
FROM "05 Daily Notes"
WHERE contains(file.tags, "#mein-projekt")
```
````

Das Ergebnis ist eine Live-Liste in Obsidian — sortiert, gefiltert, automatisch
aktuell. In diesem Setup nutzen Projekt-Hubs Dataview um Daily-Note-Sektionen
automatisch zu aggregieren. **Pflicht** wenn du dieses Setup nutzt.

## Frontmatter

Der YAML-Block am Anfang einer Markdown-Datei zwischen `---`-Linien:

```yaml
---
tags: [thema-1, thema-2]
status: aktiv
source: claude
---
```

Das sind **Metadaten** zur Datei. Obsidian und Dataview nutzen sie zum Filtern,
Sortieren, Aggregieren. Ohne Frontmatter funktionieren Dataview-Queries und
Projekt-Hubs nicht.

## Hook

Automatischer Trigger der bei bestimmten Events feuert. In Claude Code z.B.
"Wenn eine Datei geaendert wird, fuehre X aus." In diesem Setup bewusst **nicht**
genutzt — wir nutzen manuelle Skill-Aufrufe (`/ingest`, `/lint`) damit der Nutzer
die Kontrolle behaelt und nicht jede triviale Aenderung eine LLM-Analyse ausloest.

## Hub-and-Spoke

Architektur-Muster. Eine Nabe in der Mitte (`Vault-CLAUDE.md`), Speichen nach
aussen zu mehreren Clients (`~/.claude/CLAUDE.md`, `~/.gemini/GEMINI.md`,
`~/.codex/AGENTS.md`). Aenderung im Hub erreicht alle Spokes. Siehe
[Kapitel 02](handbuch/02-architektur.md).

## Karpathy LLM-Wiki

Konzept aus einem [Gist von Andrej Karpathy](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).
Ein strukturiertes Markdown-Wiki, das ein LLM **inkrementell pflegt** (Ingest,
Query, Lint). Quelle der Inspiration fuer die Skills in diesem Repo.

## MCP (Model Context Protocol)

Standard von Anthropic (2024) der KIs den Zugriff auf externe Daten und Tools
ermoeglicht. Ein **MCP-Server** ist ein kleines Programm, das einer KI z.B.
Lese-Zugriff auf deine Festplatte gibt (Filesystem-MCP), oder auf Linear, Notion,
deine Mail-Inbox usw. In diesem Setup zentral fuer Claude Desktop (das nutzt
Filesystem-MCP fuer den Vault-Zugriff).

## Obsidian

Markdown-Editor mit Wikilink-Support und Plugin-System. Kostenlos, lokal, kein
Cloud-Zwang. [obsidian.md](https://obsidian.md). **Voraussetzung fuer dieses Setup.**
Du kannst theoretisch andere Editoren nehmen (Logseq, Foam, plain Markdown), aber
die Konventionen hier sind auf Obsidian ausgelegt.

## PARA

Methode von Tiago Forte aus dem Buch "Building a Second Brain" (2022). Vier
Top-Level-Ordner sortiert nach **Handlungsdruck**:

- **P**rojects — Ziel + Enddatum
- **A**reas — laufende Verantwortungen ohne Enddatum
- **R**esources — Referenzmaterial
- **A**rchives — Abgeschlossenes

In diesem Setup um `00 Kontext` (Profil), `01 Inbox` (Eingang), `05 Daily Notes`
und `07 Anhaenge` erweitert.

## PMO HUB

PMO = Project Management Office. Der **HUB** ist die Landing-Page eines Projekts
in `02 Projekte/<Projekt>/<Projekt> - PMO HUB.md`. Enthaelt Ziel, Stakeholder,
Stack, Dataview-Sichten auf Decisions/Action Items/Daily Notes. Wer das Projekt
verstehen will, liest den HUB.

## Skill (Claude Code Skill)

Eine **Erweiterung** von Claude Code. Liegt unter `~/.claude/skills/<name>/`,
besteht mindestens aus einer `SKILL.md`. Wird per Slash-Command aufgerufen
(`/projekt-init`) oder ueber Trigger-Saetze ("lege ein Projekt an"). In diesem
Repo: `projekt-init`, `lint`, `ingest`.

## Slash-Command

Befehl der mit `/` beginnt: `/projekt-init`, `/lint`. In Claude Code ist das
der Weg, einen Skill explizit aufzurufen — alternativ ueber Trigger-Saetze, die
Claude im Frontmatter des Skills erkennt.

## SSoT (Single Source of Truth)

"Einzige Quelle der Wahrheit" — der eine Ort, wo eine Information lebt. In
diesem Setup: `~/Obsidian/SecondBrain/CLAUDE.md` ist die SSoT fuer KI-agnostische
Regeln. Wenn dieselbe Info an mehreren Stellen steht, ist mindestens eine
veraltet — also vermeiden.

## Synthese-Seite

In `04 Ressourcen/<Thema>/<Thema>.md` lebt pro Themenordner eine **lebende
Uebersichts-Seite**. Sie wird vom `/ingest`-Skill mit jeder neuen Notiz reicher.
Karpathys "lebendiges Wiki" in Praxis.

## Vault

Obsidian-Begriff fuer einen **Notiz-Ordner**. Ein Vault ist einfach ein Ordner
mit `.md`-Dateien und einem versteckten `.obsidian/`-Unterordner fuer
Konfiguration. Du kannst mehrere Vaults haben (z.B. ein privates und ein
beruflich-geteiltes). In diesem Setup: ein einziger Vault unter
`~/Obsidian/SecondBrain/`.

## Wikilink

Verlinkung in Obsidian mit doppelten eckigen Klammern: `[[Ziel-Notiz]]` oder mit
Alias `[[Ziel-Notiz|so wird es angezeigt]]`. Vorteile gegenueber Markdown-Links:

- **Bidirektional** — Ziel sieht wer auf sie linkt
- **Ordner-agnostisch** — finden die Datei egal in welchem Unter-Ordner
- **Graph-faehig** — Obsidians Graph-View zeigt das Vault als vernetztes Netz

Der wichtigste Mechanismus in diesem Setup.

## YAML

Datenformat fuer Frontmatter. Sieht so aus:

```yaml
status: aktiv
tags:
  - thema-1
  - thema-2
```

Einrueckung **mit Leerzeichen, niemals Tabs**. Sonst bricht es.

---

[← Zurueck zur README](README.md) · [English glossary](GLOSSARY.md)
