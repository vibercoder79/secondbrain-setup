# 09 — Curation: synthesize, decay, prune

> Short version: Collecting is not knowing. Curation is the discipline that
> turns a full vault into a usable knowledge store. AI makes the problem
> harder, not easier. Three new skills close the gap: `synthesize` condenses,
> `decay` flags aging, `prune` removes ballast.

## What this chapter is about

The first six chapters covered structure, architecture and the three skills
`projekt-init`, `ingest` and `lint`. That gives you creation, linking and
hygiene checks. What is still missing is the discipline behind it: what stays
in the vault, in which form, and for how long?

That is curation. It matters more with every new AI session, because AI
produces more than a human can reasonably sort in finite time. This chapter
covers the standpoint behind that observation, the two-layer model and the
three new skills called `synthesize`, `decay` and `prune`.

> Trigger sentences for the skills stay in German because German is the
> primary working language of this setup. The skills react to phrases like
> "verdichte das wissen", "ist das noch aktuell", "vault entruempeln" as well
> as to the slash commands.

## What is curation?

The term comes from the museum and archive world. Latin *curare* means to
take care of. Curation is not collecting. It is the deliberate decision about
what stays, in which form, and in which context. In a PKM setting, curation
breaks down into seven disciplines:

| Nr. | Discipline | Question | Covered in this setup |
| --- | ---------- | -------- | --------------------- |
| 1 | Selection | What gets in at all? | Partially (inbox trigger) |
| 2 | Classification | Where does it belong? | Yes (`/ingest`, PARA) |
| 3 | Annotation | What does it mean for me? | Manual, no skill |
| 4 | Linking | How is it connected? | Yes (`/ingest`, wikilinks) |
| 5 | Condensation | How do N notes become one insight? | Yes (`/synthesize`, new) |
| 6 | Decay check | Is this still true today? | Yes (`/decay`, new) |
| 7 | Pruning | What has to go? | Yes (`/prune`, new) |

Before the three new skills, `lint` covered hygiene and `ingest` covered
linking. Condensation, decay checks and pruning were the gap. That is exactly
where AI made the problem harder, not easier.

## Why AI makes it harder

Six reasons, sorted by weight. They are the reason the three new skills
exist at all.

### 1. Volume asymmetry

AI produces fifty pages of output in five minutes. The curation capacity
(attention, energy) stays constant. The ratio of incoming to processed flips
from roughly 1:1 to 50:1. Without a counter-measure, the vault becomes a
searchable garbage pile.

### 2. Garbage in, garbage out squared

As soon as the vault serves as AI context (RAG, MCP, agent memory,
auto-memory), every uncurated note becomes part of the answer base. Bad
curation actively degrades AI answers and reproduces errors across sessions.
Classic PKM did not have that pressure: a bad note only made retrieval
harder, it did not shift what counted as truth.

### 3. Context erosion

AI outputs are smooth, generic, context-free. They look valuable but they
are not your own insight. A Second Brain without your own thinking turns
into a locally mounted AI cache.

### 4. Decay

Knowledge ages faster than before. What was true about LLMs in 2024 is wrong
in 2026. Frameworks change, models get replaced. A vault without a decay
mechanism is an archive of outdated truths with a search box.

### 5. Synthesis cannot be delegated

AI can summarize. AI cannot form your synthesis from twelve sources weighted
by your own experience. That layer is the actual value of a Second Brain.
AI-driven production tends to skip it.

### 6. Identity drift

A Second Brain ideally mirrors its owner. AI mirrors the training average.
If 80 percent of the vault is AI output, it is not a Second Brain anymore.

## Two-layer architecture

The six reasons lead to a deliberate split in the vault. The raw layer is
large and volume-tolerant, the curated layer is small and
quality-controlled. The curated layer is the primary context source for AI.

| Layer | Content | Quality bar | Volume |
| ----- | ------- | ----------- | ------ |
| Raw layer | Inbox, daily notes, brain dumps, raw AI outputs, meeting notes | volume-tolerant, searchable | unlimited |
| Curated layer | MOCs, syntheses, ADRs, `00 Kontext`, your own writing, frameworks | high, quality-controlled | deliberately small |

Practical consequence: AI context sources like RAG or the filesystem MCP
feed primarily from the curated layer. The raw layer stays a source, not a
truth. Without that split, AI does not care whether it quotes a brain dump
or an ADR.

Sketch:

```
┌─────────────────────────────────────────────┐
│  CURATED LAYER (small, quality-controlled,  │
│  serves as AI context source)               │
│  MOCs, syntheses, ADRs, 00 Kontext,         │
│  your own writing, frameworks               │
└────────────▲────────────────────────────────┘
             │
        synthesize  (lifts)
        decay       (checks)
        prune       (removes)
             │
┌────────────▼────────────────────────────────┐
│  RAW LAYER (large, volume-tolerant)         │
│  Inbox, brain dumps, raw AI outputs,        │
│  daily notes, meeting notes                 │
└─────────────────────────────────────────────┘
```

Diagram source: [`../diagramme/09-zwei-schichten-de.png`](../diagramme/09-zwei-schichten-de.png).

The three arrows are the three new skills. Synthesize lifts raw material
into the curated layer. Decay checks whether the curated layer still holds.
Prune reduces the raw layer.

## Three new skills

All three follow the same safety defaults: no auto-write, no auto-delete,
every change confirmed individually. They suggest, the owner decides. That
is exactly what curation is.

### `synthesize` — condense

**Triggers:** `/synthesize cluster:"<folder>"`, `/synthesize tag:#<tag>`,
`/synthesize "<path>"`, or German phrases like "synthesize", "verdichte das
wissen", "MOC fuer", "fasse das cluster zusammen".

**What it does**

1. Pick a cluster (folder, tag or existing MOC). Above 30 notes, warn first
   that the cluster may be too big.
2. Read all notes in the cluster, in full.
3. Analysis: form sub-topics, flag contradictions, name gaps, mark
   weakly-supported claims.
4. Suggest in two formats: a **synthesis note** when the cluster is focused,
   a **MOC** when it is broad (default cut-off at four sub-topics).
5. Preview in chat plus target path. Nothing is written without
   confirmation.
6. Write, set back-links in the source notes, append to `log.md`.

Recommended cadence: once per quarter per active topic cluster. Typical
triggers are a full inbox or a block of daily-note entries in the same tag
range.

**Example**

```
> /synthesize cluster:"04 Ressourcen/KI"

Reads all notes in the KI folder, groups by topic tag, shows:
- Current insights per topic
- Contradictions across notes
- Gaps (topics without evidence)
Proposes a MOC or synthesis note.
Owner decides whether to keep it.
```

Skill source: [`../skills/synthesize/`](../skills/synthesize/).

### `decay` — flag aging

**Triggers:** `/decay`, `/decay older-than:12m folder:"03 Bereiche"`,
`/decay note:"<note>"`, or phrases like "decay check", "ist das noch
aktuell", "pruefe alte notizen", "freshness check".

**What it does**

1. Pick a scope (defaults: older-than 6 months, folder `04 Ressourcen`).
   Hard excludes: daily notes, archive, inbox, `00 Kontext`, attachments.
2. Find candidates via `aktualisiert`, `date` or mtime. Skip notes whose
   `decay_checked_at` is younger than 30 days.
3. Extract checkable claims per candidate: version numbers, tool and
   product names, standards, doc URLs, concrete numbers with sources. If
   nothing is checkable, the note counts as `gueltig` without a web call.
4. Web validation, sparingly. At most three calls per note. Bundle across
   notes where possible.
5. Classify as `gueltig` / `ueberpruefen` / `veraltet` with a reason in
   `decay_notes`. The note body is **never** touched, only the frontmatter.
6. Preview, then write. Decay report goes to
   `03 Bereiche/Vault-Gesundheit/YYYY-MM-DD Decay Report.md`, plus a
   `log.md` entry.

Recommended cadence: monthly on `04 Ressourcen/`, quarterly on
`03 Bereiche/`.

**Example**

```
> /decay older-than:6m folder:"04 Ressourcen"

Finds notes older than six months in resources.
Validates checkable claims against web search.
Marks frontmatter:
  freshness: gueltig | ueberpruefen | veraltet
  decay_checked_at: 2026-06-13
Writes a report to the vault-health folder.
```

Skill source: [`../skills/decay/`](../skills/decay/).

### `prune` — remove ballast

**Triggers:** `/prune`, `/prune duplikate`, `/prune orphans`, `/prune
inbox`, `/prune veraltet`, or phrases like "prune", "loesch-vorschlaege",
"vault entruempeln", "duplikate finden", "alte orphans aufraeumen".

**What it does**

1. Backup hint. If the vault is in Git, a commit is enough; otherwise
   `tar`. Only then continue.
2. Collect candidates in four categories:
   - **Duplicates** (title match plus content similarity above 0.6 on
     bigram Jaccard)
   - **Stale orphans** (orphan in the last three lint reports)
   - **Old brain dumps** in `01 Inbox/` (older than 12 months, no
     back-links)
   - **Outdated notes** with `freshness: veraltet` and last update more
     than 90 days ago
3. Show a proposal list with reason and recommendation (delete or
   archive).
4. Per candidate, ask individually with the options delete, archive, keep,
   skip. No bulk answers.
5. Execute (`rm` or `mv` into `06 Archiv/<original-path>`).
6. Write a prune log to `03 Bereiche/Vault-Gesundheit/YYYY-MM-DD Prune
   Log.md`, plus a `log.md` entry.

Protected zones, never proposed as candidates: `00 Kontext/`, `CLAUDE.md`,
`log.md`, `Index.md`, `03 Bereiche/Skills/`, `07 Anhaenge/`, daily notes,
synthesis start files.

Recommended cadence: quarterly.

**Example**

```
> /prune

Looks for deletion candidates:
- Duplicates (title match plus content similarity)
- Orphans persistent across three lint reports
- Brain dumps older than twelve months, nowhere linked
- Notes with freshness: veraltet
Shows the proposal list with a reason per item.
Owner confirms individually. No auto-delete.
```

Skill source: [`../skills/prune/`](../skills/prune/).

## Curation KPIs

What is not measured is not curated. The vault-health hub
(`03 Bereiche/Vault-Gesundheit/`) holds a trend block with four numbers
tracked over time:

| KPI | Source | Goal |
| --- | ------ | ---- |
| Share of notes in the curated layer | frontmatter `layer: curated` | grows over time |
| Synthesis coverage | share of resource clusters with an active MOC or synthesis | rises |
| Decay status | share of `gueltig` / `ueberpruefen` / `veraltet` in resources | `gueltig` dominant |
| Pruning rate | notes deleted or archived per quarter | consistently positive |

The first three come from Dataview queries. The fourth is counted from the
prune log. If the pruning rate stays at zero, you are collecting, not
curating.

## Relation to Karpathy

[Andrej Karpathy's LLM wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
names three operations that keep a living knowledge wiki healthy: ingest,
query, lint. This setup implements them via `/ingest` and `/lint` (see
chapter 06).

Karpathy's pattern only covers how knowledge comes in, gets queried and
gets structurally checked. The question whether the knowledge still holds,
whether it can be condensed, or whether it is needed at all, stays open.
The three new skills close that gap:

| Karpathy operation | Implementation | Extension in this setup |
| ------------------ | -------------- | ----------------------- |
| Ingest | `/ingest` | — |
| Query | wikilinks plus synthesis pages plus `Index.md` | — |
| Lint | `/lint` | — |
| Condense | — | `/synthesize` (new) |
| Age | — | `/decay` (new) |
| Sort out | — | `/prune` (new) |

Together with Karpathy's triad, the three new skills form the six
operations a vault needs to stay not just alive, but curated.

## Notes

### Cadence

- `synthesize`: quarterly per active topic cluster
- `decay`: monthly on `04 Ressourcen/`, quarterly on `03 Bereiche/`
- `prune`: quarterly, ideally right after a `decay` run

When all three skills run in the same quarter, a sensible order is:
synthesize first (so condensation happens before candidates would show up
as orphans), then decay (so aging becomes visible), then prune (so the
clean-up acts on fresh markings).

### Safety defaults

- No auto-write. Every change is shown in preview and confirmed
  individually.
- No auto-delete. One confirmation per deletion candidate, no bulk
  answers.
- Protected zones (`00 Kontext/`, `CLAUDE.md`, `log.md`, `Index.md`,
  `03 Bereiche/Skills/`, `07 Anhaenge/`, daily notes) stay untouched.
- Backup before the first `prune` run (a Git commit is enough; otherwise
  `tar`).
- `decay` never changes the note body, only the frontmatter.

### Required confirmations

`synthesize`, `decay` and `prune` all work via `AskUserQuestion`. Skipping
that also skips the safety defaults. The value of the skills sits exactly
in the friction. It forces a decision the AI cannot take.

### Cross-references

- [Chapter 05 — Workflows](05-workflows.md) describes the daily routine
  with `ingest` and `lint`. The curation skills are the quarterly layer
  above that.
- [Chapter 06 — Skills](06-skills.md) covers the first three skills in
  depth. That is where the Karpathy pattern is introduced, which is
  assumed here.
- [`../skills/README.md`](../skills/README.md) lists all six skills with
  install commands.

## End of the handbook

This is the last chapter. If you want to walk the setup workflow again as a
checklist, jump back to the [quickstart in the README](../README.en.md#quickstart).
