---
name: lint
description: >
  Weekly health check for the SecondBrain Obsidian Vault. Finds orphaned notes,
  missing wikilinks, full inbox, stale projects, and project compliance drift
  (whitelist violations, broken wikilinks, naming conventions) and suggests fixes.
  Use when the user says "lint", "vault check", "check the vault", "health check",
  "orphans", "project-compliance", "project-check".
version: 1.3.2
user-invocable: true
allowed-tools:
  - Read
  - Edit
  - Write
  - Bash
  - Glob
  - Grep
  - AskUserQuestion
---

# Lint Skill — SecondBrain Health Check

Check the SecondBrain Vault for health and suggest improvements.
Complementary to the `/ingest` skill: while ingest processes individual notes,
this skill checks the entire vault systematically.

German version: [SKILL.md](SKILL.md)

## Vault

- **Path:** `~/Obsidian/SecondBrain/`
- **Structure:** PARA (00 Kontext, 01 Inbox, 02 Projekte, 03 Bereiche, 04 Ressourcen, 05 Daily Notes, 06 Archiv, 07 Anhaenge)
- **Log:** `~/Obsidian/SecondBrain/log.md`

## Invocation

| Input | Behavior |
|-------|----------|
| `/lint` | Full vault check (all 6 phases) |
| `/lint orphans` | Only find orphans (phase 1) |
| `/lint inbox` | Only check inbox (part of phase 3) |
| `/lint projekte` | Only project-compliance section (phase 4) |
| `/lint index` | Only regenerate vault index (phase 6) |

## Workflow (6 phases)

1. **Find orphans** — Notes without incoming `[[Wikilinks]]` (with exceptions for Daily Notes, CLAUDE.md, context files)
2. **Suggest missing links** — Theme matching between notes, individual confirmation instead of auto-apply
3. **Vault hygiene** — Inbox count, project status, frontmatter, synthesis pages
4. **Project compliance** (since v1.2.0):
   - Whitelist project root (only PMO HUB, Governance, Financials allowed)
   - `README.md` in project root forbidden
   - Required files exist (PMO HUB, Projekt-Governance.md)
   - Naming convention `* - PMO HUB.md`
   - Markdown in `*/Research/assets/` (should be one level higher)
   - Broken wikilinks in PMO HUB
   - Decisions frontmatter consistency
   - Pre-Backlog items older than 30 days
5. **Report + log** — Markdown report in `01 Inbox/`, append-only log entry in `log.md`
6. **Regenerate vault index** (since v1.3.0) — Pre-compiles `Index.md` at the vault root: active projects, areas, synthesis pages, context files, last 5 daily notes, last 3 lint reports, vault stats. Claude reads this page on session start instead of full-text searching the vault (Karpathy LLM Wiki Pattern: pre-processing over real-time search). File is overwritten on every run — no Dataview, only static wikilinks. See German [SKILL.md](SKILL.md) phase 6 for the full template and generation rules.

## Rules

1. **ALWAYS ask** before changing notes
2. **NEVER delete** — only augment existing content
3. **Ignore 07 Anhaenge/ completely** — no images/PDFs searched
4. **Daily Notes are not orphans** — they stand alone
5. **Report is factual** — no judgments, only facts and suggestions
6. **Log is append-only** — never change existing entries
7. **Language: German default** (skill output and report)
