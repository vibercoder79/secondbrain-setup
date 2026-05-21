> # Globale Codex CLI Config — Template
> Diese Datei gehoert nach `~/.codex/AGENTS.md`.
> Sie laedt die Vault-CLAUDE.md (KI-agnostisch) und ergaenzt Codex-spezifische Regeln.
>
> `${VAULT}` = Pfad zu deinem Obsidian-Vault (z.B. `~/Obsidian/SecondBrain/`)

# Globale Regeln

## Sprache

Alle Kommunikation und Dokumentation auf Deutsch.

<!-- TODO Leser: An deine Arbeitssprache anpassen. -->

## Zweites Gehirn (SecondBrain)

Projektuebergreifendes Wissenssystem unter `~/Obsidian/SecondBrain/`.

Die massgeblichen Regeln, Routinen und Pfade fuer das SecondBrain stehen in der
Vault-eigenen Regel-Datei. Falls Codex CLI `@-Import` unterstuetzt, wird sie hier
direkt eingebunden:

@~/Obsidian/SecondBrain/CLAUDE.md

**Fallback ohne @-Import:** Lies zu Session-Start aktiv die Vault-Datei
`~/Obsidian/SecondBrain/CLAUDE.md` und befolge deren Regeln. Sie ist die Single Source
of Truth fuer alle KIs (Claude, Gemini, Codex, ...). Der Dateiname `CLAUDE.md` ist
historisch — der Inhalt ist KI-agnostisch und gilt ebenso fuer Codex.

## Schnell-Regeln (Fallback falls Vault-Datei nicht geladen wurde)

Damit das Minimum auch ohne geladene Vault-Datei funktioniert:

- **Inbox:** Neue Notizen ohne klaren Platz nach `~/Obsidian/SecondBrain/01 Inbox/`
- **Daily Note:** Ein File pro Tag unter `~/Obsidian/SecondBrain/05 Daily Notes/YYYY-MM-DD.md`
- **Projekte:** Eigener Ordner in `~/Obsidian/SecondBrain/02 Projekte/<projekt>/` mit Hub-Datei + `Projekt-Governance.md` + `Meetings/` + `Decisions/` + `Research/`
- **Frontmatter Pflicht:** `source: codex`, `chat_url: <link-oder-"unbekannt">` in jedem Eintrag
- **Bei Daily Notes:** Sektions-Header mit `> [!info] Via Codex — [Original-Chat](url)`
- **Wikilinks** fuer Verknuepfungen, atomare Notizen (eine Idee pro Notiz)

## Chat-Archivierung (Codex-spezifisch)

Zusaetzlich zur Daily Note werden substantielle Codex-Chat-Verlaeufe standardmaessig
im Vault archiviert.

**Default-Speicherort:** `~/Obsidian/SecondBrain/04 Ressourcen/Codex - OpenAI/`

**Trigger:**
- Bei Session-Ende proaktiv anbieten
- Auf Zuruf bei "speicher das" / "archivier den Chat"
- NICHT nach jeder Nachricht

**Filter:**
- Nur Sessions mit Substanz (>2-3 Nachrichten, erkennbares Thema)
- NICHT: trivialer Smalltalk, reine Setup-Sessions

**Naming:** `YYYY-MM-DD-HHMM-kurzthema.md`

**Frontmatter:**
```yaml
---
tags: [codex-chat]
datum: YYYY-MM-DD
thema: kurzbeschreibung
source: codex
chat_url: unbekannt
---
```

**Aufbau:**
1. Zusammenfassung (2-3 Saetze)
2. Kompletter Verlauf (Nutzer + Codex, chronologisch)

**Wann NICHT in dieses Verzeichnis:**
- Wenn Nutzer expliziten anderen Speicherort nennt
- Bei Projekt-Zugehoerigkeit → `02 Projekte/<projekt>/`
- Bei Deep Research → `04 Ressourcen/Research/`

## Projekte anlegen

Folge der KI-agnostischen Methodik in `~/Obsidian/SecondBrain/00 Kontext/Workflows/Projekt-Anlegen.md`.
Bei diesen Trigger-Saetzen ZUERST den 9-Fragen-Onboarding-Dialog starten:

- "lege ein Projekt an"
- "neues Projekt"
- "Projekt anlegen"
- "erstelle ein Projekt fuer..."

Ausnahme: "ohne Fragen" oder "Standard" → Defaults aus der Workflow-Datei verwenden.

## Secrets-Policy

- NIEMALS API-Keys, Tokens, Passwoerter oder Credentials in Dateien schreiben
- NIEMALS Secrets in Git committen
- Secrets gehoeren in Umgebungsvariablen oder einen Secret Manager (z.B. macOS Keychain)
- `.env`-Dateien IMMER in `.gitignore` eintragen

## Arbeitsregeln

- Datei erst lesen, dann aendern
- Bestehende Dateien editieren statt neue zu erstellen
- Bevor Dateien geloescht oder ueberschrieben werden: kurz fragen
- Wenn Dateien erstellt oder verschoben werden: kurz erklaeren warum
