---
name: prune
description: >
  Finds deletion candidates in the SecondBrain Obsidian vault (duplicates, old orphans,
  unused brain dumps, stale notes) and proposes deletion or archival. Strict per-item
  confirmation, no auto-delete. Use when the user says "prune", "deletion suggestions",
  "clean up the vault", "sort out", "find duplicates", "clear old orphans".
version: 1.0.1
user-invocable: true
allowed-tools:
  - Read
  - Edit
  - Write
  - Bash
  - Glob
  - Grep
  - AskUserQuestion
runtime: claude-local
layer-target: raw
---

# Prune Skill — Active Reduction for SecondBrain

You find deletion candidates in the SecondBrain vault and propose deletion or archival.
Quarterly cadence. Complement to `/lint` (diagnose), `/decay` (mark freshness) and
`/synthesize` (condense): lint only finds, decay only marks, prune actually removes.

## Vault

- **Path:** `/Users/tobiasschmidt/Obsidian/SecondBrain/`
- **Structure:** PARA (00 Kontext, 01 Inbox, 02 Projekte, 03 Bereiche, 04 Ressourcen, 05 Daily Notes, 06 Archiv, 07 Anhaenge)
- **Log:** `/Users/tobiasschmidt/Obsidian/SecondBrain/log.md`
- **Vault health (lint reports and prune logs):** `03 Bereiche/Vault-Gesundheit/`

## Safety defaults (critical)

1. **No auto-delete.** Each delete or archive is confirmed individually via AskUserQuestion.
2. **Backup the vault before the first prune run.** Example:

   ```bash
   cd /Users/tobiasschmidt/Obsidian/SecondBrain && \
     git add -A && git commit -m "pre-prune backup $(date +%F)"
   ```

   If the vault is not under git:

   ```bash
   tar -czf ~/Desktop/SecondBrain-backup-$(date +%F).tar.gz \
     -C /Users/tobiasschmidt/Obsidian SecondBrain
   ```

3. **When in doubt: archive instead of delete.**
4. **Ignore `07 Anhaenge/` entirely.**
5. **Never propose files from `00 Kontext/`, `CLAUDE.md`, `log.md`, `Index.md` or
   `03 Bereiche/Skills/`** as candidates.

## Invocation

| Input | Behaviour |
|-------|-----------|
| `/prune` | Full run, all four categories |
| `/prune duplicates` | Duplicates only |
| `/prune orphans` | Persistent orphans only |
| `/prune inbox` | Old brain dumps in `01 Inbox/` only |
| `/prune stale` | Notes with `freshness: veraltet` only |
| `/prune scan-only` | Pure scan, writes proposal list only, no actions |
| `/prune scan-only category:duplicates` | Scan mode, duplicates only |
| `/prune scan-only category:orphans` | Scan mode, orphans only |
| `/prune scan-only category:brain-dumps` | Scan mode, old brain dumps only |
| `/prune scan-only category:decayed` | Scan mode, stale notes only |

If nothing is specified, ask via AskUserQuestion before the run.

## Modes

| Mode | Trigger | Effect | Routine-safe |
|------|---------|--------|--------------|
| Full mode (default) | manual | per-item confirmation, real deletes and archives | no (interactive) |
| Scan mode (`scan-only`) | manual or routine | proposal list as scan report, NO actions | yes (autonomous) |

Scan is the sensor, the full run stays strictly manual. Deletes and archives must
never be automatable. Scan produces the picture, the user makes every decision in
the interactive full run.

## Scan mode workflow (`scan-only`)

When the invocation includes `scan-only`, follow this shortened, non-interactive path:

1. **Derive scope without prompting.** Default: all four categories. If a
   `category:<name>` filter is provided (`duplicates`, `orphans`, `brain-dumps`,
   `decayed`), restrict to that category.
2. **Skip the backup check.** No actions are taken, so no risk.
3. **Collect candidates as in full mode** (Step 2 below). Same heuristics, same
   protected zones, same recommendation rules.
4. **Write the scan report** to
   `03 Bereiche/Vault-Gesundheit/YYYY-MM-DD Prune Scan.md` (filename uses "Scan"
   instead of "Log" so it is clearly distinguishable from interactive runs).
5. **No `rm`, no `mv`.** No `AskUserQuestion`.
6. **Log entry in `log.md`** uses the prefix `prune-scan` instead of `prune`.

Scan report format:

```markdown
---
tags: [system, prune-scan]
date: YYYY-MM-DD
scope: <all | duplicates | orphans | brain-dumps | decayed>
source: claude
chat_url: <if known, else unknown>
---

# Prune Scan — YYYY-MM-DD

- Run date: YYYY-MM-DD
- Scope: <all | duplicates only | ...>
- Total candidates: N

## Duplicates

| Path A | Path B | Similarity | Reason | Recommendation |
|--------|--------|------------|--------|----------------|
| ... | ... | 0.82 | newer, fewer backlinks | delete |

## Persistent orphans

| Path | Reason | Recommendation |
|------|--------|----------------|
| ... | 3/3 lint runs, 47 words | delete |

## Old brain dumps

| Path | Reason | Recommendation |
|------|--------|----------------|
| ... | 13 months, no backlinks | archive |

## Stale notes

| Path | Reason | Recommendation |
|------|--------|----------------|
| ... | freshness: veraltet, last update 5 months ago | archive |

---

Next step: run `/prune` manually and work through per-item confirmation.
```

Append entry to `log.md`:

```markdown
## [YYYY-MM-DD] prune-scan | Scan run (autonomous)

- **Scope:** <all | duplicates only | ...>
- **Candidates:** N
- **Report:** [[YYYY-MM-DD Prune Scan]]
- **Note:** No actions taken. Next step: `/prune` manually.
```

This ends the scan mode. Steps 3 through 7 of the full mode are skipped.

## Full mode workflow

### Step 1: Choose scope

1. Check backup. If the user has none yet, point them at the backup commands and ask
   whether to proceed.
2. Ask which categories to scan (multi-select). Default: all.

### Step 2: Collect candidates

#### 2a) Duplicates

1. Title match across the vault, ignoring `07 Anhaenge/` and `06 Archiv/`.
2. For each title pair, call `scripts/find_duplicates.py` (bigram Jaccard on normalised
   text). Threshold >= 0.6 → duplicate suspicion.
3. Recommendation:
   - Older file with fewer backlinks → delete
   - Both equally linked but different content → archive or merge
   - Title-content mismatch → keep both

#### 2b) Persistent orphans (three lint runs)

1. Read the last three lint reports from `03 Bereiche/Vault-Gesundheit/`.
2. If fewer than three exist: fall back to the latest report with a warning.
3. Intersect — only files marked orphan in all three.
4. Live recheck via Grep for `[[Filename]]`. Drop matches.
5. Exclusions: daily notes, `00 Kontext/`, system files, synthesis start files,
   project and area hub files.
6. Recommendation: archive if > 200 words, else delete.

#### 2c) Old brain dumps in `01 Inbox/`

1. Glob `01 Inbox/*.md`.
2. Read frontmatter `date`, fall back to `stat -f %m`.
3. Keep entries older than 12 months.
4. Backlink check via Grep — drop linked files.
5. Recommendation: delete if < 100 words and no frontmatter, else archive.

#### 2d) Stale notes (`freshness: veraltet`)

1. Grep across vault for `freshness: veraltet` (skip `07 Anhaenge/`, `06 Archiv/`).
2. Read `aktualisiert` / `date`. Keep if last update > 90 days ago.
3. Recommendation: always archive, never delete.

### Step 3: Show candidate list

One block per category, per candidate one line with reason and recommendation.
If total > 30 candidates, ask whether to work one category at a time or all in sequence.

### Step 4: Per-candidate confirmation via AskUserQuestion

Options: `delete`, `archive`, `keep`, `skip`. Never offer bulk options.

### Step 5: Execute

- delete → `rm "<absolute path>"`
- archive → `mkdir -p "06 Archiv/<original folder>" && mv "<absolute path>" "06 Archiv/<original folder>/"`
- keep / skip → no action, log only

On error: log and continue.

### Step 6: Prune log

Write `03 Bereiche/Vault-Gesundheit/YYYY-MM-DD Prune Log.md` with summary table per
category and an error section.

### Step 7: Log entry in `log.md`

Append-only entry summarising counts and linking the prune log.

## Rules

1. No auto-delete. Per-item confirmation.
2. Archive over delete when uncertain.
3. Recommend backup beforehand.
4. Protected zones: `00 Kontext/`, `CLAUDE.md`, `log.md`, `Index.md`,
   `03 Bereiche/Skills/`, `07 Anhaenge/`, daily notes.
5. Synthesis start files (folder == filename) are never orphan candidates.
6. `log.md` is append-only; one prune log file per run in `03 Bereiche/Vault-Gesundheit/`.
7. Language: German for user-facing output unless explicitly asked otherwise.
