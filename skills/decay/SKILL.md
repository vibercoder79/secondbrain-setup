---
name: decay
description: >
  Prueft Notizen im SecondBrain Obsidian Vault auf Veraltung. Findet alte Notizen,
  validiert pruefbare Aussagen gegen aktuelle Realitaet (Web-Suche), markiert
  freshness-Status in Frontmatter. Schreibt Decay-Report ins Vault-Gesundheit-Verzeichnis.
  Verwenden wenn der Nutzer "decay", "decay check", "ist das noch aktuell",
  "pruefe alte notizen", "freshness check" sagt.
version: 1.0.0
user-invocable: true
allowed-tools:
  - Read
  - Edit
  - Write
  - Bash
  - Glob
  - Grep
  - WebSearch
  - WebFetch
  - AskUserQuestion
runtime: claude-local
layer-target: both
---

# Decay Skill — SecondBrain Freshness-Check

Du pruefst Notizen im SecondBrain auf Veraltung. Notizen aelter als eine Schwelle
werden auf pruefbare Aussagen (Versionen, Datumsangaben, Tool-Namen, Standards, URLs)
geprueft und in der Frontmatter mit einem `freshness`-Status markiert.

Komplementaer zu `/lint` (Strukturpruefung des Vaults) und `/ingest` (Vernetzung
einzelner Notizen): Decay pruefte den Wahrheitsgehalt ueber Zeit.

## Vault

- **Pfad:** `/Users/tobiasschmidt/Obsidian/SecondBrain/`
- **Struktur:** PARA (00 Kontext, 01 Inbox, 02 Projekte, 03 Bereiche, 04 Ressourcen, 05 Daily Notes, 06 Archiv, 07 Anhaenge)
- **Log:** `/Users/tobiasschmidt/Obsidian/SecondBrain/log.md`
- **Report-Ablage:** `/Users/tobiasschmidt/Obsidian/SecondBrain/03 Bereiche/Vault-Gesundheit/`

## Aufruf

| Input | Verhalten |
|-------|-----------|
| `/decay` | Vollstaendiger Check mit Defaults (older-than:6m, folder:"04 Ressourcen") |
| `/decay older-than:12m` | Schwelle anpassen (m=Monate, y=Jahre) |
| `/decay folder:"03 Bereiche"` | Anderen Scope-Ordner waehlen |
| `/decay older-than:3m folder:"02 Projekte"` | Kombinierbare Argumente |
| `/decay note:"<Notiz>"` | Eine einzelne Notiz pruefen, unabhaengig vom Alter |

Wenn Argumente unklar oder widerspruechlich sind: AskUserQuestion stellen, nicht raten.

## Workflow

Fuehre diese 6 Schritte der Reihe nach aus.

### Schritt 1: Scope waehlen

1. **Argumente parsen** — `older-than:<n>m|y` und `folder:"..."` aus der User-Eingabe lesen.
2. **Defaults setzen** wenn nicht angegeben:
   - `older-than: 6m`
   - `folder: 04 Ressourcen`
3. **Bei Unklarheit** AskUserQuestion mit konkreten Optionen:
   - Schwelle (3m, 6m, 12m)
   - Scope (`04 Ressourcen`, `03 Bereiche`, `02 Projekte`, gesamtes Vault)
4. **Hard-Excludes** (nie pruefen):
   - `05 Daily Notes/` — Tageslogs sind per Definition Zeitstempel, keine Wahrheits-Aussagen
   - `06 Archiv/` — bewusst eingefroren
   - `07 Anhaenge/` — keine Markdown-Inhalte
   - `01 Inbox/` — zu jung fuer Decay
   - `00 Kontext/` — Identitaets- und Schreibstil-Dateien, werden nicht durch Decay markiert

### Schritt 2: Kandidaten finden

1. **Glob** `<folder>/**/*.md` im gewaehlten Scope.
2. **Alter pro Datei bestimmen** in dieser Reihenfolge:
   - `aktualisiert:` aus YAML-Frontmatter
   - Falls leer: `date:` aus YAML-Frontmatter
   - Falls beide leer: Bash `stat -f %Sm -t "%Y-%m-%d" <file>` (mtime) als Fallback
3. **Filtern** auf Dateien aelter als die Schwelle.
4. **Bereits geprueft** ausschliessen wenn `decay_checked_at` juenger als 30 Tage ist —
   ausser User hat `note:"..."` explizit gesetzt.
5. **Liste anzeigen** mit Pfad, Alter, letzter Pruefung:
   ```
   12 Kandidaten gefunden (Scope: 04 Ressourcen, Schwelle: 6 Monate)
   1. KI-Agent-Frameworks.md — 9 Monate alt, nie geprueft
   2. M365 Integration.md — 7 Monate alt, letzte Pruefung 2026-01-12
   ...
   ```

### Schritt 3: Pro Kandidat pruefbare Aussagen extrahieren

Pro Notiz:

1. **Notiz vollstaendig lesen.**
2. **Pruefbare Aussagen identifizieren:**
   - Versionsnummern (z.B. "Claude Sonnet 4.5", "Node 20", "Python 3.12")
   - Tool- und Produkt-Namen (z.B. "Cursor", "Linear MCP Server", "Webflow")
   - Standards und Spezifikationen (z.B. "OWASP Top 10:2025", "ASVS 5.0")
   - Konkrete URLs zu Doku-Seiten (z.B. `https://docs.anthropic.com/...`)
   - Behauptungen ueber Verfuegbarkeit (z.B. "noch nicht GA", "Preview seit ...")
   - Konkrete Zahlenangaben mit Quelle (Preise, Limits, Kontextfenster)
3. **Nicht pruefen:**
   - Persoenliche Erkenntnisse, Reflexionen, Daily-Note-Eintraege
   - Konzeptuelle Argumente ohne Zeitbezug
   - Eigene Schreibstil- und Branding-Regeln
4. **Wenn keine pruefbaren Aussagen vorhanden:** Notiz als `gueltig` markieren mit
   `decay_notes: keine pruefbaren Aussagen — Inhalt konzeptionell`. Kein Web-Call noetig.

### Schritt 4: Web-Validierung (sparsam, gebuendelt)

Fuer Notizen mit pruefbaren Aussagen:

1. **Pro Notiz hoechstens 3 Web-Calls** — die wichtigsten Aussagen bundeln.
2. **Reihenfolge:**
   - **WebSearch zuerst** fuer Kurz-Pruefungen ("ist Tool X noch aktuell", "was ist die
     aktuelle Version von Y", "gibt es Standard Z noch")
   - **WebFetch nur** wenn die Notiz eine konkrete Doku-URL referenziert, die direkt
     geprueft werden muss
3. **Bundeln ueber Notizen hinweg** wo moeglich: Wenn fuenf Notizen alle "Claude Sonnet 4.5"
   referenzieren, einmal WebSearch dafuer, Ergebnis fuer alle nutzen.
4. **Klassifikation** pro Notiz:
   - `gueltig` — Aussagen stimmen mit aktueller Realitaet ueberein
   - `ueberpruefen` — Indizien fuer Veraltung (Tool umbenannt, Version sehr weit zurueck,
     URL antwortet nicht mehr), aber kein klarer Beweis
   - `veraltet` — klare Belege (Tool eingestellt, Standard ersetzt, Doku-URL 404 oder
     verweist auf Nachfolger)
5. **Begruendung pro Notiz** notieren — wird in `decay_notes` geschrieben.

**Kein Inhalt der Notiz wird veraendert.** Nur Frontmatter.

### Schritt 5: Preview und Bestaetigung

1. **Preview-Tabelle** zeigen, gruppiert nach Klassifikation:
   ```
   Decay-Preview (Scope: 04 Ressourcen, geprueft am 2026-06-13)

   GUELTIG (8):
   - KI-Agent-Frameworks.md
   - ...

   UEBERPRUEFEN (3):
   - M365 Integration.md — Tool-Name "Microsoft Graph SDK v1" — neue Major-Version v2 seit Februar
   - ...

   VERALTET (1):
   - Cursor-Setup.md — verlinkt cursor.so/docs/v0.4, Doku ist auf v1.2 und Pfad existiert nicht mehr
   ```
2. **AskUserQuestion** "Frontmatter fuer alle Kandidaten so setzen, einzeln durchgehen,
   oder abbrechen?"
3. **Bei Bestaetigung** weiter zu Schritt 6. Bei "einzeln" pro Datei nachfragen.

### Schritt 6: Frontmatter schreiben

Pro Notiz die YAML-Frontmatter erweitern (nicht ersetzen). Wenn keine Frontmatter
existiert, eine minimale anlegen.

Felder:

```yaml
freshness: gueltig | ueberpruefen | veraltet
decay_checked_at: 2026-06-13
decay_notes: kurze Begruendung wenn ueberpruefen oder veraltet, sonst leer
```

Regeln:

1. **Edit, nicht Write** — bestehende Frontmatter erweitern.
2. **Bestehende Felder erhalten** (tags, source, chat_url, status, ...).
3. **`decay_notes` nur fuer `ueberpruefen` oder `veraltet`** — bei `gueltig` weglassen
   oder leer setzen.
4. **Nie den Notiz-Body anfassen.**

### Schritt 7: Decay-Report schreiben

Bericht ablegen in `03 Bereiche/Vault-Gesundheit/YYYY-MM-DD Decay Report.md`:

```markdown
---
tags: [system, decay-report]
date: 2026-06-13
source: claude
chat_url: unbekannt
---

# Vault Decay Report — 2026-06-13

## Zusammenfassung

- **Scope:** 04 Ressourcen, Schwelle 6 Monate
- **Geprueft:** 12 Notizen
- **Gueltig:** 8 | **Ueberpruefen:** 3 | **Veraltet:** 1
- **Web-Calls:** 7 WebSearch, 2 WebFetch

## Gueltig

- [[Notizname]] — keine pruefbaren Aussagen / Versionsnummern aktuell

## Ueberpruefen

- [[M365 Integration]] — "Microsoft Graph SDK v1" erwaehnt, v2 seit Februar verfuegbar
  - Mitigation: Versionsangabe aktualisieren, Migration-Hinweis ergaenzen
- ...

## Veraltet

- [[Cursor-Setup]] — Doku-URL `cursor.so/docs/v0.4` ergibt 404, aktuelle Pfad-Struktur ist `cursor.com/docs/`
  - Mitigation: URLs ersetzen, Screenshots erneuern, oder ins Archiv verschieben

## Empfohlene Aktionen

1. Drei Notizen unter "Ueberpruefen" durchgehen und mit aktuellen Quellen nachschaerfen
2. Eine veraltete Notiz entweder aktualisieren oder bewusst archivieren
```

### Schritt 8: Log-Eintrag

Append-only in `log.md`:

```markdown
## [2026-06-13] decay | Freshness-Check 04 Ressourcen

- **Scope:** 04 Ressourcen, Schwelle 6 Monate
- **Geprueft:** 12 Notizen
- **Klassifikation:** 8 gueltig, 3 ueberpruefen, 1 veraltet
- **Web-Calls:** 7 WebSearch, 2 WebFetch
- **Report:** [[2026-06-13 Decay Report]]
```

## Regeln

1. **IMMER Preview vor Schreiben** — Frontmatter wird nie ohne Bestaetigung gesetzt
2. **NIE Inhalt aendern** — Decay markiert nur, korrigiert nicht
3. **NIE loeschen oder archivieren** — Mitigation ist Vorschlag, nie Aktion
4. **Web-Calls sparsam** — pro Notiz hoechstens 3, ueber Notizen hinweg bundeln
5. **Daily Notes, Archiv, Inbox, Kontext, Anhaenge ausnehmen** (Hard-Excludes Schritt 1)
6. **Begruendung in `decay_notes`** ist Pflicht bei `ueberpruefen` und `veraltet`
7. **Log ist append-only** — nie bestehende Eintraege aendern
8. **Sprache: Deutsch** — alle Ausgaben und Report-Texte auf Deutsch
