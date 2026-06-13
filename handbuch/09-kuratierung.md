# 09 — Kuratierung: synthesize, decay, prune

> Kurzfassung: Sammeln ist nicht Wissen. Kuratierung ist die Disziplin, die aus
> einem vollen Vault einen brauchbaren Wissensspeicher macht. KI verschaerft das
> Problem, statt es zu loesen. Drei neue Skills schliessen die Luecke:
> `synthesize` verdichtet, `decay` markiert Veraltung, `prune` entfernt Ballast.

## Worum es geht

Die ersten sechs Kapitel haben die Struktur, die Architektur und die drei
Skills `projekt-init`, `ingest` und `lint` beschrieben. Das deckt das Anlegen,
das Vernetzen und die Hygiene-Pruefung ab. Was bisher fehlt, ist die Disziplin
dahinter: was bleibt im Vault, in welcher Form, wie lange?

Genau das ist Kuratierung. Sie wird mit jeder neuen KI-Session wichtiger, weil
KI mehr produziert als ein Mensch in vernuenftiger Zeit sortieren kann. Dieses
Kapitel beschreibt die Standortbestimmung dazu, das Modell der zwei Schichten
und die drei neuen Skills, die `synthesize`, `decay` und `prune` heissen.

## Was heisst Kuratierung?

Der Begriff stammt aus dem Museums- und Archivkontext. Lateinisch *curare*
heisst sich kuemmern. Kuratierung ist nicht Sammeln. Sie ist die bewusste
Entscheidung, was bleibt, in welcher Form und in welchem Kontext. Im PKM-Kontext
laesst sich Kuratierung in sieben Disziplinen aufschluesseln:

| Nr. | Disziplin | Frage | In diesem Setup abgedeckt |
| --- | --------- | ----- | ------------------------- |
| 1 | Selektion | Was kommt ueberhaupt rein? | Teilweise (Inbox-Trigger) |
| 2 | Klassifikation | Wo gehoert es hin? | Ja (`/ingest`, PARA) |
| 3 | Annotation | Was bedeutet es fuer mich? | Manuell, kein Skill |
| 4 | Verknuepfung | Wie haengt es mit anderem zusammen? | Ja (`/ingest`, Wikilinks) |
| 5 | Verdichtung | Wie wird aus N Notizen eine Erkenntnis? | Ja (`/synthesize`, neu) |
| 6 | Decay-Check | Stimmt das heute noch? | Ja (`/decay`, neu) |
| 7 | Pruning | Was muss weg? | Ja (`/prune`, neu) |

Bevor die drei neuen Skills dazukamen, deckte `lint` Hygiene ab und `ingest`
Verknuepfung. Verdichtung, Decay-Check und Pruning waren die Luecke. Genau
dort hat KI das Problem verschaerft, nicht geloest.

## Warum KI das Problem verschaerft

Sechs Gruende, sortiert nach Wucht. Sie sind die Begruendung, warum die drei
neuen Skills ueberhaupt existieren.

### 1. Volumen-Asymmetrie

KI produziert in fuenf Minuten fuenfzig Seiten Output. Die Kuratierungskapazitaet
(Aufmerksamkeit, Energie) bleibt konstant. Das Verhaeltnis Reinkommen zu
Verarbeiten kippt von frueher etwa 1:1 auf 50:1. Ohne Gegenmassnahme wird das
Vault zur durchsuchbaren Muellhalde.

### 2. Garbage-in zu Garbage-out im Quadrat

Sobald das Vault als Kontext fuer KI dient (RAG, MCP, Agent-Memory,
Auto-Memory), wird jede unkuratierte Notiz Teil der Antwortgrundlage. Schlechte
Kuratierung verschlechtert KI-Antworten aktiv und reproduziert Fehler ueber
mehrere Sessions hinweg. Klassisches PKM kannte das Problem nicht in dieser
Schaerfe: dort erschwerte eine schlechte Notiz nur das Wiederfinden, sie
verschob nicht die Wahrheit.

### 3. Kontext-Erosion

KI-Outputs sind glatt, generisch, kontextlos. Sie wirken wertvoll, sind aber
nicht die eigene Erkenntnis. Ein Second Brain ohne eigenes Denken wird zum
lokal gemounteten KI-Cache.

### 4. Decay

Wissen altert schneller als frueher. Was 2024 ueber LLMs galt, ist 2026 falsch.
Frameworks aendern sich, Modelle werden abgeloest. Ein Vault ohne
Decay-Mechanismus ist ein Archiv veralteter Wahrheiten mit Suchfunktion.

### 5. Synthese ist nicht delegierbar

KI kann zusammenfassen. KI kann nicht die eigene Synthese aus zwoelf Quellen
bilden, gewichtet mit der eigenen Erfahrung. Diese Schicht ist der eigentliche
Wert eines Second Brains. Sie wird bei KI-getriebener Produktion systematisch
uebersprungen.

### 6. Identitaets-Drift

Ein Second Brain spiegelt im Idealfall den Eigner. KI spiegelt den
Trainings-Durchschnitt. Wenn 80 Prozent des Vaults KI-Output ist, ist es kein
Second Brain mehr.

## Zwei-Schichten-Architektur

Aus den sechs Gruenden folgt eine bewusste Trennung im Vault. Die Roh-Schicht
ist gross und volume-tolerant, die kuratierte Schicht ist klein und
qualitaets-kontrolliert. Die kuratierte Schicht ist die primaere Kontextquelle
fuer KI.

| Schicht | Inhalt | Qualitaetsanspruch | Volumen |
| ------- | ------ | ------------------ | ------- |
| Roh-Schicht | Inbox, Daily Notes, Brain Dumps, KI-Roh-Outputs, Meeting-Notes | volume-tolerant, durchsuchbar | unbegrenzt |
| Kuratierte Schicht | MOCs, Synthesen, ADRs, `00 Kontext`, eigenes Schreiben, Frameworks | hoch, qualitaets-kontrolliert | bewusst klein |

Praktische Konsequenz: KI-Kontextquellen wie RAG oder Filesystem-MCP fuettern
primaer aus der kuratierten Schicht. Die Roh-Schicht bleibt Quelle, nicht
Wahrheit. Ohne diese Trennung ist es der KI egal, ob sie aus einem Brain Dump
oder einem ADR zitiert.

Sketch:

```
┌─────────────────────────────────────────────┐
│  KURATIERTE SCHICHT (klein, qualitaets-     │
│  kontrolliert, ist KI-Kontextquelle)        │
│  MOCs, Synthesen, ADRs, 00 Kontext,         │
│  eigenes Schreiben, Frameworks              │
└────────────▲────────────────────────────────┘
             │
        synthesize  (hebt)
        decay       (prueft)
        prune       (entfernt)
             │
┌────────────▼────────────────────────────────┐
│  ROH-SCHICHT (gross, volume-tolerant)       │
│  Inbox, Brain Dumps, KI-Roh-Outputs,        │
│  Daily Notes, Meeting-Notes                 │
└─────────────────────────────────────────────┘
```

Visualisierung als Diagramm: [`../diagramme/09-zwei-schichten-de.png`](../diagramme/09-zwei-schichten-de.png).

Die drei Pfeile sind die drei neuen Skills. Synthese hebt Roh-Material in die
kuratierte Schicht. Decay prueft, ob die kuratierte Schicht noch stimmt. Prune
reduziert die Roh-Schicht.

## Drei neue Skills im Ueberblick

Alle drei folgen den gleichen Sicherheits-Defaults: kein Auto-Write, kein
Auto-Delete, jede Aenderung einzeln bestaetigt. Sie schlagen vor, der Eigner
entscheidet. Genau das ist Kuratierung.

### `synthesize` — Verdichten

**Trigger:** `/synthesize cluster:"<Ordner>"`, `/synthesize tag:#<tag>`,
`/synthesize "<Pfad>"`, oder Saetze wie "synthesize", "verdichte das wissen",
"MOC fuer", "fasse das cluster zusammen".

**Was er tut**

1. Cluster waehlen (Ordner, Tag oder bestehender MOC). Bei mehr als 30
   Notizen erst Hinweis, dass der Cluster ggf. zu gross ist.
2. Alle Notizen im Cluster vollstaendig lesen.
3. Analyse: Sub-Themen bilden, Widersprueche markieren, Luecken benennen,
   schwach belegte Aussagen kennzeichnen.
4. Vorschlag in zwei Varianten: **Synthese-Notiz** wenn der Cluster fokussiert
   ist, **MOC** wenn er breit ist (Default-Empfehlung ab vier Sub-Themen).
5. Preview im Chat plus Ziel-Pfad. Erst nach Bestaetigung wird geschrieben.
6. Schreiben, Rueckverlinkungen in den Quell-Notizen setzen, Log-Eintrag in
   `log.md`.

Empfohlener Rhythmus: einmal pro Quartal pro aktivem Themen-Cluster. Trigger
sind in der Regel volle Inbox oder ein Block von Daily-Note-Eintraegen im
gleichen Tag-Bereich.

**Einsatz-Beispiel**

```
> /synthesize cluster:"04 Ressourcen/KI"

Liest alle Notizen im KI-Ordner, gruppiert nach Topic-Tag, zeigt:
- Aktuelle Erkenntnisse pro Topic
- Widersprueche zwischen Notizen
- Luecken (Topics ohne Belege)
Schlaegt eine MOC oder Synthese-Notiz vor.
Eigner entscheidet, ob uebernommen wird.
```

Skill-Quelle: [`../skills/synthesize/`](../skills/synthesize/).

### `decay` — Veraltung markieren

**Trigger:** `/decay`, `/decay older-than:12m folder:"03 Bereiche"`,
`/decay note:"<Notiz>"`, oder Saetze wie "decay check", "ist das noch aktuell",
"pruefe alte notizen", "freshness check".

**Was er tut**

1. Scope waehlen (Defaults: older-than 6 Monate, folder `04 Ressourcen`).
   Hard-Excludes sind Daily Notes, Archiv, Inbox, `00 Kontext`, Anhaenge.
2. Kandidaten finden ueber `aktualisiert`, `date` oder mtime. Bereits
   gepruefte Notizen mit `decay_checked_at` juenger als 30 Tage ueberspringen.
3. Pro Kandidat pruefbare Aussagen extrahieren: Versionsnummern, Tool- und
   Produktnamen, Standards, Doku-URLs, konkrete Zahlen mit Quelle. Wenn
   nichts pruefbar ist, gilt `gueltig` ohne Web-Call.
4. Web-Validierung sparsam, hoechstens drei Calls pro Notiz, Bundeln ueber
   Notizen hinweg, wo moeglich.
5. Klassifikation `gueltig` / `ueberpruefen` / `veraltet` mit Begruendung
   in `decay_notes`. Inhalt der Notiz wird **nie** veraendert, nur
   Frontmatter.
6. Preview, dann Schreiben. Decay-Report nach
   `03 Bereiche/Vault-Gesundheit/YYYY-MM-DD Decay Report.md`, Log-Eintrag in
   `log.md`.

Empfohlener Rhythmus: monatlich auf `04 Ressourcen/`, quartalsweise auf
`03 Bereiche/`.

**Einsatz-Beispiel**

```
> /decay older-than:6m folder:"04 Ressourcen"

Findet Notizen aelter als sechs Monate in Ressourcen.
Prueft pruefbare Aussagen gegen Web-Suche.
Markiert in Frontmatter:
  freshness: gueltig | ueberpruefen | veraltet
  decay_checked_at: 2026-06-13
Schreibt Bericht ins Vault-Gesundheit-Verzeichnis.
```

Skill-Quelle: [`../skills/decay/`](../skills/decay/).

### `prune` — Aussortieren

**Trigger:** `/prune`, `/prune duplikate`, `/prune orphans`, `/prune inbox`,
`/prune veraltet`, oder Saetze wie "prune", "loesch-vorschlaege", "vault
entruempeln", "duplikate finden", "alte orphans aufraeumen".

**Was er tut**

1. Backup-Hinweis. Wenn das Vault unter Git steht, reicht ein Commit, sonst
   `tar`. Erst danach geht es weiter.
2. Kandidaten in vier Kategorien sammeln:
   - **Duplikate** (Title-Match plus Inhalts-Aehnlichkeit ueber 0.6 auf
     Bigramm-Jaccard)
   - **Alte Orphans** (in den letzten drei Lint-Reports persistent)
   - **Alte Brain Dumps** in `01 Inbox/` (ueber 12 Monate, ohne Backlinks)
   - **Veraltete Notizen** mit `freshness: veraltet` und letztem Update vor
     mehr als 90 Tagen
3. Vorschlagsliste mit Begruendung und Empfehlung (loeschen oder
   archivieren).
4. Pro Kandidat eigene Confirmation mit den Optionen loeschen, archivieren,
   behalten, ueberspringen. Niemals Bulk-Antworten.
5. Aktionen ausfuehren (`rm` oder `mv` nach `06 Archiv/<original-pfad>`).
6. Prune-Log nach `03 Bereiche/Vault-Gesundheit/YYYY-MM-DD Prune Log.md`,
   Log-Eintrag in `log.md`.

Schutzzonen, die nie als Kandidaten erscheinen: `00 Kontext/`, `CLAUDE.md`,
`log.md`, `Index.md`, `03 Bereiche/Skills/`, `07 Anhaenge/`, Daily Notes,
Synthese-Start-Dateien.

Empfohlener Rhythmus: quartalsweise.

**Einsatz-Beispiel**

```
> /prune

Sucht Loesch-Kandidaten:
- Duplikate (Title-Match plus Inhalts-Aehnlichkeit)
- Orphans, die nach drei Lint-Laeufen Orphan blieben
- Brain Dumps aelter als zwoelf Monate, nirgendwo verlinkt
- Notizen mit freshness: veraltet
Zeigt Vorschlagsliste mit Begruendung pro Eintrag.
Eigner bestaetigt einzeln. Kein Auto-Delete.
```

Skill-Quelle: [`../skills/prune/`](../skills/prune/).

## Kuratierungs-KPIs

Was nicht gemessen wird, wird nicht kuratiert. Im Vault-Gesundheit-Hub (in
`03 Bereiche/Vault-Gesundheit/`) gibt es deshalb einen Trend-Block mit vier
Kennzahlen, die ueber die Zeit beobachtet werden:

| KPI | Quelle | Ziel |
| --- | ------ | ---- |
| Anteil Notizen in kuratierter Schicht | Frontmatter `layer: curated` | waechst im Verhaeltnis |
| Synthese-Coverage | Anteil Ressourcen-Cluster mit aktiver MOC oder Synthese | steigt |
| Decay-Status | Anteil `gueltig` / `ueberpruefen` / `veraltet` in Ressourcen | gueltig-Anteil dominant |
| Pruning-Rate | Geloeschte oder archivierte Notizen pro Quartal | konstant positiv |

Die ersten drei werden durch Dataview-Queries gebildet, die vierte aus dem
Prune-Log gezaehlt. Wenn die Pruning-Rate dauerhaft auf null faellt, ist es
Sammeln, nicht Kuratierung.

## Bezug zu Karpathy

[Andrej Karpathys LLM-Wiki-Pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
nennt drei Operationen, die ein lebendiges Wissens-Wiki gesund halten:
Ingest, Query, Lint. In diesem Setup werden sie durch `/ingest` und `/lint`
implementiert (siehe Kapitel 06).

Karpathys Pattern beschreibt aber nur, wie Wissen reinkommt, abgefragt und
strukturell geprueft wird. Die Frage, ob das Wissen heute noch stimmt, ob es
verdichtet werden kann oder ob es ueberhaupt noch gebraucht wird, bleibt
offen. Genau das schliessen die drei neuen Skills:

| Karpathy-Operation | Implementierung | Erweiterung dieses Setups |
| ------------------ | --------------- | ------------------------- |
| Ingest | `/ingest` | — |
| Query | Wikilinks plus Synthese-Seiten plus `Index.md` | — |
| Lint | `/lint` | — |
| Verdichten | — | `/synthesize` (neu) |
| Altern lassen | — | `/decay` (neu) |
| Aussortieren | — | `/prune` (neu) |

Die drei neuen Skills bilden zusammen mit Karpathys Trias die sechs
Operationen, die ein Vault braucht, um nicht nur lebendig, sondern auch
kuratiert zu bleiben.

## Hinweise

### Rhythmus

- `synthesize`: quartalsweise pro aktivem Themen-Cluster
- `decay`: monatlich auf `04 Ressourcen/`, quartalsweise auf `03 Bereiche/`
- `prune`: quartalsweise, idealerweise direkt nach einem `decay`-Lauf

Wenn alle drei Skills im gleichen Quartal laufen, ist die Reihenfolge
sinnvoll: erst synthesize (damit Verdichtung passiert, bevor Kandidaten als
Orphans erscheinen), dann decay (damit Veraltung sichtbar wird), dann prune
(damit auf Basis aktueller Markierungen aufgeraeumt werden kann).

### Sicherheits-Defaults

- Kein Auto-Write. Jede Aenderung wird im Preview gezeigt und einzeln
  bestaetigt.
- Kein Auto-Delete. Pro Loesch-Kandidat eine eigene Confirmation, ohne
  Bulk-Antworten.
- Schutzzonen (`00 Kontext/`, `CLAUDE.md`, `log.md`, `Index.md`,
  `03 Bereiche/Skills/`, `07 Anhaenge/`, Daily Notes) bleiben unangetastet.
- Backup vor dem ersten `prune`-Lauf (Git-Commit reicht, sonst `tar`).
- `decay` veraendert nie den Notiz-Body, nur die Frontmatter.

### Pflicht-Bestaetigungen

`synthesize`, `decay` und `prune` arbeiten alle mit `AskUserQuestion`. Wer das
abkuerzen will, bekommt auch keine Sicherheits-Defaults mehr. Der Wert der
Skills liegt genau in der Reibung. Sie zwingt zur Entscheidung, die KI nicht
treffen kann.

### Bezug zu den anderen Skills

- [Kapitel 05 — Workflows](05-workflows.md) beschreibt den Alltag mit
  `ingest` und `lint`. Die Kuratierungs-Skills sind die Quartals-Schicht
  darueber.
- [Kapitel 06 — Skills](06-skills.md) beschreibt die ersten drei Skills im
  Detail. Dort liegt die Erklaerung von Karpathys Pattern, die hier
  vorausgesetzt ist.
- [`../skills/README.md`](../skills/README.md) listet alle sechs Skills mit
  Installationsbefehlen.

## Naechstes Kapitel

Das Handbuch endet hier. Wer den Setup-Workflow noch einmal als Checkliste
durchgehen will: zurueck zum [Quickstart in der README](../README.md#quickstart).
