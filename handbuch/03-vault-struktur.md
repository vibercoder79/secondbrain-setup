# 03 — Vault-Struktur: PARA in Praxis

> Kurzfassung: Acht nummerierte Ordner (00-07), drei Pflicht-Dateien im Wurzel,
> Pflicht-Frontmatter fuer jede Notiz. Wer sich an die Konventionen haelt, braucht
> nie nachzudenken wo etwas hingehoert.

## Die acht Ordner

```
~/Obsidian/SecondBrain/
├── 00 Kontext/         Persoenliches Profil + KI-agnostische Methodik
├── 01 Inbox/           Brain Dumps und unverarbeitete Notizen
├── 02 Projekte/        Aktive Projekte mit Ziel und Enddatum
├── 03 Bereiche/        Laufende Verantwortungsbereiche (ohne Enddatum)
├── 04 Ressourcen/      Referenzmaterial, Research, KI-Chat-Archive
├── 05 Daily Notes/     Ein File pro Tag
├── 06 Archiv/          Abgeschlossene Projekte und inaktive Bereiche
└── 07 Anhaenge/        Bilder, PDFs, Medien (Obsidian-Default)
```

Die Nummern-Praefixe sind kein Zufall — sie sortieren in Obsidians File-Explorer
nach Handlungs-Druck, nicht alphabetisch. `00` ist Fundament, `01` ist Eingang, dann
laeuft es nach unten zu `07` Anhaengen.

### 00 Kontext — das Fundament

Hier liegt dein **Profil** und die **methodische Bibliothek**:

```
00 Kontext/
├── Über mich.md              (Wer du bist, Hintergrund)
├── ICP.md                    (Wenn du Kunden hast: ideale Zielgruppe)
├── Angebot.md                (Wenn relevant: was du anbietest)
├── Schreibstil.md            (Tonalitaet, Stil-Regeln)
├── Branding.md               (Wenn du eine Marke hast)
├── Projekt-Struktur.md       (★ Templates fuer Projekt-Anlage)
├── User-Story-Template.md
└── Workflows/
    └── Projekt-Anlegen.md    (★ KI-agnostische Methodik)
```

KIs lesen diese Dateien wenn sie Content erstellen, Mails schreiben, oder ein neues
Projekt anlegen. Wenn du dich aenderst — Schreibstil, Zielgruppe, Branding — aenderst
du eine Datei und alle KIs ziehen die neue Version.

**Fuer dein eigenes Setup:** Die Templates `Projekt-Struktur.md` und
`Workflows/Projekt-Anlegen.md` aus diesem Repo (`templates/vault/00 Kontext/`)
sind generisch. Die Profile (`Über mich.md`, `ICP.md` etc.) musst du selbst
schreiben — sie sind dein Inhalt, nicht das Setup.

### 01 Inbox — der Eingang

Alles was noch keinen festen Platz hat: schnelle Notiz aus einem Telefongespraech,
Idee unter der Dusche, ungelesener Artikel-Link, KI-Output den du noch nicht
einsortiert hast.

**Regel:** Inbox soll **leer** sein. Mehr als 5 Eintraege ist ein Warnsignal. Der
`/lint`-Skill warnt automatisch wenn die Inbox ueberlaeuft.

### 02 Projekte — das Operative

Projekte haben ein **Ziel** und ein **Enddatum**. "Website neu aufbauen", "Q3
Newsletter schreiben", "Trading-Algorithmus implementieren". Wenn keines von beidem
zutrifft, ist es kein Projekt — es ist ein Bereich (`03`).

Jedes Projekt ist ein **Ordner**, niemals eine einzelne Datei. Die Ordner-Struktur
ist erzwungen (siehe Kapitel 06 — Skills, `/projekt-init`):

```
02 Projekte/<Projekt-Name>/
├── <Projekt-Name> - PMO HUB.md   (★ Landing Page)
├── Projekt-Governance.md          (★ Tool-Stack, Backlog-Anbindung)
├── Meetings/                      (Eine Datei pro Meeting)
├── Decisions/                     (ADRs — Architecture Decision Records)
├── Research/                      (Projektbezogene Recherche)
└── assets/                        (Diagramme, Anhaenge)
```

**Container-Praefix `_`:** Wenn du mehrere zusammengehoerende Projekte hast
(z.B. alle Kundenprojekte einer Firma), kannst du sie in einen Container-Ordner
mit Underscore-Praefix legen: `02 Projekte/_KUNDEN/`. Container haben selbst keinen
Hub — sie sind nur Sammler.

### 03 Bereiche — die Verantwortungen

Laufende Verantwortungen ohne Enddatum: "Finanzen", "Gesundheit", "Mitarbeitende",
"Lifelong Learning". Jeder Bereich ist ein Ordner (weil Bereiche ueber die Zeit
wachsen und mehrere Dateien sammeln).

Hier liegt auch `03 Bereiche/Skills/` — die qualitative Doku aller Skills, die du
nutzt. Die technische Implementation der Skills liegt in `~/.claude/skills/`, der
Code auf GitHub. Die Wissens-Ebene liegt hier.

### 04 Ressourcen — das Referenzmaterial

Alles was du als Nachschlagewerk brauchst: Research-Ergebnisse, Artikel-Zusammen-
fassungen, KI-Chat-Archive, technische Dokumentation. Jedes Thema ist ein Ordner.

**Spezielle Unter-Strukturen:**

- `04 Ressourcen/Research/YYYY-MM-DD Thema/` — Deep Researches (siehe Kapitel 05)
- `04 Ressourcen/Gemini/` — archivierte Gemini-Chat-Verlaeufe
- `04 Ressourcen/Codex - OpenAI/` — archivierte Codex-Chat-Verlaeufe
- `04 Ressourcen/Claude Desktop/` (optional) — wenn du Claude Desktop nutzt

Pro Themenordner gibt es eine **Synthese-Seite** mit demselben Namen wie der
Ordner (z.B. `04 Ressourcen/Claude Code/Claude Code.md`). Diese Seite ist der
Einstieg in das Thema und wird vom `/ingest`-Skill mit jeder neuen Notiz reicher.
Das ist Karpathys lebendiges Wiki.

### 05 Daily Notes — das Logbuch

Ein File pro Tag, benannt `YYYY-MM-DD.md`. Format:

```markdown
---
tags:
  - daily
  - projekt-tag-1
  - projekt-tag-2
date: 2026-05-21
source: claude
chat_url: https://claude.ai/chat/...
---

# 2026-05-21

## Mein-Projekt #projekt-tag-1

> [!info] Via Claude — [[Mein-Projekt - PMO HUB]]

### Was wurde gemacht
- ...

### Entscheidungen
- [[Decisions/ADR-03 Datenbank-Wahl]]

### Offen
- [ ] Setup-Script schreiben
```

Daily Notes sind die **Single Source of Truth fuer Tagesaktivitaeten**. Projekt-Hubs
ziehen automatisch via Dataview-Query aus den Daily Notes mit dem passenden Tag.
Das heisst: du schreibst einmal in die Daily Note, der Hub aktualisiert sich von
selbst.

### 06 Archiv — das Abgeschlossene

Wenn ein Projekt fertig ist oder ein Bereich nicht mehr aktiv: verschieben nach
`06 Archiv/`. Nicht loeschen — wertvoller Kontext fuer spaeter. Nur auf Anweisung
verschieben, nicht automatisch.

### 07 Anhaenge — der Obsidian-Default

Obsidian legt eingefuegte Bilder und PDFs hier ab. Nichts manuell anfassen, einfach
Obsidian seinen Job machen lassen.

## Drei Pflicht-Dateien im Vault-Wurzel

```
~/Obsidian/SecondBrain/
├── CLAUDE.md       ★ Single Source of Truth fuer alle KIs
├── AGENTS.md       Codex-Spiegel mit "Codex"-Sprache (optional, wenn Codex genutzt)
├── Index.md        ★ Vault-Cover (von /lint generiert)
└── log.md          ★ Append-only Chronologie von /ingest und /lint
```

Diese Dateien sind das Rueckgrat:

- **CLAUDE.md** ist die zentrale Regel-Datei (Kapitel 02).
- **Index.md** ist das Vault-Cover. Beim Session-Start liest die KI diese eine
  Datei und hat sofort den Ueberblick: aktive Projekte, Bereiche, Synthese-Seiten,
  letzte Daily Notes, Statistik. Spart Tokens gegenueber Volltextsuche
  ([Karpathy LLM-Wiki-Pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)).
- **log.md** ist die Chronologie. Jeder `/ingest`- und `/lint`-Lauf schreibt
  einen Eintrag.

## Pflicht-Frontmatter

Jede Notiz (Ausnahme: Index.md ist auto-generiert, log.md ist Sonderfall) hat YAML-
Frontmatter am Anfang:

```yaml
---
tags: [thema-1, thema-2]
status: aktiv          # bei Projekten: aktiv | abgeschlossen | pausiert
date: 2026-05-21       # bei Daily Notes und datierten Notizen
source: claude         # WICHTIG fuer Multi-KI-Tracking
chat_url: https://claude.ai/chat/...   # Original-Chat, "unbekannt" wenn unklar
---
```

### Multi-KI-Tracking via `source` und `chat_url`

Wenn mehrere KIs in dasselbe Vault schreiben, ist `source:` unverzichtbar. Du musst
Tage spaeter zurueckverfolgen koennen, welche KI eine bestimmte Notiz geschrieben
hat — fuer Vertrauen, fuer Vergleich, fuer Debugging.

**Werte:**

- `source: claude` — Claude (App, Code, Desktop)
- `source: gemini` — Gemini CLI oder Gemini App
- `source: codex` oder `source: codex-cli` — OpenAI Codex
- `source: perplexity` — Perplexity (via Web Clipper, siehe Kapitel 04)
- `source: chatgpt` — ChatGPT (manuell)

`chat_url` ist die URL zum Original-Chat, damit du jederzeit zurueckspringen kannst.
Wenn die URL unbekannt ist: `chat_url: unbekannt` — **niemals weglassen**.

## Wikilink-Konventionen

Statt klassischer Markdown-Links `[Text](pfad)` nutzt das Vault Obsidians
`[[Wikilink]]`-Syntax:

```markdown
Siehe [[Mein-Projekt - PMO HUB]] fuer Details.
Verwandt: [[2026-05-21 Research zu KI-Markt]]
```

Wikilinks haben drei Vorteile:

1. **Bidirektional** — Obsidian zeigt in der Ziel-Notiz, wer auf sie verlinkt.
2. **Ordner-agnostisch** — der Wikilink `[[Mein-Projekt - PMO HUB]]` findet die
   Datei egal in welchem Unter-Ordner sie liegt.
3. **Graph-faehig** — Obsidians Graph-View zeigt das Vault als vernetztes Wissen.

**Aliasing** mit Pipe: `[[Mein-Projekt - PMO HUB|den Projekt-Hub]]` rendert als
"den Projekt-Hub" und linkt trotzdem zur Ziel-Datei.

## Naming-Konventionen

- **Daily Notes:** `YYYY-MM-DD.md` (z.B. `2026-05-21.md`)
- **Projekt-Hubs:** `<Projekt-Name> - PMO HUB.md` (mit Bindestrich-Suffix)
- **ADR-Decisions:** `ADR-XX <Kurz-Titel>.md` (z.B. `ADR-03 Datenbank-Wahl.md`)
- **Research-Ordner:** `YYYY-MM-DD Thema/` (z.B. `2026-04-15 Karpathy LLM Wiki Konzept/`)
- **Sonstige Notizen:** Beschreibender Name in normaler Schreibweise mit Leerzeichen
  und Grossbuchstaben (z.B. `Cybersecurity Framework ROI Studie.md`)

Konsistente Naming-Konventionen sind wichtig, weil Wikilinks darauf basieren. Wenn
du heute `[[Projekt X]]` schreibst und morgen `[[projekt-x]]`, hast du zwei
verschiedene Targets.

## Naechstes Kapitel

→ [04 — Multi-KI-Setup: Claude, Gemini, Codex, Claude Desktop, Perplexity](04-multi-ki-setup.md)
