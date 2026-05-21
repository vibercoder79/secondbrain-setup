> # Vault-Hub — Single Source of Truth
> Diese Datei gehoert in den **Wurzel-Ordner deines Obsidian-Vaults** (`~/Obsidian/SecondBrain/CLAUDE.md`).
> Sie ist die Single Source of Truth, auf die alle KI-Configs (globale CLAUDE.md, GEMINI.md, AGENTS.md)
> via `@-Import` verweisen. Dateiname `CLAUDE.md` ist historisch — der Inhalt ist KI-agnostisch.
>
> `${VAULT}` = Pfad zu deinem Obsidian-Vault (z.B. `~/Obsidian/SecondBrain/`)

# Vault Context

Dieses Vault ist ein Zweites Gehirn fuer projektuebergreifendes Wissen.

<!-- TODO Leser: Hier ein Satz oder zwei zu deinem Persoenlichkeitsprofil ergaenzen,
     oder auf eine separate Datei verweisen, z.B. `00 Kontext/Ueber mich.md`. -->

## Vault-Sprache

Gemischt: Deutsch und Englisch. Beide Sprachen sind gleichberechtigt im Vault.

<!-- TODO Leser: An deine Arbeitssprache anpassen. -->

## Vault-Struktur

- `00 Kontext/`: Persoenliches Kontext-Profil (Ueber mich.md, ICP.md, Angebot.md, Schreibstil.md, Branding.md). Zentrale Referenz fuer alle inhaltlichen Aufgaben. Lies diese Dateien wenn du Content erstellst, Mails schreibst oder Angebote formulierst.
- `01 Inbox/`: Schnelle Gedanken, Brain Dumps, unverarbeitete Notizen. Alles was noch keinen festen Platz hat landet hier.
- `02 Projekte/`: Aktive Projekte mit konkretem Ziel und Enddatum. Folgen einer festen Struktur — siehe Abschnitt "Projekte anlegen" weiter unten.
- `03 Bereiche/`: Laufende Verantwortungsbereiche ohne Enddatum. Jeder Bereich ist ein eigener Ordner, weil Bereiche ueber die Zeit wachsen und mehrere Dateien sammeln. Enthaelt u.a. `Skills/` — die zentrale Dokumentation aller KI-Skills (qualitative Doku, Zusatzinfos, Versionshistorie).
- `04 Ressourcen/`: Referenzmaterial, Wissen, gesammelte Informationen. Jedes Thema ist ein eigener Ordner. Deep Researches kommen nach `04 Ressourcen/Research/` — siehe separaten Abschnitt "Deep Research ablegen" fuer die genaue Struktur.
- `05 Daily Notes/`: Taegliches Logbuch. Was an einem Tag passiert ist, welche Entscheidungen getroffen wurden, was offen ist. Gibt der KI die Kontinuitaet zwischen Sessions.
- `06 Archiv/`: Abgeschlossene Projekte und inaktive Bereiche. Aus dem aktiven Blickfeld, aber durchsuchbar.
- `07 Anhaenge/`: Bilder, PDFs, Medien. Obsidian legt hier automatisch alle eingefuegten Dateien ab.

## Regeln fuer dieses Vault

- Nutze `[[Wikilinks]]` fuer Verknuepfungen zwischen Notizen
- Neue Notizen ohne klaren Platz kommen in `01 Inbox/`
- Halte Notizen atomar: eine Idee pro Notiz wo moeglich. Ausnahme: Daily Notes fassen einen ganzen Tag zusammen.
- Daily Notes benennen im Format: `YYYY-MM-DD.md` (z.B. `2026-04-08.md`). So sortieren sie automatisch chronologisch.
- Nutze YAML Frontmatter: `tags`, `status` (aktiv/abgeschlossen/pausiert), `date`, `source`, `chat_url`
- WICHTIG — Dieses Vault wird typischerweise von mehreren KIs genutzt (z.B. Claude, ChatGPT, Gemini, Codex, Grok, Perplexity). Damit klar ist, welche KI welchen Eintrag erstellt hat und der Nutzer jederzeit zum Original-Chat zurueckspringen kann, gilt:
- JEDER Eintrag MUSS `source: <ki-name>` (z.B. `claude`, `gemini`, `codex`, `chatgpt`) und `chat_url: <link>` im Frontmatter enthalten. Wenn du die Chat-URL nicht kennst, schreibe `chat_url: unbekannt` — niemals weglassen.
- Bei Daily Notes: Markiere deinen Abschnitt mit `> [!info] Via <KI-Name> — [Original-Chat](url)`
- Jede KI hat ihre eigene globale Config-Datei (CLAUDE.md, GEMINI.md, AGENTS.md, ...) mit den gleichen Tracking-Regeln. Die Tracking-Regel ist KI-agnostisch — jede KI ersetzt `source:` mit ihrem eigenen Wert.
- Dateinamen in normaler Schreibweise mit Leerzeichen und Grossbuchstaben: `Beschreibender Name.md`
- Neue Projekte werden nach der Struktur in `[[00 Kontext/Projekt-Struktur]]` angelegt. Siehe Abschnitt "Projekte anlegen" fuer Kurzregeln.
- Bereiche und Ressourcen sind immer Ordner, weil sie ueber die Zeit wachsen
- Abgeschlossene Projekte nach `06 Archiv/` verschieben. Nur auf Anweisung des Nutzers, nicht eigenstaendig.
- Wenn du Dateien erstellst oder verschiebst, erklaere kurz warum
- Bevor du Dateien loeschst oder ueberschreibst, frag nach
- Wenn der Nutzer sagt "merk dir das" oder "speicher das", speichere es dort wo es thematisch hingehoert. Schreibregeln nach `00 Kontext/Schreibstil.md`, Projekt-Infos in die jeweilige Projekt-Datei, technische Erkenntnisse in `04 Ressourcen/`, Vault-Regeln in diese CLAUDE.md. Im Zweifel kurz fragen wo es hin soll.

## Session-Routinen

### Bei Session-Start
1. Lies `Index.md` im Vault-Root als **Vault-Cover** (vom `/lint` regeneriert) — gibt sofort Ueberblick ueber aktive Projekte, Bereiche, Synthese-Seiten, letzte Daily Notes und Vault-Statistik. Spart Tokens gegenueber Volltextsuche oder Glob-Scans.
2. Pruefe `01 Inbox/` auf neue Notizen, zeige was drin liegt, und biete an die Eintraege in die passenden Ordner einzusortieren

### Kontext bei Bedarf
Wenn der Nutzer fragt "Was ist gerade aktuell?", "Wo war ich stehen geblieben?" oder aehnliches: `Index.md` gibt den Schnell-Ueberblick. Fuer mehr Tiefe: letzte 2-3 Daily Notes in `05 Daily Notes/` und die aktiven Projekt-Dateien in `02 Projekte/`.

> [!info] Hinweis zur Aktualitaet
> `Index.md` wird vom `/lint` Skill bei jedem Lauf vollstaendig regeneriert (atomar). Wenn der letzte Lint-Lauf laenger zurueckliegt (siehe Frontmatter `generated_at` in `Index.md`), ist der Index ggf. veraltet — dann zusaetzlich Daily Notes pruefen oder `/lint index` neu laufen lassen.

### Bei Session-Ende
Wenn der Nutzer die Session beendet oder du merkst dass ein natuerliches Ende erreicht ist, biete an:
1. Einen Daily Note Eintrag in `05 Daily Notes/` zu erstellen mit einer Zusammenfassung des Tages — **nach dem Daily-Note-Pattern unten**
2. Neue Erkenntnisse als Notizen zu speichern (ggf. in den richtigen Projekt/Bereich/Ressourcen-Ordner)
3. Die Inbox aufzuraeumen falls noetig

## Daily-Note-Pattern (Projekt-Hub-Integration)

Daily Notes sind die **SSoT fuer Tagesaktivitaeten**. Projekt-Hubs ziehen daraus automatisch via Dataview, das heisst **der Hub wird fuer Tages-Infos nicht manuell gepflegt**.

### Schreib-Regeln fuer Daily Notes

1. **Ein File pro Tag** — `05 Daily Notes/YYYY-MM-DD.md`, chronologische Sortierung.
2. **Projekt-Sektionen** — jede Session/jedes Thema bekommt eine H2-Sektion `## <Projekt> #<tag>`, z.B. `## Beispiel-Projekt #beispiel-projekt`.
3. **Tags im Frontmatter** — pro beruehrtem Projekt ein Tag (plus Standard `daily`). Beispiel:
   ```yaml
   tags:
     - daily
     - beispiel-projekt
     - mein-projekt
   ```
4. **Wikilink zum Projekt-Hub** — in jeder Projekt-Sektion oben: `> [!info] Via <KI-Name> — [[<Projekt> PMO HUB]]`
5. **Inhalt** je Sektion: was wurde gemacht, Entscheidungen (mit Wikilinks zu ADRs), Offene Punkte. Keine Duplikation — Entscheidungen leben in `Decisions/`, die Daily nennt nur den Titel + Wikilink.

### Projekt-Hub nutzt Dataview — keine manuelle Pflege

Jeder Projekt-Hub (z.B. `02 Projekte/Beispiel-Projekt/Beispiel-Projekt - PMO HUB.md`) hat eine Sektion `## Tagesaktivitaeten` mit einer Dataview-Query:

````markdown
## Tagesaktivitaeten

```dataview
LIST file.link
FROM "05 Daily Notes"
WHERE contains(file.tags, "#<projekt-tag>")
SORT file.name DESC
LIMIT 30
```
````

Der Hub zeigt damit automatisch die letzten 30 Tage an denen am Projekt gearbeitet wurde. Keine Redundanz.

### SSoT-Regeln (was wird WO geschrieben)

| Datenart | SSoT (schreiben) | Wo sichtbar |
|----------|-----------------|-------------|
| Tagesaktivitaeten | `05 Daily Notes/YYYY-MM-DD.md` | Projekt-Hub §Tagesaktivitaeten (Dataview) |
| Entscheidungen (ADRs) | `02 Projekte/<projekt>/Decisions/ADR-XX.md` | Hub §ADRs (manuelle Index-Tabelle) |
| Komponenten-Status | `02 Projekte/<projekt>/Components/*.md` | Hub §Components (Wikilinks) |
| Sprint-Retros | `journal/sprint-*.md` im Projekt-Repo + Mirror `04 Ressourcen/<projekt>/sprints/` | `04 Ressourcen/<projekt>/learnings.md` (Dataview) |
| Meetings | `02 Projekte/<projekt>/Meetings/YYYY-MM-DD.md` | Hub §Meetings (Dataview oder Wikilinks) |
| Research | `02 Projekte/<projekt>/Research/*.md` | Hub §Research (manuelle Verweise) |

Regel: **Schreiben im SSoT, Hub zeigt nur.** Wenn Inhalt an mehreren Stellen stehen muss → Wikilink statt Copy-Paste.

### Beispiel-Struktur einer Daily Note

```markdown
---
tags:
  - daily
  - beispiel-projekt
  - mein-projekt
date: 2026-04-18
source: claude
chat_url: https://claude.ai/chat/...
---

# 2026-04-18

## Beispiel-Projekt #beispiel-projekt

> [!info] Via Claude — [[Beispiel-Projekt - PMO HUB]]

### Was wurde gemacht
- v0.6.0 Blueprint-Ordner angelegt
- ADR-10 revidiert nach Deep-Research

### Entscheidungen
- [[Decisions/ADR-10 Beispiel-Entscheidung]] — Begruendung kurz erklaert

### Offen fuer naechste Session
- [ ] Naechsten Schritt umsetzen (Ticket-ID im Backlog-Tool)

## Mein Projekt #mein-projekt

> [!info] Via Claude — [[Mein Projekt PMO HUB]]

...
```

## Projekte anlegen

Projekte folgen einer festen Struktur. Komplette Templates, Frontmatter-Standards und Beispiele stehen in `[[00 Kontext/Projekt-Struktur]]`.

**Vollstaendige Methodik (9 Onboarding-Fragen, Phasen-Workflow, Defaults pro Projekt-Typ):**
`[[00 Kontext/Workflows/Projekt-Anlegen]]` — Single Source of Truth fuer alle KIs (Claude, Gemini, Codex, ...). Diese Datei ersetzt die internen References von KI-Skills als Wissens-Quelle.

### Kurzregeln
- **IMMER Ordnerstruktur:** Jedes Projekt bekommt sofort einen Ordner mit Hub-Datei + `Projekt-Governance.md` + `Meetings/` + `Decisions/` + `Research/` + `assets/`
- **Keine Einzeldatei-Projekte** — es gibt nur noch die Ordner-Variante
- **`Projekt-Governance.md` ist Pflicht:** Tool-Stack + Backlog-Konvention pro Projekt. Default `backlog_tool: none` wenn nicht festgelegt.
- **Obsidian = Wissen, Backlog-Tool = Arbeit.** Tasks gehen ins Backlog-Tool (Linear, Teams-Kanban, GitHub Issues, ...). Obsidian haelt Meetings, Decisions, Research.
- **Meeting Notes:** Eigene Datei pro Meeting in `Meetings/` (optional Subordner Kunde/Intern/Entwicklung)
- **Decisions als ADRs:** Eine Datei pro Entscheidung in `Decisions/` mit `status: offen | entschieden | verworfen`
- **Hub-Datei zeigt Dataview-Sichten** auf Decisions und offene Action Items — keine doppelt gepflegten Listen
- **Pflicht-Frontmatter Hub:** `tags`, `status`, `phase`, `erstellt`, `aktualisiert`, `source`, `chat_url`, `governance`

### Trigger-Befehle
Bei diesen Saetzen automatisch ein Projekt nach dem Template anlegen (siehe `[[00 Kontext/Projekt-Struktur]]`) — IMMER ZUERST Onboarding-Dialog (9 Fragen):
- "lege ein Projekt an"
- "neues Projekt"
- "Projekt anlegen"
- "erstelle ein Projekt fuer..."

Ausnahme Onboarding: Operator sagt "ohne Fragen" oder "Standard" → Defaults aus Default-Tabelle in Projekt-Struktur verwenden.

Bei Backlog-/Risk-/Financials-bezogenen Saetzen IMMER ZUERST `Projekt-Governance.md` lesen, dann handeln:
- "uebertrag Action Items nach [Tool]" / "leg Tasks aus Meeting an"
- "leg User Story aus letzter Decision an"
- "sync den Backlog-Status"
- "neue Entscheidung" / "leg eine Decision an" / "ADR fuer ..."

Opt-in-Trigger fuer optionale Tracking-Disziplinen:
- "aktiviere Risk-Tracking" → legt `Risks/` an, setzt `risk_register: enabled`
- "neues Risiko" / "leg ein Risiko an" → Risk-File anlegen (Voraussetzung: aktiviert)
- "leg Mitigations aus Risiko XYZ an" → Mitigations ins Backlog uebertragen
- "aktiviere Financials" → legt `Financials.md` an, setzt `financials_tool`

## Deep Research ablegen

Wenn der Nutzer eine Deep Research durchfuehrt oder mehrere zusammenhaengende Research-Ergebnisse produziert, gilt:

### Einfache Research (ein Thema, ein Dokument)
Direkt als Einzeldatei in `04 Ressourcen/Research/` im Format:
```
YYYY-MM-DD Thema.md
```

### Komplexe Research (mehrere zusammenhaengende Dokumente oder mit Grafiken)
Als Ordner in `04 Ressourcen/Research/` anlegen:
```
YYYY-MM-DD Thema/
├── README.md                     ← Einstiegs-Zusammenfassung mit Wikilinks
├── 01-Dokument-Name.md           ← Erstes Original-Dokument (vollstaendig)
├── 02-Dokument-Name.md           ← Weiteres Original-Dokument (vollstaendig)
├── 03-Dokument-Name.md           ← ...
└── assets/
    └── grafik.svg                ← Diagramme, Bilder, Artefakte
```

Regeln fuer komplexe Research:
- `README.md` ist der Einstieg: kurze Zusammenfassung, Kernerkenntnisse, offene Punkte, Wikilinks zu allen Unter-Dokumenten
- Alle im Chat erzeugten Artefakte (Research-Dokumente, Prompts, Grafiken, Diagramme) werden VOLLSTAENDIG abgelegt — nicht gekuerzt oder paraphrasiert
- Grafiken und Diagramme kommen als SVG/PNG in den `assets/` Unterordner und werden via `![[dateiname.svg]]` in die passende Markdown-Datei eingebettet
- Unter-Dokumente nutzen `parent: "[[README]]"` im Frontmatter fuer Navigation in beide Richtungen
- Dateinamen mit Prefix-Nummern (`01-`, `02-`, `03-`) fuer empfohlene Lesereihenfolge
- Tracking-Regeln (`source:`, `chat_url:`) gelten in jeder einzelnen Datei

### Trigger-Befehle
Wenn der Nutzer einen dieser Saetze verwendet, nutze automatisch das Komplex-Research-Muster:
- "archiviere das komplett"
- "leg das als Research-Paket ab"
- "speicher das vollstaendig mit allen Dokumenten"

Bei Unsicherheit ob einfach oder komplex: kurz fragen. Mehrere Deep Researches zum gleichen Thema, Grafiken/Diagramme, oder Dokumente >2000 Woerter sind klare Indikatoren fuer das Komplex-Muster.

## Skills-Dokumentation

Die qualitative Dokumentation aller KI-Skills liegt zentral in `03 Bereiche/Skills/`. Das SecondBrain ist die Single Source of Truth fuer Skill-Wissen — nicht der Skill-Ordner selbst.

### Drei-Ebenen-Modell

| Ebene | Zweck | Ort |
|-------|-------|-----|
| Implementation | SKILL.md, scripts/, templates/ | `~/.claude/skills/` (oder analog fuer andere KIs) |
| Code & Versioning | README.md, Changelog | GitHub: `<dein-handle>/<skill-repo>` |
| Wissen & Kontext | Doku, Zusatzinfos, Verknuepfungen | SecondBrain: `03 Bereiche/Skills/` |

### Regeln

- Pro Skill eine Datei: `03 Bereiche/Skills/<skill-name>.md`
- Frontmatter: `tags: [ki-skill]`, `skill`, `version`, `aktualisiert`, `status`
- Skills koennen auf Kontext im SecondBrain verweisen statt eigene Referenzen mitzuschleppen (z.B. Farbschema aus `00 Kontext/Branding.md`, Schreibstil aus `00 Kontext/Schreibstil.md`)
- Bei jeder Skill-Aenderung auch die Doku in `03 Bereiche/Skills/` aktualisieren
