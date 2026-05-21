# 00 — Prerequisites: what you should know first

> Short version: if you've never used Obsidian, Markdown or an AI CLI, this
> chapter is for you. If you know all that, skip to
> [Chapter 01](01-philosophy.md).

## Is this the right repo for me?

Three questions, answer honestly:

1. **Do you use at least two AIs in daily work?** (e.g. Claude and ChatGPT,
   or Claude and Gemini, or Claude and Perplexity)
   - Yes → continue
   - No → probably overkill. A simple Markdown notes app might be enough.

2. **Are you comfortable with the terminal?** (`cd`, `mkdir`, running `bash`
   scripts)
   - Yes → continue
   - No → possible, but learning curve. Plan time.

3. **Are you willing to write a note (almost) every day?**
   - Yes → the system lives on daily notes
   - No → the system will atrophy. Maybe establish a notes routine first,
     without the AI setup.

If you have 2 or 3 yeses: this setup fits. If you have 2 nos: save yourself
the time.

## What is Obsidian?

[Obsidian](https://obsidian.md) is a **free Markdown editor**. You open a
folder of `.md` files, and Obsidian treats it like a database: with search,
linking, graph visualization, plugins.

Three things that make Obsidian special:

1. **Everything local.** Your notes are plain Markdown files on your disk.
   You can read them with any text editor. No vendor lock-in.
2. **Wikilinks.** With `[[Other Note]]` you link notes bidirectionally — the
   target knows who links to it.
3. **Plugin system.** Thousands of extensions. Most important plugin for
   this setup: **Dataview** (turns your notes into a database).

In Obsidian, a notes folder is called a **vault**. You can have multiple
vaults. In this setup we use exactly one: `~/Obsidian/SecondBrain/`.

## What is Markdown?

Markdown is text with **lightweight formatting characters**:

```markdown
# A heading
## A subheading

Normal paragraph. **Bold word.** *Italic word.*

- A list item
- Another item

[Link text](https://example.com)
```

If you've ever commented on GitHub, you've written Markdown. If not: 5
minutes with a [Markdown tutorial](https://www.markdownguide.org/basic-syntax/)
is enough.

## What is an AI CLI?

CLI = Command Line Interface. Programs you run in the **terminal**, not in a
GUI app with a mouse. Examples:

- **Claude Code** (`claude`) — Anthropic's official CLI for Claude
- **Gemini CLI** (`gemini`) — Google's CLI for Gemini
- **Codex CLI** (`codex`) — OpenAI's CLI for their code models

Unlike web apps and desktop apps, CLIs can:

- Access your files (with permission)
- Run commands
- Call each other (subagents)
- Have skills/slash commands

For this setup, **at least one CLI AI** makes sense. If you only use the web
apps, you can maintain the vault manually, but you lose automation (skills,
MCP, AI-agnostic workflows).

## What is MCP?

MCP = **Model Context Protocol.** An Anthropic standard from 2024.

Simplified: an MCP server is a small program that gives an AI **access to
something external**. Examples:

- **Filesystem MCP** — gives the AI read/write access to a folder
- **Linear MCP** — gives the AI access to your Linear project board
- **Perplexity MCP** — gives the AI an "ask Perplexity" function

In this setup, central for **Claude Desktop**: for Claude Desktop to read
and write your vault, you need a Filesystem MCP server pointing at your
vault path. Details in [Chapter 04](04-multi-ai-setup.md).

## What is `@-import`?

In the config files of Claude Code and Gemini CLI, `@/path/to/file.md` means
the target file is **embedded**.

Example `~/.gemini/GEMINI.md`:

```markdown
## SecondBrain rules

@~/Obsidian/SecondBrain/CLAUDE.md
```

When Gemini starts, it reads its global config and follows the `@` reference —
the entire content of the target file is loaded as context. This lets a
change in the vault `CLAUDE.md` affect all AIs immediately, without you having
to touch each AI config individually. That's the **hub-and-spoke trick** (see
Chapter 02).

## What is Dataview?

Obsidian plugin. **Required** for this setup.

With Dataview you can write SQL-like queries in Markdown:

````markdown
```dataview
LIST file.link
FROM "05 Daily Notes"
WHERE contains(file.tags, "#my-project")
SORT file.name DESC
LIMIT 10
```
````

Obsidian renders this as a **live list** — sorted, filtered, automatically up
to date. In this setup, project hubs use Dataview to aggregate daily-note
entries, decisions and action items automatically.

**Installation:** Obsidian → Settings → Community Plugins → Browse → search
"Dataview" → Install → Enable.

## What is a wikilink?

Instead of classic Markdown links `[text](path)`, Obsidian uses
`[[wikilinks]]`:

```markdown
See [[My-Project - PMO HUB]] for details.
```

Three advantages:

1. **Bidirectional** — Obsidian shows in the target note who links to it
2. **Folder-agnostic** — the wikilink finds the file regardless of subfolder
3. **Graph-capable** — Obsidian's graph view shows the vault as a connected web

Wikilinks are the **most important mechanism** in this setup. Without them,
no connection, no compound effect, no Karpathy pattern.

## What is frontmatter?

The YAML block at the top of a note, between `---` lines:

```yaml
---
tags: [topic-1, topic-2]
status: aktiv
date: 2026-05-21
source: claude
chat_url: https://claude.ai/chat/...
---

# Actual note content starts here
```

These **metadata** are critical. Dataview queries filter on them. Skills use
them. Multi-AI tracking (which AI wrote this?) is based on `source:`. If you
skip frontmatter, the automation doesn't work.

## Am I ready now?

If you understood the terms above: yes.

If not: start with Obsidian. Install it. Create a test vault. Write a note.
Set a wikilink. Enable Dataview. If that works, you're ready for
[Chapter 01](01-philosophy.md).

## Glossary

All terms as a compact list: [GLOSSARY.md](../GLOSSARY.md)

## Next chapter

→ [01 — Philosophy: why this setup exists](01-philosophy.md)
