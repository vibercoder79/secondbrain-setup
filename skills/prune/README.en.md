# Prune Skill — Active Reduction in SecondBrain

`/prune` finds deletion candidates in the SecondBrain Obsidian vault and proposes
deletion or archival. Quarterly cadence. Strict per-item confirmation, no auto-delete.

Part of the curation pattern with `/lint` (diagnose), `/synthesize` (condense),
`/decay` (mark freshness) and `/prune` (reduce).

> Workflow diagram: [`prune-overview.en.excalidraw`](prune-overview.en.excalidraw) —
> PNG render to follow.

## Version

**v1.0.1** (June 2026) — Scan mode added for routine-driven runs.

## Installation

```bash
cp -r ~/Documents/GitHub/claudecodeskills/prune ~/.claude/skills/prune
```

Check:

```
/prune
```

## Usage

| Input | Behaviour |
|-------|-----------|
| `/prune` | Full run, all four categories |
| `/prune duplicates` | Duplicates only |
| `/prune orphans` | Persistent orphans only (three lint runs) |
| `/prune inbox` | Old brain dumps in `01 Inbox/` only |
| `/prune stale` | `freshness: veraltet` notes only |
| `/prune scan-only` | Scan mode, writes proposal list only, no actions |
| `/prune scan-only category:duplicates` | Scan mode, duplicates only |
| `/prune scan-only category:orphans` | Scan mode, orphans only |
| `/prune scan-only category:brain-dumps` | Scan mode, old brain dumps only |
| `/prune scan-only category:decayed` | Scan mode, stale notes only |

## Modes

| Mode | Trigger | Effect | Routine-safe |
|------|---------|--------|--------------|
| Full mode (default) | manual | per-item confirmation, real deletes and archives | no (interactive) |
| Scan mode (`scan-only`) | manual or routine | proposal list as scan report, NO actions | yes (autonomous) |

Scan is the sensor, the full run stays strictly manual. Deletes and archives must
never be automatable. Scan produces the picture, the user makes every decision in
the full run.

### Example: scan run

```
/prune scan-only
```

Sample output (truncated):

```markdown
# Prune Scan — 2026-06-13

- Run date: 2026-06-13
- Scope: all
- Total candidates: 12

## Duplicates

| Path A | Path B | Similarity | Reason | Recommendation |
|--------|--------|------------|--------|----------------|
| 04 Ressourcen/.../Setup Web Clipper.md | 01 Inbox/Setup Web Clipper.md | 0.82 | newer, fewer backlinks | delete |

## Old brain dumps

| Path | Reason | Recommendation |
|------|--------|----------------|
| 01 Inbox/Gedanke RAG vs. Wiki.md | 13 months, no backlinks | archive |

---

Next step: run `/prune` manually and work through per-item confirmation.
```

No files are deleted or moved. The scan report lives at
`03 Bereiche/Vault-Gesundheit/YYYY-MM-DD Prune Scan.md`.

## Categories

### 1. Duplicates

Title match plus content similarity (bigram Jaccard, threshold >= 0.6) via
[`scripts/find_duplicates.py`](scripts/find_duplicates.py). Recommendation per pair:
delete the newer copy with fewer backlinks.

### 2. Persistent orphans

Intersection of the last three lint reports from `03 Bereiche/Vault-Gesundheit/`
plus a live recheck via Grep. Recommendation: archive if > 200 words, else delete.

### 3. Old brain dumps

`01 Inbox/` files older than 12 months without backlinks. Recommendation: delete
if < 100 words and no frontmatter, else archive.

### 4. Stale notes

Notes with `freshness: veraltet` in the frontmatter whose last update is > 90 days
old. Recommendation: always archive.

## Safety defaults

1. **No auto-delete.** Each action confirmed individually.
2. **Back up the vault before the first run.**
3. **When in doubt: archive instead of delete.**
4. **Protected zones:** `00 Kontext/`, `CLAUDE.md`, `log.md`, `Index.md`,
   `03 Bereiche/Skills/`, `07 Anhaenge/`, daily notes.
5. **Scan mode is the only automatable variant.** Deletion and archival stay
   strictly interactive. A routine may run `/prune scan-only`, never `/prune`.
   That guarantees no routine run can ever touch files.

## Workflow

1. Choose scope and categories
2. Collect candidates per category
3. Show candidate list with reasoning
4. Per-item confirmation via AskUserQuestion (delete / archive / keep / skip)
5. Execute (`rm` or `mv` into `06 Archiv/`)
6. Prune log in `03 Bereiche/Vault-Gesundheit/YYYY-MM-DD Prune Log.md`
7. Append entry to `log.md`

## Background

### Problem

Lint marks drift, decay marks freshness, synthesize condenses. Nobody deletes. The
vault grows monotonically; brain dumps, duplicates and persistent orphans linger.
Signal-to-noise drops. Claude spends more tokens on vault scans, the user finds
relevant content less reliably.

### Solution

Quarterly prune actively clears, but under strict control: candidates are proposed
only; each candidate triggers an explicit four-option question; archival is the
default-safe choice; every decision is logged.

### Sources

- Position paper: `04 Ressourcen/Wissensmanagement/2026-06-13 Kuratierung im KI-Zeitalter.md`
- Sibling skills: [`lint`](../lint/), [`ingest`](../ingest/), `decay`, `synthesize`

## File structure

```
prune/
├── SKILL.md                      <- Skill logic DE
├── SKILL.en.md                   <- Skill logic EN
├── README.md                     <- DE
├── README.en.md                  <- This file
├── prune-overview.excalidraw     <- Workflow diagram DE
├── prune-overview.png            <- Workflow diagram DE (TODO)
├── prune-overview.en.excalidraw  <- Workflow diagram EN
├── prune-overview.en.png         <- Workflow diagram EN (TODO)
└── scripts/
    └── find_duplicates.py        <- Bigram Jaccard heuristic
```

## Version history

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-06-13 | Initial release: 4-category workflow with per-item confirmation |
| 1.0.1 | 2026-06-13 | Scan mode added for routine-driven runs (autonomous, no rm/mv). Full mode unchanged. |
