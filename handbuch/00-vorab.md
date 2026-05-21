# 00 — Vorab: was du vorher wissen solltest

> Kurzfassung: Wenn du noch nie Obsidian, Markdown oder ein KI-CLI benutzt hast,
> ist dieses Kapitel fuer dich. Wenn du das alles kennst, ueberspringe direkt
> zu [Kapitel 01](01-philosophie.md).

## Habe ich das richtige Repo?

Drei Fragen, ehrlich beantworten:

1. **Nutzt du mindestens zwei KIs im Alltag?** (z.B. Claude und ChatGPT, oder
   Claude und Gemini, oder Claude und Perplexity)
   - Ja → weiter
   - Nein → wahrscheinlich uebertrieben fuer dich. Vielleicht reicht eine
     einfache Markdown-Notiz-App.

2. **Kennst du dich mit dem Terminal aus?** (`cd`, `mkdir`, `bash` Skripte
   ausfuehren)
   - Ja → weiter
   - Nein → moeglich, aber Lernkurve. Plane Zeit ein.

3. **Bist du bereit, taeglich (oder fast taeglich) eine Notiz zu schreiben?**
   - Ja → das System lebt von Daily Notes
   - Nein → das System wird verkruemmern. Vielleicht erstmal eine
     Notiz-Routine etablieren ohne KI-Setup.

Wenn du 2x oder 3x "Ja" hast: dieses Setup passt. Wenn du 2x "Nein" hast:
spar dir die Zeit.

## Was ist Obsidian?

[Obsidian](https://obsidian.md) ist ein **kostenloser Markdown-Editor**. Du
oeffnest einen Ordner mit `.md`-Dateien, und Obsidian behandelt ihn wie eine
Datenbank: mit Suche, Verlinkung, Visualisierung als Graph, Plugins.

Drei Dinge die Obsidian besonders macht:

1. **Alles lokal.** Deine Notizen liegen als normale Markdown-Dateien auf
   deiner Festplatte. Du kannst sie mit jedem Texteditor lesen. Kein
   Vendor-Lock-in.
2. **Wikilinks.** Mit `[[Andere Notiz]]` verlinkst du Notizen
   bidirektional — die Ziel-Notiz weiss wer auf sie linkt.
3. **Plugin-System.** Tausende Erweiterungen. Wichtigstes Plugin fuer dieses
   Setup: **Dataview** (macht aus deinen Notizen eine Datenbank).

In Obsidian heisst ein Notiz-Ordner **Vault**. Du kannst mehrere Vaults haben.
In diesem Setup nutzen wir genau einen: `~/Obsidian/SecondBrain/`.

## Was ist Markdown?

Markdown ist Text mit **leichten Formatierungs-Zeichen**:

```markdown
# Eine Ueberschrift
## Eine Unter-Ueberschrift

Normaler Absatz. **Fettes Wort.** *Kursives Wort.*

- Aufzaehlung
- Noch ein Punkt

[Link-Text](https://beispiel.de)
```

Wenn du jemals etwas auf GitHub kommentiert hast, hast du Markdown geschrieben.
Wenn nicht: 5 Minuten [Markdown-Tutorial](https://www.markdownguide.org/basic-syntax/)
reicht.

## Was ist ein KI-CLI?

CLI = Command Line Interface. Programme die du im **Terminal** ausfuehrst,
nicht in einer App mit Maus. Beispiele:

- **Claude Code** (`claude`) — Anthropics offizielles CLI fuer Claude
- **Gemini CLI** (`gemini`) — Googles CLI fuer Gemini
- **Codex CLI** (`codex`) — OpenAIs CLI fuer ihre Code-Modelle

Im Gegensatz zu Web-Apps und Desktop-Apps koennen CLIs:

- Auf deine Dateien zugreifen (mit deiner Erlaubnis)
- Befehle ausfuehren
- Sich gegenseitig anrufen (Subagenten)
- Skills/Slash-Commands haben

Fuer dieses Setup ist **mindestens eine KI mit CLI** sinnvoll. Wenn du nur die
Web-Apps nutzt, kannst du das Vault zwar manuell pflegen, aber die Automation
(Skills, MCP, KI-agnostische Workflows) verlierst du.

## Was ist MCP?

MCP = **Model Context Protocol.** Ein Standard von Anthropic aus 2024.

Vereinfacht: ein MCP-Server ist ein kleines Programm, das einer KI **Zugriff
auf etwas Externes** gibt. Beispiele:

- **Filesystem-MCP** — gibt der KI Lese-/Schreib-Zugriff auf einen Ordner
- **Linear-MCP** — gibt der KI Zugriff auf dein Linear-Projektboard
- **Perplexity-MCP** — gibt der KI eine "Frag-Perplexity"-Funktion

In diesem Setup zentral fuer **Claude Desktop**: damit Claude Desktop dein
Vault lesen und schreiben kann, brauchst du einen Filesystem-MCP-Server, der
auf deinen Vault-Pfad zeigt. Details in [Kapitel 04](04-multi-ki-setup.md).

## Was ist `@-Import`?

In den Konfigurations-Dateien von Claude Code und Gemini CLI bedeutet
`@/pfad/zur/datei.md`, dass die Ziel-Datei **eingelesen** wird.

Beispiel `~/.gemini/GEMINI.md`:

```markdown
## SecondBrain-Regeln

@~/Obsidian/SecondBrain/CLAUDE.md
```

Wenn Gemini startet, liest es seine globale Config und folgt dem `@`-Verweis —
der gesamte Inhalt der Ziel-Datei wird als Kontext geladen. Damit kann eine
Aenderung in der Vault-CLAUDE.md alle KIs sofort betreffen, ohne dass du jede
KI-Config einzeln anfassen musst. Genau das ist der **Hub-and-Spoke-Trick**
(siehe Kapitel 02).

## Was ist Dataview?

Obsidian-Plugin. **Pflicht** fuer dieses Setup.

Mit Dataview kannst du in Markdown Queries schreiben, die wie SQL aussehen:

````markdown
```dataview
LIST file.link
FROM "05 Daily Notes"
WHERE contains(file.tags, "#mein-projekt")
SORT file.name DESC
LIMIT 10
```
````

Obsidian rendert das als **Live-Liste** — sortiert, gefiltert, automatisch
aktuell. In diesem Setup nutzen Projekt-Hubs Dataview, um Daily-Note-Eintraege,
Decisions und Action Items automatisch zu aggregieren.

**Installation:** Obsidian → Settings → Community Plugins → Browse → "Dataview"
suchen → Install → Enable.

## Was ist ein Wikilink?

Statt klassischer Markdown-Links `[Text](pfad)` nutzt Obsidian
`[[Wikilinks]]`:

```markdown
Siehe [[Mein-Projekt - PMO HUB]] fuer Details.
```

Drei Vorteile:

1. **Bidirektional** — Obsidian zeigt in der Ziel-Notiz, wer auf sie linkt
2. **Ordner-agnostisch** — der Wikilink findet die Datei egal in welchem
   Unter-Ordner sie liegt
3. **Graph-faehig** — Obsidians Graph-View zeigt das Vault als vernetztes Netz

Wikilinks sind der **wichtigste Mechanismus** in diesem Setup. Ohne sie keine
Vernetzung, kein Compound-Effekt, kein Karpathy-Pattern.

## Was ist Frontmatter?

Der YAML-Block am Anfang einer Notiz, zwischen `---`-Linien:

```yaml
---
tags: [thema-1, thema-2]
status: aktiv
date: 2026-05-21
source: claude
chat_url: https://claude.ai/chat/...
---

# Eigentlicher Notiz-Inhalt ab hier
```

Diese **Metadaten** sind kritisch. Dataview-Queries filtern darueber. Skills
nutzen sie. Multi-KI-Tracking (welche KI hat geschrieben?) basiert auf
`source:`. Wenn du Frontmatter weglaesst, funktionieren die Automatismen
nicht.

## Bin ich jetzt bereit?

Wenn du die Begriffe oben verstanden hast: ja.

Wenn nicht: starte mit Obsidian. Installier es. Leg ein Test-Vault an. Schreib
eine Notiz. Setz einen Wikilink. Aktivier Dataview. Wenn das funktioniert,
bist du bereit fuer [Kapitel 01](01-philosophie.md).

## Glossar

Alle Begriffe als kompakte Liste: [GLOSSAR.md](../GLOSSAR.md)

## Naechstes Kapitel

→ [01 — Philosophie: Warum dieses Setup existiert](01-philosophie.md)
