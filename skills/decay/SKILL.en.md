---
name: decay
description: >
  Checks notes in the SecondBrain Obsidian Vault for staleness. Finds old notes,
  validates verifiable claims against current reality (web search), marks freshness
  status in frontmatter. Writes a decay report to the vault health directory.
  Use when the user says "decay", "decay check", "is this still current",
  "check old notes", "freshness check".
version: 1.0.1
user-invocable: true
allowed-tools:
  - Read
  - Edit
  - Write
  - Bash
  - Glob
  - Grep
  - WebSearch
  - WebFetch
  - AskUserQuestion
runtime: claude-local
layer-target: both
---

# Decay Skill — SecondBrain Freshness Check

Check notes in the SecondBrain for staleness. Notes older than a threshold are
scanned for verifiable claims (versions, dates, tool names, standards, URLs) and
marked with a `freshness` status in their frontmatter.

Complementary to `/lint` (vault structure check) and `/ingest` (linking individual
notes): decay checks truth over time.

German version: [SKILL.md](SKILL.md)

## Vault

- **Path:** `/Users/tobiasschmidt/Obsidian/SecondBrain/`
- **Structure:** PARA (00 Kontext, 01 Inbox, 02 Projekte, 03 Bereiche, 04 Ressourcen, 05 Daily Notes, 06 Archiv, 07 Anhaenge)
- **Log:** `/Users/tobiasschmidt/Obsidian/SecondBrain/log.md`
- **Report directory:** `/Users/tobiasschmidt/Obsidian/SecondBrain/03 Bereiche/Vault-Gesundheit/`

## Invocation

| Input | Behavior |
|-------|----------|
| `/decay` | Full check with defaults (older-than:6m, folder:"04 Ressourcen") |
| `/decay older-than:12m` | Adjust threshold (m=months, y=years) |
| `/decay folder:"03 Bereiche"` | Switch scope folder |
| `/decay older-than:3m folder:"02 Projekte"` | Combine arguments |
| `/decay note:"<note>"` | Check a single note regardless of age |
| `/decay scan-only` | Scan mode: write only the report, no frontmatter writes, autonomous (no confirmation dialog). Combinable with `older-than:` and `folder:`. |

If arguments are unclear, use AskUserQuestion rather than guess.
Exception: in scan mode no questions are asked — missing arguments fall back to defaults.

## Modes

| Mode | Trigger | Effect | Routine-safe |
|------|---------|--------|--------------|
| Full mode (default) | manual | scan, validate, write frontmatter with confirmation, report | no (interactive) |
| Scan mode (`scan-only`) | manual or routine | scan, validate, write only scan report, no frontmatter | yes (autonomous) |

**Role split:** Scan mode is the sensor — it runs autonomously in routines (scheduled agents), produces a scan report and writes nothing to source notes. Full mode is the action — it is triggered manually after the user has reviewed a scan report and writes the classification into frontmatter with confirmation.

## Workflow (8 phases)

1. **Scope** — Parse `older-than`, `folder` and `scan-only` flag. Defaults: 6 months, `04 Ressourcen`. Hard-exclude `05 Daily Notes/`, `06 Archiv/`, `07 Anhaenge/`, `01 Inbox/`, `00 Kontext/`. With `scan-only` no AskUserQuestion is fired.
2. **Find candidates** — Glob `<folder>/**/*.md`. Age from `aktualisiert` -> `date` -> Bash `stat` fallback. Skip notes with `decay_checked_at` younger than 30 days unless `note:"..."` is set.
3. **Extract verifiable claims** — Versions, tool names, standards, URLs, availability statements, concrete numbers with source. Skip personal reflections, conceptual arguments, style rules. If no verifiable claims: mark `gueltig` with note, no web call.
4. **Web validation** — Max 3 web calls per note. WebSearch first, WebFetch only for concrete doc URLs. Bundle across notes (one search for "Claude Sonnet 4.5" serves all referencing notes). Classify per note: `gueltig` / `ueberpruefen` / `veraltet`.
5. **Preview + confirmation** (full mode only) — Show grouped table, ask whether to apply all, go one by one, or abort. Skipped in scan mode.
6. **Write frontmatter** (full mode only) — Edit existing frontmatter, add `freshness`, `decay_checked_at`, `decay_notes` (only for `ueberpruefen` / `veraltet`). Never touch the note body. Skipped in scan mode — source notes stay untouched.
7. **Decay report** — Markdown report in `03 Bereiche/Vault-Gesundheit/`. Filename depends on mode:
   - Full mode: `YYYY-MM-DD Decay Report.md`
   - Scan mode: `YYYY-MM-DD Decay Scan.md`
   Same structure either way (summary, classification lists, mitigation suggestions).
8. **Log entry** — Append-only entry in `log.md`. Prefix `decay` in full mode, `decay-scan` in scan mode. Scan entries note `Frontmatter changes: none (scan mode)`.

## Frontmatter fields written

```yaml
freshness: gueltig | ueberpruefen | veraltet
decay_checked_at: 2026-06-13
decay_notes: short reason if ueberpruefen / veraltet, empty otherwise
```

## Rules

1. **ALWAYS preview before writing in full mode** — frontmatter is never changed without confirmation
2. **Scan mode never writes to source notes** — only the scan report and the log entry
3. **NEVER change content** — decay marks, it does not fix
4. **NEVER delete or archive** — mitigation is a suggestion, not an action
5. **Web calls sparingly** — max 3 per note, bundle across notes
6. **Exclude Daily Notes, archive, inbox, context, attachments** (hard excludes in phase 1)
7. **Reason required** in `decay_notes` for `ueberpruefen` and `veraltet` (full mode only)
8. **Log is append-only** — never modify existing entries; prefix `decay` in full mode, `decay-scan` in scan mode
9. **Language: German default** for skill output and report
