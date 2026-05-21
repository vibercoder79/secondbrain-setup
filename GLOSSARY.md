# Glossary

Terms used in this repo, sorted alphabetically. If you're unsure, look here.

---

## ADR (Architecture Decision Record)

A Markdown file per decision. Instead of burying decisions in chat logs or
meeting minutes, each important decision gets a numbered file
(`ADR-03 Database-Choice.md`) with context, options and reasoning. Concept from
Michael Nygard (2011) — common in software teams.

## CLI (Command Line Interface)

Programs you run in a terminal, not in a GUI app. Examples: `git`, `npm`,
`claude` (Claude Code), `gemini` (Gemini CLI), `codex` (Codex CLI). If you've
never used a terminal, this setup will have a learning curve.

## Compound effect

Term from [Karpathy's LLM-Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).
Idea: knowledge **gets better over time** because each new source flows into
existing notes (wikilinks added, synthesis pages enriched). Instead of 1000
disconnected notes, you get a connected wiki that's more than the sum of its
parts.

## Dataview

Obsidian plugin (free, community). Turns your vault into a database. With
Dataview you can write queries:

````markdown
```dataview
LIST file.link
FROM "05 Daily Notes"
WHERE contains(file.tags, "#my-project")
```
````

The result is a live list in Obsidian — sorted, filtered, automatically up to
date. In this setup, project hubs use Dataview to aggregate daily-note sections
automatically. **Required** if you use this setup.

## Frontmatter

The YAML block at the top of a Markdown file between `---` lines:

```yaml
---
tags: [topic-1, topic-2]
status: aktiv
source: claude
---
```

These are **metadata** about the file. Obsidian and Dataview use them for
filtering, sorting, aggregating. Without frontmatter, Dataview queries and
project hubs don't work.

## Hook

An automatic trigger that fires on certain events. In Claude Code e.g. "When
a file is changed, run X". This setup deliberately does **not** use hooks —
we use manual skill invocations (`/ingest`, `/lint`) so the user stays in
control and trivial edits don't trigger LLM analysis.

## Hub-and-spoke

Architecture pattern. A hub in the middle (`Vault-CLAUDE.md`), spokes outward
to multiple clients (`~/.claude/CLAUDE.md`, `~/.gemini/GEMINI.md`,
`~/.codex/AGENTS.md`). A change in the hub reaches all spokes. See
[Chapter 02](handbook/02-architecture.md).

## Karpathy LLM-Wiki

Concept from a [gist by Andrej Karpathy](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).
A structured Markdown wiki that an LLM **maintains incrementally** (Ingest,
Query, Lint). Source of inspiration for the skills in this repo.

## MCP (Model Context Protocol)

Anthropic standard (2024) that lets AIs access external data and tools. An
**MCP server** is a small program that gives an AI e.g. read access to your
filesystem (Filesystem MCP), or to Linear, Notion, your mail inbox etc. In
this setup, central for Claude Desktop (uses Filesystem MCP for vault access).

## Obsidian

Markdown editor with wikilink support and a plugin system. Free, local, no
cloud lock-in. [obsidian.md](https://obsidian.md). **Required for this setup.**
You can in theory use other editors (Logseq, Foam, plain Markdown), but the
conventions here are designed for Obsidian.

## PARA

Method by Tiago Forte from the book "Building a Second Brain" (2022). Four
top-level folders sorted by **action pressure**:

- **P**rojects — goal + end date
- **A**reas — ongoing responsibilities without end date
- **R**esources — reference material
- **A**rchives — completed

This setup extends PARA with `00 Kontext` (profile), `01 Inbox` (entry point),
`05 Daily Notes` and `07 Anhaenge` (attachments).

## PMO HUB

PMO = Project Management Office. The **HUB** is the landing page of a project
at `02 Projekte/<Project>/<Project> - PMO HUB.md`. Contains goal, stakeholders,
stack, Dataview views of decisions/action items/daily notes. Whoever wants to
understand the project reads the HUB.

## Skill (Claude Code skill)

An **extension** of Claude Code. Lives under `~/.claude/skills/<name>/`,
consists at minimum of a `SKILL.md`. Invoked via slash command
(`/projekt-init`) or via trigger phrases ("create a new project"). In this
repo: `projekt-init`, `lint`, `ingest`.

## Slash command

A command starting with `/`: `/projekt-init`, `/lint`. In Claude Code this is
the way to explicitly invoke a skill — alternatively via trigger phrases that
Claude recognizes from the skill's frontmatter.

## SSoT (Single Source of Truth)

The one place where a piece of information lives. In this setup:
`~/Obsidian/SecondBrain/CLAUDE.md` is the SSoT for AI-agnostic rules. If the
same info lives in multiple places, at least one is stale — so avoid.

## Synthesis page

In `04 Ressourcen/<Topic>/<Topic>.md` lives a **living overview page** per
topic folder. Enriched by `/ingest` with every new note. Karpathy's "living
wiki" in practice.

## Vault

Obsidian term for a **note folder**. A vault is simply a folder of `.md` files
with a hidden `.obsidian/` subfolder for configuration. You can have multiple
vaults (e.g. a private one and a work-shared one). In this setup: one vault
under `~/Obsidian/SecondBrain/`.

## Wikilink

A link in Obsidian using double square brackets: `[[target-note]]` or with
alias `[[target-note|how it's displayed]]`. Advantages over Markdown links:

- **Bidirectional** — target sees who links to it
- **Folder-agnostic** — finds the file regardless of subfolder
- **Graph-capable** — Obsidian's graph view shows the vault as a connected web

The most important mechanism in this setup.

## YAML

Data format for frontmatter. Looks like:

```yaml
status: active
tags:
  - topic-1
  - topic-2
```

Indentation **with spaces, never tabs**. Otherwise it breaks.

---

[← Back to README](README.en.md) · [Deutsches Glossar](GLOSSAR.md)
