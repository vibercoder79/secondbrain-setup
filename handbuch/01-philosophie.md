# 01 — Philosophie: Warum dieses Setup existiert

> Kurzfassung: Ein einziges Markdown-Vault als gemeinsames Gehirn fuer alle deine KIs.
> PARA gibt die Ordnung, Karpathys LLM-Wiki-Pattern die Lebendigkeit, Wikilinks die
> Vernetzung. Drei oder vier KIs schreiben in dasselbe Vault, ohne sich gegenseitig
> auf die Fuesse zu treten.

## Das Problem

KIs sind nuetzlich, aber sie sind Inseln. Du recherchierst in Perplexity, planst in
Claude Desktop, programmierst in Claude Code, schreibst Mails mit Gemini, generierst
Code-Skeletons mit Codex. Jede dieser KIs hat ihre eigene History, ihren eigenen
Kontext, ihre eigenen Erinnerungen. Wenn du Montag mit Claude ueber ein Projekt
sprichst und Dienstag dasselbe Projekt mit Gemini besprichst, faengt Gemini bei Null
an.

Drei Symptome sind typisch:

1. **Verstreutes Wissen.** Ein Research-Ergebnis aus Perplexity, eine Entscheidung
   aus einem Claude-Chat, eine Code-Skizze aus Codex. Drei Orte, drei Formate, kein
   gemeinsamer Index.
2. **Kein Compound-Effekt.** Jede Session faengt mit Kontext-Aufbau an. Du erklaerst
   wiederholt was das Projekt ist, wo es steht, was schon entschieden wurde.
3. **Kein Eigentum am eigenen Wissen.** Wenn der Chat-Verlauf weg ist (geloescht,
   nicht exportiert, KI-Anbieter-Wechsel), ist die Erkenntnis weg.

Klassische Loesungen wie "Memory" oder "Custom Instructions" in einer einzelnen KI
loesen das nicht — sie zentrieren das Wissen in der KI, nicht beim Nutzer.

## Die zwei Inspirationen

### Tiago Forte — PARA und Building a Second Brain

PARA ist eine 4-Ordner-Methode: **P**rojects, **A**reas, **R**esources, **A**rchives.
Plus ein **Inbox** fuer Unsortiertes. Die Idee: jede Information hat einen klaren
Platz, sortiert nach **Handlungsdruck**, nicht nach Thema. Projekte haben ein Ziel
und ein Enddatum, Areas sind laufende Verantwortungen ohne Enddatum, Resources sind
Referenzmaterial, Archives sind abgeschlossen.

PARA gibt diesem Setup das **Skelett**: eine vorhersagbare Ordnerstruktur, in der
KIs und Menschen wissen, wo etwas hingehoert.

### Andrej Karpathy — LLM-Wiki-Pattern

Karpathy hat in seinem Gist `LLM-as-a-Wiki` ([Quelle](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f))
ein anderes Muster beschrieben: statt einzelne Dokumente per RAG bei Bedarf
abzurufen, pflegt ein LLM ein **strukturiertes Markdown-Wiki inkrementell**. Neue
Quellen werden eingearbeitet, Querverweise aktualisiert, Widersprueche markiert.
Drei Operationen sind zentral:

- **Ingest:** Neue Quelle verarbeiten, 10-15 Wiki-Seiten gleichzeitig aktualisieren,
  Wikilinks setzen.
- **Query:** Wiki durchsuchen, Antworten mit Zitaten synthetisieren, wertvolle
  Erkenntnisse als neue Seiten anlegen.
- **Lint:** Periodische Gesundheitschecks — Widersprueche, veraltete Claims,
  verwaiste Seiten, Wissensluecken.

Karpathys Idee gibt diesem Setup die **Lebendigkeit**: das Vault wird nicht nur
abgelegt, sondern aktiv weiterentwickelt. Wikilinks vernetzen, Synthese-Seiten
verdichten, Lint-Reports zeigen Drift.

## Die Synthese

PARA ohne Karpathy: ein sauberes Ablagesystem, aber statisch. Karpathy ohne PARA:
lebendige Vernetzung, aber niemand weiss, wo etwas hingehoert. Die Kombination ist
mehr als die Summe ihrer Teile:

| Aspekt        | PARA                       | Karpathy LLM-Wiki              | Dieses Setup |
| ------------- | -------------------------- | ------------------------------ | ------------ |
| Grundansatz   | Ordnungssystem             | Verarbeitungssystem            | Beides       |
| Organisation  | Feste Ordnerstruktur       | Schema-basiert, LLM entscheidet | Feste Ordner + LLM-Workflows |
| Wer pflegt    | Nutzer legt ab             | LLM pflegt aktiv               | Nutzer legt ab, LLM verdichtet |
| Staerke       | Struktur, Wiederauffindbar | Synthese, Compound-Effekt      | Beides       |
| Schwaeche     | Wissen liegt oft isoliert  | Keine Ablage-Struktur          | — |

## Multi-KI: ein Vault, viele Tore

Der zweite Hebel ist die **KI-Agnostik**. Das Vault ist die Single Source of Truth,
nicht der Chat-Verlauf einer bestimmten KI. Jede KI bekommt eine duenne Konfig-Datei,
die auf das Vault verweist:

- `~/.claude/CLAUDE.md` → verweist auf `~/Obsidian/SecondBrain/CLAUDE.md`
- `~/.gemini/GEMINI.md` → verweist auf `~/Obsidian/SecondBrain/CLAUDE.md`
- `~/.codex/AGENTS.md`  → verweist auf `~/Obsidian/SecondBrain/CLAUDE.md`
- Claude Desktop → liest das Vault per Filesystem-MCP-Server

Das ist das **Hub-and-Spoke-Pattern** (Kapitel 02). Aenderst du eine Regel im Vault,
sehen alle KIs sie sofort. Wechselst du den KI-Anbieter, bleibt das Wissen.

## Was du davon hast

Wenn das Setup laeuft, bekommst du drei Dinge:

1. **Kontinuitaet zwischen Sessions.** Eine KI liest beim Session-Start die
   `Index.md` (das Vault-Cover, vom `/lint`-Skill generiert) und weiss sofort,
   welche Projekte aktiv sind, was Stand letzte Woche war, wo Entscheidungen
   dokumentiert sind.
2. **Compound-Effekt.** Jede neue Research-Notiz wird per `/ingest` mit dem
   Bestand vernetzt. Wikilinks setzen sich bidirektional. Synthese-Seiten
   wachsen. Das Vault wird mit jeder Quelle besser.
3. **Wechselbarkeit.** Wenn morgen ein besseres Modell oder ein anderer Anbieter
   kommt, ziehst du die Konfig-Datei um. Das Wissen bleibt, weil es deins ist
   und in Markdown liegt, nicht in irgendeiner Vendor-Datenbank.

## Was du dafuer aufbringen musst

Drei Dinge sind nicht verhandelbar:

1. **Disziplin beim Speichern.** Eine Daily Note pro Tag, neue Notizen mit
   Frontmatter, Inbox regelmaessig leeren. Das System ist nur so gut wie die
   Inputs.
2. **Vertrauen in Markdown.** Keine proprietaeren Formate, keine Datenbanken.
   Markdown + Wikilinks + YAML-Frontmatter. Wenn dir das zu Old-School ist,
   ist das Setup nichts fuer dich.
3. **Ein Texteditor mit Wikilink-Support.** Empfehlung: [Obsidian](https://obsidian.md).
   Kostenlos, lokal, Plugin-faehig. Du kannst auch andere nehmen
   (Logseq, Foam in VSCode, plain Markdown), aber dieses Setup ist auf
   Obsidian-Konventionen abgestimmt (Wikilinks `[[Name]]`, Dataview-Queries,
   Excalidraw-Plugin).

## Wer das nicht braucht

- Wer nur eine einzige KI nutzt und damit zufrieden ist.
- Wer keine wiederkehrenden Projekte hat und keine Compound-Erkenntnisse braucht.
- Wer "Memory" in der KI-App ausreicht.

Wenn du aber zwei oder mehr KIs ernsthaft im Alltag nutzt und merkst, dass dein
Wissen verstreut liegt — dann lies weiter.

## Naechstes Kapitel

→ [02 — Architektur: Hub-and-Spoke und das Drei-Ebenen-Modell](02-architektur.md)
