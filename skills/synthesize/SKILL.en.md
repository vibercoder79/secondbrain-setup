---
name: synthesize
description: >
  Condenses notes of a topic cluster in the SecondBrain Obsidian Vault into a synthesis page
  or MOC (Map of Content). Surfaces contradictions and gaps. Lifts raw material into the
  curated layer. Use when the user says "synthesize", "verdichte das wissen", "MOC fuer",
  "fasse das cluster zusammen".
version: 1.0.0
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
layer-target: curated
---

# Synthesize Skill — SecondBrain Condensation

Condense the raw notes of a topic cluster in the SecondBrain into a synthesis page
or MOC (Map of Content). This lifts raw material from the raw layer (Inbox, Daily Notes,
AI outputs) into the curated layer (MOCs, syntheses, ADRs, 00 Kontext).

Complementary to the sibling skills:

- `/ingest` links individual notes
- `/lint` checks hygiene
- `/decay` and `/prune` keep the layer clean

`/synthesize` is the curatorial step: from many to few, but committed.

German version: [SKILL.md](SKILL.md)

## Vault

- **Path:** `/Users/tobiasschmidt/Obsidian/SecondBrain/`
- **Structure:** PARA (00 Kontext, 01 Inbox, 02 Projekte, 03 Bereiche, 04 Ressourcen, 05 Daily Notes, 06 Archiv, 07 Anhaenge)
- **Two-layer architecture:** raw layer (Inbox, Daily Notes, AI outputs) and curated layer (MOCs, syntheses, ADRs, 00 Kontext)
- **Log:** `/Users/tobiasschmidt/Obsidian/SecondBrain/log.md`

## Invocation

| Input | Behavior |
|-------|----------|
| `/synthesize cluster:"04 Ressourcen/KI"` | Synthesis for the folder cluster |
| `/synthesize tag:#thema` | Synthesis for all notes with the tag |
| `/synthesize "path/to/folder"` | Synthesis for the folder path |
| `/synthesize` (no argument) | Ask via AskUserQuestion |

Triggers (German, kept verbatim): "synthesize", "verdichte das wissen", "synthese fuer",
"MOC fuer", "map of content fuer", "fasse das cluster zusammen".

## Workflow (6 steps)

1. **Pick cluster** — Folder path, tag, or existing MOC. Confirm note count with the user.
2. **Read notes** — Full text, capture frontmatter, core statements, entities. Skip `07 Anhaenge/`.
3. **Analyze:**
   - Group core statements into sub-topics
   - Mark contradictions between notes (with source links)
   - Name gaps (questions the cluster does not answer)
   - Flag claims that rest on a single source as "weakly supported"
4. **Propose** — Either a synthesis note (focused cluster, one core topic) or an MOC (broad cluster). Show full preview. Default: MOC from 4 sub-topics, otherwise synthesis.
5. **Preview and confirm** — User picks write / adjust / discard. No auto-write.
6. **Write, backlink, log:**
   - Write the file to the proposed path
   - Add backlink to each source note under `## Verwandte Notizen` (idempotent)
   - Append entry to `log.md`

## Templates

### Synthesis frontmatter

```yaml
---
layer: curated
type: synthese
date: YYYY-MM-DD
tags: [synthese, <cluster-tag>]
source: claude
chat_url: <url-or-unknown>
related:
  - "[[Source Note 1]]"
---
```

### MOC frontmatter

```yaml
---
layer: curated
type: moc
date: YYYY-MM-DD
tags: [moc, <cluster-tag>]
source: claude
chat_url: <url-or-unknown>
---
```

## Rules

1. **NO auto-write** — file is written only after explicit confirmation
2. **NO auto-delete** — source notes are only augmented, never modified destructively
3. **NEVER duplicate** — check existing backlinks before adding
4. **Source-faithful** — every claim in the synthesis must point to a source note
5. **Do not resolve contradictions** — make them visible, user decides
6. **Ignore 07 Anhaenge/** — no images or PDFs
7. **Log is append-only**
8. **Output language: German** (Swiss High German, ss not ß)
9. **Mandatory frontmatter:** `layer: curated`, `date`, `source: claude`, `chat_url`, plus `related` for syntheses

## Usage rhythm

Quarterly per active topic cluster. Triggered by Lint reports (full inbox, many recent
daily-note entries in the same tag range) or explicit user request.

## Background

Vault position paper: `04 Ressourcen/Wissensmanagement/2026-06-13 Kuratierung im KI-Zeitalter.md`
