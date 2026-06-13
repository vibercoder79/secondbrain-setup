---
name: decay
description: >
  Checks notes in the SecondBrain Obsidian Vault for staleness. Finds old notes,
  validates verifiable claims against current reality (web search), marks freshness
  status in frontmatter. Writes a decay report to the vault health directory.
  Use when the user says "decay", "decay check", "is this still current",
  "check old notes", "freshness check".
version: 1.0.0
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

If arguments are unclear, use AskUserQuestion rather than guess.

## Workflow (8 phases)

1. **Scope** — Parse `older-than` and `folder` args. Defaults: 6 months, `04 Ressourcen`. Hard-exclude `05 Daily Notes/`, `06 Archiv/`, `07 Anhaenge/`, `01 Inbox/`, `00 Kontext/`.
2. **Find candidates** — Glob `<folder>/**/*.md`. Age from `aktualisiert` -> `date` -> Bash `stat` fallback. Skip notes with `decay_checked_at` younger than 30 days unless `note:"..."` is set.
3. **Extract verifiable claims** — Versions, tool names, standards, URLs, availability statements, concrete numbers with source. Skip personal reflections, conceptual arguments, style rules. If no verifiable claims: mark `gueltig` with note, no web call.
4. **Web validation** — Max 3 web calls per note. WebSearch first, WebFetch only for concrete doc URLs. Bundle across notes (one search for "Claude Sonnet 4.5" serves all referencing notes). Classify per note: `gueltig` / `ueberpruefen` / `veraltet`.
5. **Preview + confirmation** — Show grouped table, ask whether to apply all, go one by one, or abort.
6. **Write frontmatter** — Edit existing frontmatter, add `freshness`, `decay_checked_at`, `decay_notes` (only for `ueberpruefen` / `veraltet`). Never touch the note body.
7. **Decay report** — Markdown report in `03 Bereiche/Vault-Gesundheit/YYYY-MM-DD Decay Report.md` with summary, classification lists, mitigation suggestion per stale note.
8. **Log entry** — Append-only entry in `log.md`.

## Frontmatter fields written

```yaml
freshness: gueltig | ueberpruefen | veraltet
decay_checked_at: 2026-06-13
decay_notes: short reason if ueberpruefen / veraltet, empty otherwise
```

## Rules

1. **ALWAYS preview before writing** — frontmatter is never changed without confirmation
2. **NEVER change content** — decay marks, it does not fix
3. **NEVER delete or archive** — mitigation is a suggestion, not an action
4. **Web calls sparingly** — max 3 per note, bundle across notes
5. **Exclude Daily Notes, archive, inbox, context, attachments** (hard excludes in phase 1)
6. **Reason required** in `decay_notes` for `ueberpruefen` and `veraltet`
7. **Log is append-only** — never modify existing entries
8. **Language: German default** for skill output and report
