# Decay Skill — SecondBrain Freshness Check

Finds old notes in the SecondBrain, validates verifiable claims against current reality (web search, doc updates), marks `freshness` status in frontmatter. Writes a monthly decay report into the vault health directory.

**The core idea:** Knowledge ages. `/lint` checks structure, `/ingest` connects single notes — `/decay` checks truth over time. Note content stays untouched, only frontmatter is augmented. Mitigation is the user's call.

German version: [README.md](README.md)

> Workflow diagram: [`decay-overview.en.excalidraw`](decay-overview.en.excalidraw) | [`decay-overview.en.png`](decay-overview.en.png) — rendered via `~/.claude/skills/excalidraw-diagram/references/render_excalidraw.py`.

## Version

**v1.0.1** (June 2026) — see [Version history](#version-history)

## Installation

```bash
cp -r ~/Documents/GitHub/claudecodeskills/decay ~/.claude/skills/decay
```

Quick check:

```
/decay
```

## Usage

| Input | Behavior |
|-------|----------|
| `/decay` | Full check with defaults (6 months, `04 Ressourcen`) |
| `/decay older-than:12m` | Adjust threshold (m=months, y=years) |
| `/decay folder:"03 Bereiche"` | Switch scope folder |
| `/decay older-than:3m folder:"02 Projekte"` | Combine arguments |
| `/decay note:"NoteName"` | Check a single note regardless of age |
| `/decay scan-only` | Scan mode: only write the scan report, no frontmatter writes, autonomous (no confirmation dialog). Combinable with `older-than:` and `folder:`. |

Other triggers (German): `decay`, `decay check`, `ist das noch aktuell`, `pruefe alte notizen`, `freshness check`, `wissens-altern`.

## Modes

| Mode | Trigger | Effect | Routine-safe |
|------|---------|--------|--------------|
| Full mode (default) | manual | scan, validate, write frontmatter with confirmation, report | no (interactive) |
| Scan mode (`scan-only`) | manual or routine | scan, validate, write only scan report, no frontmatter | yes (autonomous) |

**Role split:** Scan mode is the sensor — it runs autonomously in routines (scheduled agents), produces a scan report and writes nothing to source notes. Full mode is the action — it is triggered manually after the user has reviewed a scan report and writes the classification into frontmatter with confirmation.

### Examples

`/decay`
- Full mode, defaults (6 months, `04 Ressourcen`)
- Output: preview table, confirmation dialog, frontmatter updates in source notes, report `YYYY-MM-DD Decay Report.md`, log entry with prefix `decay`

`/decay scan-only`
- Scan mode, defaults (6 months, `04 Ressourcen`)
- Output: only the scan report `YYYY-MM-DD Decay Scan.md`, log entry with prefix `decay-scan`. No changes to source notes, no questions. Suited as a sensor inside scheduled agents.

`/decay scan-only older-than:12m folder:"03 Bereiche"`
- Scan mode with adjusted scope (12 months, `03 Bereiche`)
- Output: same as above, just wider scope

## What the skill does (8 phases)

1. **Scope** — Parse args, set defaults. Hard-exclude Daily Notes, archive, inbox, context, attachments.
2. **Find candidates** — Glob + age from frontmatter or mtime. Skip notes checked within last 30 days.
3. **Extract verifiable claims** — Versions, tool names, standards, URLs, availability statements, numbers with source.
4. **Web validation** — Max 3 calls per note. WebSearch first, WebFetch for concrete doc URLs. Bundle across notes.
5. **Preview + confirmation** — Grouped table, AskUserQuestion: apply all, go one by one, abort.
6. **Write frontmatter** — Edit, never overwrite existing fields:
   ```yaml
   freshness: gueltig | ueberpruefen | veraltet
   decay_checked_at: 2026-06-13
   decay_notes: short reason if needed
   ```
7. **Decay report** — Markdown in `03 Bereiche/Vault-Gesundheit/`. Filename depends on mode:
   - Full mode: `YYYY-MM-DD Decay Report.md`
   - Scan mode: `YYYY-MM-DD Decay Scan.md`
8. **Log entry** — Append-only in `log.md`. Prefix `decay` in full mode, `decay-scan` in scan mode.

## Why this skill?

### The problem

The SecondBrain holds notes about tools, versions, standards, doc URLs. They age. A note about "Claude Sonnet 4.5" or "OWASP Top 10:2025" may be outdated six months later. Without a marker, neither the user nor the next AI session knows whether an entry is still reliable.

### The solution

`decay` marks. Three statuses are enough:

- `gueltig` — claims still hold (or none are verifiable)
- `ueberpruefen` — signs of staleness, but no hard proof
- `veraltet` — clear evidence the claims no longer hold

What happens with stale notes is the user's call: update, archive, leave as is. The skill deletes nothing and rewrites no content.

### Why no auto-fix?

Fact correction is a content decision. The skill can detect that a URL returns 404, but not which successor is the right one. Mitigation stays with the user.

### Why bundle web calls?

Web validation is expensive and hard to reproduce. If five notes all mention "Claude Sonnet 4.5", one WebSearch is enough. The skill caches that result for the running session.

## Complementary skills

| Skill | Purpose |
|-------|---------|
| [`lint`](../lint/) | Vault structure, orphans, compliance, index cover |
| [`ingest`](../ingest/) | Connect single notes, bidirectional wikilinks |
| `decay` | Freshness over time, web validation |

Together these three make up the curation set for the SecondBrain.

## Rules

1. **ALWAYS preview before writing in full mode** — frontmatter is never set without confirmation
2. **Scan mode never writes to source notes** — only scan report and log entry
3. **NEVER change content** — decay only marks
4. **NEVER delete or archive** — mitigation is a suggestion
5. **Web calls sparingly** — max 3 per note, bundle across notes
6. **Respect hard excludes** — daily notes, archive, inbox, context, attachments never checked
7. **Reason required** for `ueberpruefen` and `veraltet` (full mode only)
8. **Log is append-only** — never modify existing entries; prefix `decay` in full mode, `decay-scan` in scan mode
9. **Language: German default** for output and report

## File structure

```
decay/
├── SKILL.md                       <- Skill logic DE (workflow, rules)
├── SKILL.en.md                    <- Skill logic EN (short form)
├── README.md                      <- German version
├── README.en.md                   <- This file
├── decay-overview.excalidraw      <- Workflow diagram DE (Excalidraw source)
├── decay-overview.png             <- Workflow diagram DE (rendered)
├── decay-overview.en.excalidraw   <- Workflow diagram EN (Excalidraw source)
└── decay-overview.en.png          <- Workflow diagram EN (rendered)
```

## Sources

- Position paper: `SecondBrain/04 Ressourcen/Wissensmanagement/2026-06-13 Kuratierung im KI-Zeitalter.md`
- Sister skills: [`lint`](../lint/), [`ingest`](../ingest/)
- Karpathy LLM Wiki Pattern (pre-processing over real-time search) — basis for `Index.md` in `/lint`, here indirectly: decay markers as pre-processed truth annotation

## Version history

| Version | Date | Changes |
|---------|------|---------|
| 1.0.1 | 2026-06-13 | Scan mode added for routine triggering (autonomous, no frontmatter writes) |
| 1.0.0 | 2026-06-13 | Initial release: 8-phase workflow with web validation, frontmatter marking, report in Vault-Gesundheit/ |
