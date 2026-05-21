---
name: projekt-init
description: |
  Orchestrates the creation of a new project in the SecondBrain Vault. Guides through
  Onboarding (10 questions including language choice DE/EN), creates folder structure
  and templates, integrates the backlog tool (Linear/M365 via MCP discovery, GitHub
  Issues via gh CLI, or none).
  Use when the user says "new project", "create a project", "set up a project",
  "create a project for..." or "/projekt-init".
version: 1.1.0
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

# Projekt-Init Skill — Create SecondBrain Project

Create a new project in the SecondBrain Vault. Onboarding dialog → Validation →
Backlog discovery → Create folders → Fill templates → Verification.

German version: [SKILL.md](SKILL.md)

## Vault

- **Path:** `~/Obsidian/SecondBrain/`
- **Project root:** `02 Projekte/<ProjectName>/`
- **Templates DE:** `00 Kontext/Projekt-Struktur.md`
- **Templates EN:** `00 Kontext/Projekt-Struktur.en.md`
  (Single source of truth — ALWAYS read from there. Language choice determines which file.)
- **User Story Template:** `00 Kontext/User-Story-Template.md` (DE) / `User-Story-Template.en.md` (EN)

## Invocation

| Input | Behavior |
|-------|----------|
| `/projekt-init` | Full workflow (all 7 phases) |
| "new project" / "create a project" | Full workflow |
| `/projekt-init Standard` | Skip onboarding, use defaults from `references/defaults-pro-typ.md` |

## Workflow

### Phase 0: Onboarding Dialog

Issue the 10-question block from `references/onboarding-fragen.md` as 1 message
(question 0 is language choice, then 1-9). Never ask individually — all at once.

If user says "Standard" or "no questions" → skip phase, use defaults from
`references/defaults-pro-typ.md`, language = German.

**Language choice (question 0) determines complete generation:**
- Answer `de` (default) → Templates from `[[Projekt-Struktur]]`, frontmatter `language: de`, all content German
- Answer `en` → Templates from `[[Projekt-Struktur.en]]`, frontmatter `language: en`, all content English

File and folder names stay the SAME in both languages (whitelist unchanged).
Only file content is translated. Details: `references/onboarding-fragen.md` section "Sprach-Logik".

### Phase 1: Validation

Check if project folder already exists. On conflict: suggest alternative name.
Derive tags and `related: [[...]]` from context.

### Phase 2: Backlog Discovery (Hybrid Strategy)

Per `backlog_tool` answer from Phase 0:

| Tool | Workflow | Reference |
|------|----------|-----------|
| `linear` | MCP discovery first, auto-create fallback | `references/backlog-discovery-linear.md` |
| `teams-kanban` (M365) | MCP discovery first (tool names at runtime), fallback user input | `references/backlog-discovery-m365.md` |
| `github-issues` | `gh` CLI (see `references/backlog-discovery-linear.md` section gh) | — |
| `notion` | Currently user input (no MCP configured) | — |
| `none` | Hub gets "Pre-Backlog Action Items" section, no discovery | — |

**Graceful degradation:** When MCP tool doesn't respond → user input with link.

### Phase 3-6: Create folders → Fill templates → Opt-ins → Verify

Create folder structure per whitelist, fill PMO HUB and Governance with real values from
Phase 0 (no placeholders), apply opt-ins (Risks/Financials), verify whitelist + wikilinks +
dataview syntax + frontmatter.

### Phase 7: Summary

Show what was created and next steps (in language of project).

## Rules

1. **ALWAYS read templates from Projekt-Struktur** — never copy into the skill
2. **Onboarding mandatory** — exception: operator says "Standard" explicitly
3. **Insert real values** — no placeholders like "..."
4. **MCP graceful** — on MCP error always user-input fallback
5. **Confirm before auto-create** — never create Linear/M365 project without explicit "yes"
6. **Language: German (default) or English per project language**

## Advanced features

- **Onboarding question catalog:** [references/onboarding-fragen.md](references/onboarding-fragen.md)
- **Default table per project type:** [references/defaults-pro-typ.md](references/defaults-pro-typ.md)
- **Linear discovery workflow:** [references/backlog-discovery-linear.md](references/backlog-discovery-linear.md)
- **M365 discovery workflow:** [references/backlog-discovery-m365.md](references/backlog-discovery-m365.md)
- **Verification checks:** [references/verifikation-checks.md](references/verifikation-checks.md)
