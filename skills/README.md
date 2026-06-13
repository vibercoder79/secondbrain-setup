# SecondBrain Skills

Sechs Claude-Code-Skills, organisiert in drei Disziplin-Gruppen, die das **SecondBrain Obsidian Vault** zu einem lebenden, vernetzten und aktiv kuratierten Wissenssystem machen.

| Gruppe | Skills | Aufgabe |
| ------ | ------ | ------- |
| Strukturieren | `projekt-init` | Neue Projekte sauber anlegen |
| Vernetzen und pflegen | `ingest`, `lint` | Wissen verbinden, Hygiene halten |
| Kuratieren | `synthesize`, `decay`, `prune` | Verdichten, altern lassen, aussortieren |

Alle Skills basieren auf einer PARA-Vault-Struktur (`00 Kontext`, `01 Inbox`, `02 Projekte`, `03 Bereiche`, `04 Ressourcen`, `05 Daily Notes`, `06 Archiv`, `07 Anhaenge`). Die ersten drei Skills setzen Karpathys **LLM-Wiki-Pattern** um (Ingest, Query, Lint). Die drei Kuratierungs-Skills schliessen die drei fehlenden Operationen: Verdichten, Altern, Aussortieren. Hintergrund dazu in [`handbuch/09-kuratierung.md`](../handbuch/09-kuratierung.md).

## Installation aller sechs Skills

```bash
cp -r ~/Documents/GitHub/secondbrain-setup/skills/projekt-init ~/.claude/skills/projekt-init
cp -r ~/Documents/GitHub/secondbrain-setup/skills/ingest      ~/.claude/skills/ingest
cp -r ~/Documents/GitHub/secondbrain-setup/skills/lint        ~/.claude/skills/lint
cp -r ~/Documents/GitHub/secondbrain-setup/skills/synthesize  ~/.claude/skills/synthesize
cp -r ~/Documents/GitHub/secondbrain-setup/skills/decay       ~/.claude/skills/decay
cp -r ~/Documents/GitHub/secondbrain-setup/skills/prune       ~/.claude/skills/prune
```

Claude Code laedt Skills automatisch aus `~/.claude/skills/`. Kein Restart noetig.

---

## Gruppe 1: Strukturieren

### `projekt-init` — Projekte anlegen

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

## Gruppe 2: Vernetzen und pflegen

### `ingest` — Notizen vernetzen

> [Skill-README](ingest/README.md) · [SKILL.md](ingest/SKILL.md)

Verarbeitet eine einzelne Notiz und vernetzt sie mit dem restlichen Vault: bidirektionale Wikilinks, Aktualisierung passender Synthese-Seiten in `04 Ressourcen/` (destillierte Erkenntnis, kein Copy-Paste), Eintrag in `log.md`. Der Compound-Effekt: jede neue Quelle macht das Vault reicher.

**Trigger:**
- `/ingest <Notizname>` oder `/ingest <Pfad>`
- "verarbeite diese Notiz", "vernetze das", "link diese Notiz", "integriere das ins Vault"

**Voraussetzungen:**
- Vault unter `~/Obsidian/SecondBrain/`
- Optionale Synthese-Seiten-Konvention: Ordner in `04 Ressourcen/<Thema>/` mit gleichnamiger Start-Datei

### `lint` — Vault-Gesundheits-Check

> [Skill-README](lint/README.md) · [SKILL.md](lint/SKILL.md) · [EN](lint/SKILL.en.md)

Woechentlicher 6-Phasen-Check des gesamten Vaults: verwaiste Notizen, fehlende Verknuepfungen, Vault-Hygiene (Inbox, Frontmatter, Synthese-Seiten), Projekt-Compliance gegen die Whitelist aus `Projekt-Struktur.md`, Markdown-Report in `01 Inbox/`, Log-Eintrag, und Regenerierung der `Index.md` im Vault-Root als **Wiki-Cover** fuer Claude (statt das ganze Vault zu durchsuchen).

**Trigger:**
- `/lint` (Voll-Check) oder `/lint orphans`, `/lint inbox`, `/lint projekte`, `/lint index` (Teil-Checks)
- "lint", "vault check", "pruefe das vault", "gesundheitscheck", "verwaiste notizen", "orphans", "projekt-compliance"

**Voraussetzungen:**
- Vault unter `~/Obsidian/SecondBrain/`
- Funktioniert auch ohne `projekt-init`, aber der Projekt-Compliance-Teil setzt die `projekt-init`-Konvention voraus

---

## Gruppe 3: Kuratieren (neu)

Diese drei Skills schliessen die Luecke zwischen einem **strukturierten Notizsystem** und einem **kuratierten Wissensspeicher**. Sie haengen alle drei am gleichen Sicherheitsmodell: kein Auto-Write, kein Auto-Delete, jede Aenderung einzeln bestaetigt.

Konzeptioneller Hintergrund: [`handbuch/09-kuratierung.md`](../handbuch/09-kuratierung.md).

### `synthesize` — Roh-Material verdichten

> [Skill-README](synthesize/README.md) · [SKILL.md](synthesize/SKILL.md) · [EN](synthesize/README.en.md)

Verdichtet Notizen eines Themen-Clusters (Ordner, Tag oder bestehender MOC) zu einer Synthese-Seite oder Map of Content. Liest alle Notizen vollstaendig, gruppiert nach Sub-Themen, markiert Widersprueche und Luecken, prueft Beleg-Dichte. Hebt damit Roh-Material aus der Roh-Schicht (Inbox, Daily Notes, KI-Outputs) in die kuratierte Schicht (MOCs, Synthesen, ADRs).

**Trigger:**
- `/synthesize cluster:"<Ordner>"` oder `/synthesize tag:#<tag>` oder `/synthesize "<Pfad>"`
- "synthesize", "verdichte das wissen", "MOC fuer", "map of content fuer", "fasse das cluster zusammen"

**Beispiel-Befehl:**

```
/synthesize cluster:"04 Ressourcen/KI"
```

Liest alle KI-Notizen, gruppiert nach Sub-Themen, schlaegt Synthese-Notiz oder MOC mit Beleg-Liste, Widerspruechen und Luecken vor. Eigner entscheidet ob uebernommen wird.

### `decay` — Notizen auf Veraltung pruefen

> [Skill-README](decay/README.md) · [SKILL.md](decay/SKILL.md) · [EN](decay/README.en.md)

Findet Notizen aelter als eine Schwelle, extrahiert pruefbare Aussagen (Versionen, Tool-Namen, Standards, URLs), validiert gegen das Web (WebSearch, sparsam WebFetch), markiert `freshness: gueltig | ueberpruefen | veraltet` in der Frontmatter. Schreibt einen Decay-Report ins Vault-Gesundheit-Verzeichnis. Inhalt der Notiz wird nie veraendert.

**Trigger:**
- `/decay` (Defaults: older-than:6m, folder:"04 Ressourcen")
- `/decay older-than:12m folder:"03 Bereiche"`
- "decay", "decay check", "ist das noch aktuell", "pruefe alte notizen", "freshness check"

**Beispiel-Befehl:**

```
/decay older-than:6m folder:"04 Ressourcen"
```

Findet alle Ressourcen-Notizen aelter als sechs Monate, prueft Aussagen gegen aktuelle Quellen, setzt Frontmatter-Felder `freshness` und `decay_checked_at`, legt Report in `03 Bereiche/Vault-Gesundheit/YYYY-MM-DD Decay Report.md` ab.

### `prune` — Loesch-Kandidaten vorschlagen

> [Skill-README](prune/README.md) · [SKILL.md](prune/SKILL.md) · [EN](prune/README.en.md)

Sucht Loesch-Kandidaten in vier Kategorien: Duplikate (Title-Match plus Inhalts-Aehnlichkeit), alte Orphans (in drei aufeinanderfolgenden Lint-Reports persistent), alte Brain Dumps in `01 Inbox/` (ueber 12 Monate, ohne Backlinks), Notizen mit `freshness: veraltet`. Pro Kandidat eine eigene Confirmation, Optionen sind loeschen, archivieren, behalten, ueberspringen. Schutzzonen (00 Kontext, CLAUDE.md, log.md, Index.md, Skills-Doku, Daily Notes, Anhaenge) werden nie angetastet. Backup wird vor dem ersten Lauf empfohlen.

**Trigger:**
- `/prune` (alle vier Kategorien) oder `/prune duplikate`, `/prune orphans`, `/prune inbox`, `/prune veraltet`
- "prune", "loesch-vorschlaege", "vault entruempeln", "aussortieren", "duplikate finden", "alte orphans aufraeumen"

**Beispiel-Befehl:**

```
/prune orphans
```

Liest die letzten drei Lint-Reports, bildet die Schnittmenge persistenter Orphans, zeigt pro Kandidat Begruendung und Empfehlung, fragt einzeln nach Loeschung, Archivierung, Behalten oder Ueberspringen.

---

## Wie die sechs zusammenspielen

```
Strukturieren        Vernetzen / pflegen        Kuratieren
─────────────        ───────────────────        ──────────

projekt-init  ──►  ingest        ──►   synthesize  (verdichtet Roh-Material)
                    lint                decay       (markiert Veraltung)
                                        prune       (entfernt Ballast)
```

Der gemeinsame Nenner der ersten drei: **Vorverarbeitung statt Echtzeit-Suche**. Statt dass Claude bei jeder Frage das ganze Vault scannt, wird beim Ablegen einmal investiert. `Index.md` aus `lint` ist die Eintrittskarte fuer jede Session.

Der gemeinsame Nenner der drei neuen: **Vorschlagen statt veraendern**. Die Kuratierungs-Skills schreiben nie ohne Bestaetigung und loeschen nie ohne Einzel-Confirmation. Sie machen sichtbar, was im Vault verdichtet, veraltet oder ueberfluessig ist. Die Entscheidung bleibt beim Eigner.

## Quellen

- [Karpathy LLM Wiki Gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — Pattern hinter den ersten drei Skills
- [PARA Method](https://fortelabs.com/blog/para/) — Tiago Forte, Building a Second Brain
- Michael Nygard, "Documenting Architecture Decisions" (2011) — ADR-Pattern fuer `Decisions/`
- [Standortbestimmung Kuratierung im KI-Zeitalter](../handbuch/09-kuratierung.md) — Grundlage fuer `synthesize`, `decay`, `prune`

## Sprache

Skills und Dokumentation sind ueberwiegend auf Deutsch — die Original-Arbeitssprache. EN-Varianten der README sind bei den meisten Skills vorhanden (`README.en.md`).
