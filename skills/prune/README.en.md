# Prune Skill — Active Reduction in SecondBrain

`/prune` finds deletion candidates in the SecondBrain Obsidian vault and proposes
deletion or archival. Quarterly cadence. Strict per-item confirmation, no auto-delete.

Part of the curation pattern with `/lint` (diagnose), `/synthesize` (condense),
`/decay` (mark freshness) and `/prune` (reduce).

> Workflow diagram: [`prune-overview.en.excalidraw`](prune-overview.en.excalidraw) —
> PNG render to follow.

## Version

**v1.0.0** (June 2026) — Initial release.

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
