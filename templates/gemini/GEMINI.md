> # Globale Gemini CLI Config — Template
> Diese Datei gehoert nach `~/.gemini/GEMINI.md`.
> Sie nutzt `@-Import` um die Vault-CLAUDE.md als Single Source of Truth zu laden.
>
> `${VAULT}` = Pfad zu deinem Obsidian-Vault (z.B. `~/Obsidian/SecondBrain/`)

# Globale Regeln

## Sprache

Alle Kommunikation und Dokumentation auf Deutsch.

<!-- TODO Leser: An deine Arbeitssprache anpassen. -->

## Zweites Gehirn (SecondBrain)

Projektuebergreifendes Wissenssystem unter `~/Obsidian/SecondBrain/`.

Die massgeblichen Regeln, Routinen und Pfade fuer das SecondBrain stehen in der
Vault-eigenen Regel-Datei und werden hier direkt eingebunden — diese Datei ist die
Single Source of Truth fuer alle KIs (Claude, Gemini, Codex, ...):

@~/Obsidian/SecondBrain/CLAUDE.md

Hinweis: Der Dateiname `CLAUDE.md` ist historisch — der Inhalt ist KI-agnostisch und
gilt ebenso fuer Gemini.

## Chat-Archivierung (Gemini-spezifisch)

Zusaetzlich zur Daily Note werden substantielle Gemini-Chat-Verlaeufe standardmaessig
im Vault archiviert.

**Default-Speicherort:** `~/Obsidian/SecondBrain/04 Ressourcen/Gemini/`

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
tags: [gemini-chat]
datum: YYYY-MM-DD
thema: kurzbeschreibung
source: gemini
chat_url: unbekannt
---
```

**Aufbau:**
1. Zusammenfassung (2-3 Saetze)
2. Kompletter Verlauf (Nutzer + Gemini, chronologisch)

**Wann NICHT in dieses Verzeichnis:**
- Wenn Nutzer expliziten anderen Speicherort nennt
- Bei Projekt-Zugehoerigkeit → `02 Projekte/<projekt>/`
- Bei Deep Research → `04 Ressourcen/Research/`

## Secrets-Policy

- NIEMALS API-Keys, Tokens, Passwoerter oder Credentials in Dateien schreiben
- NIEMALS Secrets in Git committen
- Secrets gehoeren in Umgebungsvariablen oder einen Secret Manager
- `.env`-Dateien IMMER in `.gitignore` eintragen

## Arbeitsregeln

- Datei erst lesen, dann aendern
- Bestehende Dateien editieren statt neue zu erstellen
