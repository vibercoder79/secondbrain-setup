# Verifikations-Checks (Phase 6)

Nach dem Anlegen pruefen ob das Projekt der Governance entspricht.

## Check 1: Whitelist Projektwurzel

Erlaubte Files im Projekt-Wurzel:
- `<Projektname> - PMO HUB.md` (Pflicht)
- `Projekt-Governance.md` (Pflicht)
- `Financials.md` (opt-in, nur wenn `financials_tool != none`)

Nicht erlaubt:
- `README.md` (PMO HUB ist die Landing Page)
- Andere Markdown-Files (gehoeren in Subordner)

```bash
PROJ="$HOME/Obsidian/SecondBrain/02 Projekte/<Projektname>"
ls "$PROJ" | grep -v -E "^(<Projektname> - PMO HUB\.md|Projekt-Governance\.md|Financials\.md|Meetings|Decisions|Risks|Research|assets)$"
```

Wenn die Liste nicht leer ist → Hinweis ausgeben: "Diese Files passen nicht in den Projektwurzel".

## Check 2: Pflicht-Subordner existieren

```bash
PROJ="$HOME/Obsidian/SecondBrain/02 Projekte/<Projektname>"
for d in Meetings Decisions Research assets; do
  test -d "$PROJ/$d" || echo "FEHLT: $d"
done
```

Wenn `risk_register: enabled` → zusaetzlich `Risks/` pruefen.

## Check 3: Pflicht-Dateien existieren und nicht leer

```bash
test -s "$PROJ/<Projektname> - PMO HUB.md" || echo "FEHLT oder LEER: PMO HUB"
test -s "$PROJ/Projekt-Governance.md" || echo "FEHLT oder LEER: Governance"
```

Wenn `financials_tool != none`:
```bash
test -s "$PROJ/Financials.md" || echo "FEHLT oder LEER: Financials"
```

## Check 4: Wikilinks im Hub valide

Aus dem Hub alle `[[...]]` extrahieren und pruefen ob sie auf existierende Dateien zeigen.

```bash
grep -oE '\[\[[^]|]+(\|[^]]+)?\]\]' "$PROJ/<Projektname> - PMO HUB.md" | sed 's/\[\[//;s/\]\]//;s/|.*//'
```

Fuer jeden Treffer:
- Pruefen ob die Datei im Vault existiert (Glob `**/<Treffer>.md`)
- Wenn nein → "Wikilink ins Leere: [[<Treffer>]] in PMO HUB"

**Spezialfall:** `[[Projekt-Governance]]` — relativer Link, sollte als
`./Projekt-Governance.md` aufgeloest werden.

## Check 5: Dataview-Bloecke korrekt

Der Hub enthaelt 3-4 Dataview-Bloecke. Pruefen:
- Jeder Block hat `\`\`\`dataview` oeffnend und `\`\`\`` schliessend
- Keine offenen Code-Bloecke
- Pfad in `FROM "..."` zeigt auf existierenden Ordner

```bash
# Pruefe dass dataview-Bloecke geschlossen sind
grep -c '^```dataview' "$PROJ/<Projektname> - PMO HUB.md"
grep -c '^```$' "$PROJ/<Projektname> - PMO HUB.md"
# Beide Werte sollten zueinander passen (closing kann groesser sein wenn andere code-blocks)
```

## Check 6: Frontmatter valide

PMO HUB Frontmatter muss enthalten:
- `tags: [projekt]`
- `status`, `phase`, `erstellt`, `aktualisiert`
- `governance: "[[Projekt-Governance]]"`

Governance Frontmatter muss enthalten:
- `type: governance`
- `project: "[[<Projektname>]]"`
- `backlog_tool` mit gueltigem Wert
- `risk_register`, `financials_tool`

## Output-Format Verifikation

```
Verifikation:
  [PMO HUB] OK
  [Governance] OK
  [Whitelist] OK (3 Files im Wurzel)
  [Subordner] Meetings, Decisions, Research, assets vorhanden
  [Wikilinks] 2 von 2 valide
  [Dataview] 3 Bloecke ok
  [Frontmatter] PMO HUB + Governance valide
  
  ✓ Projekt entspricht der Governance
```

Bei Fehlern:
```
Verifikation: 1 Problem gefunden
  ✗ [Wikilinks] [[Beispiel-Container]] zeigt ins Leere — soll ich die Notiz anlegen oder den Link entfernen?
```

→ Direkt anbieten zu fixen (mit `AskUserQuestion`).
