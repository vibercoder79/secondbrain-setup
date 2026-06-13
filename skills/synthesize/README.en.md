# Synthesize Skill — SecondBrain Condensation

Condenses notes of a topic cluster in the SecondBrain Obsidian Vault into a synthesis page or MOC (Map of Content). Lifts raw material from the raw layer into the curated layer. Quarterly usage.

> Workflow diagram: [`synthesize-overview.en.png`](synthesize-overview.en.png) (source: [`synthesize-overview.en.excalidraw`](synthesize-overview.en.excalidraw)).

German version: [README.md](README.md)

## Version

**v1.0.0** (June 2026) — Initial release

## Installation

```bash
cp -r ~/Documents/GitHub/claudecodeskills/synthesize ~/.claude/skills/synthesize
```

Test:

```
/synthesize
```

## Usage

| Invocation | Behavior |
|------------|----------|
| `/synthesize cluster:"04 Ressourcen/KI"` | Synthesis for the folder cluster |
| `/synthesize tag:#thema` | Synthesis for all notes carrying the tag |
| `/synthesize "path/to/folder"` | Synthesis for the folder path |
| `/synthesize` | Ask user via AskUserQuestion |

Triggers (German, verbatim): `synthesize`, `verdichte das wissen`, `synthese fuer`, `MOC fuer`, `map of content fuer`, `fasse das cluster zusammen`.

## What the skill does (6 steps)

1. **Pick cluster** — folder path, tag, or existing MOC. Report cluster size. Hint at sub-cluster split above 30 notes.
2. **Collect notes** — read all markdown files in the cluster fully (excluding `07 Anhaenge/`).
3. **Analyze** — group core statements into sub-topics, flag contradictions between notes, name gaps, mark single-source claims as weakly supported.
4. **Propose** — either a synthesis note (focused cluster) or an MOC (broad cluster). Default heuristic: 4+ sub-topics → MOC, else synthesis. Mandatory frontmatter `layer: curated`, `date`, `source`, `chat_url`, `related`.
5. **Preview and confirm** — full markdown shown in chat, target path visible. User picks write / adjust / discard. **No auto-write.**
6. **Write, backlink, log** — write the file, append `## Verwandte Notizen` link in each source note (idempotent), append entry to `log.md`.

## Background

### The problem

The raw layer (Inbox, Daily Notes, AI outputs) grows fast. Without condensation, knowledge stays scattered — many small notes, no committed answer to "what do we actually know about X?".

### The solution

Two-layer architecture. Raw layer collects, curated layer (MOCs, syntheses, ADRs, 00 Kontext) distills. `/synthesize` is the curatorial step: many notes become one committed page with sources, contradictions, and gaps visible.

### Sibling skills

| Skill | Purpose | Granularity |
|-------|---------|-------------|
| `/ingest` | Links individual note into vault | One note |
| `/lint` | Hygiene and compliance | Whole vault |
| `/synthesize` | Condenses cluster into MOC or synthesis | Topic cluster |
| `/decay` | Marks outdated content | Whole vault |
| `/prune` | Suggests deletions | Whole vault |

### Rhythm

Quarterly per active topic cluster. Triggered by lint reports (full inbox, many recent daily-note entries in the same tag range) or explicit user request.

## Rules

1. **NO auto-write** — file is written only after explicit confirmation
2. **NO auto-delete** — source notes only augmented
3. **NEVER duplicate** — backlinks are checked before insertion
4. **Source-faithful** — every claim points to a source
5. **Contradictions stay visible** — not resolved
6. **Ignore 07 Anhaenge/**
7. **Log is append-only**
8. **Output language: German** (Swiss High German, ss not ß)

## Sources

- Vault position paper: `SecondBrain/04 Ressourcen/Wissensmanagement/2026-06-13 Kuratierung im KI-Zeitalter.md`
- Sibling skills: [`ingest`](../ingest/), [`lint`](../lint/), [`decay`](../decay/), [`prune`](../prune/)
- Pattern inspiration: Andy Matuschak (Evergreen Notes), Nick Milo (MOCs)

## File layout

```
synthesize/
├── SKILL.md                          <- Skill logic DE
├── SKILL.en.md                       <- Skill logic EN
├── README.md                         <- README DE
├── README.en.md                      <- This file
├── synthesize-overview.excalidraw    <- Big Picture DE (source)
├── synthesize-overview.png           <- DE render
├── synthesize-overview.en.excalidraw <- Big Picture EN (source)
└── synthesize-overview.en.png        <- EN render
```

## Version history

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-06-13 | Initial release: 6-step workflow, synthesis and MOC, bilingual |
