# 02 — Architektur: Hub-and-Spoke und das Drei-Ebenen-Modell

> Kurzfassung: Eine **Vault-CLAUDE.md** ist die Single Source of Truth. Alle KI-Configs
> verweisen darauf via `@-Import` oder Filesystem-MCP. KI-agnostische Methodik liegt im
> Vault, KI-spezifische Specials in den jeweiligen globalen Configs.

## Hub-and-Spoke

Das Bild ist einfach: eine Nabe in der Mitte (die `Vault-CLAUDE.md`), Speichen nach
aussen zu den KIs.

```
                ~/.claude/CLAUDE.md          (Claude Code)
                       │
                       │ @-Import
                       │
~/.gemini/GEMINI.md ───┤
        │              │
        │ @-Import     ▼
        │      ┌──────────────────────────────────────┐
        │      │ ~/Obsidian/SecondBrain/CLAUDE.md     │
        │      │ Single Source of Truth (KI-agnostisch)│
        │      └──────────────────────────────────────┘
        │              ▲
        │              │ @-Import / Filesystem-MCP
        │              │
~/.codex/AGENTS.md ────┤
                       │
                Claude Desktop (Filesystem-MCP)
```

Siehe Diagramm: [`diagramme/02-hub-and-spoke.png`](../diagramme/02-hub-and-spoke.png)

### Warum diese Architektur?

**Aenderung an genau einer Stelle.** Wenn du das Daily-Note-Pattern aenderst, neue
Frontmatter-Felder einfuehrst, oder einen neuen Ordner-Bereich definierst —
aenderst du `~/Obsidian/SecondBrain/CLAUDE.md`. Alle KIs ziehen die Aenderung beim
naechsten Session-Start. Du brauchst dich nicht durch drei oder vier Config-Dateien
durchzuhangeln.

**KI-spezifische Specials bleiben moeglich.** Manche KIs koennen Skills/Slash-Commands
(Claude Code), andere nicht (Gemini CLI, Codex). Manche haben MCP-Server (Claude
Code, Claude Desktop), andere nicht. Diese Unterschiede gehoeren in die jeweilige
globale Config:

- `~/.claude/CLAUDE.md` enthaelt den Skill-Lifecycle-Workflow (Claude-Code-spezifisch).
- `~/.gemini/GEMINI.md` enthaelt die Gemini-Chat-Archivierung (Gemini-spezifisch).
- `~/.codex/AGENTS.md` enthaelt Codex-Chat-Archivierung (Codex-spezifisch).

Aber: **kein KI-agnostisches Wissen** dupliziert sich in den globalen Configs. Wenn
"Daily-Note schreiben" eine Regel ist, gehoert sie in die Vault-CLAUDE.md, nicht in
drei Configs.

### Die `@-Import`-Syntax

Claude Code und Gemini CLI unterstuetzen `@-Import`: in einer Markdown-Datei wird
`@/pfad/zur/datei.md` als Einbettung interpretiert und der Inhalt der Ziel-Datei
wird beim Laden mit eingebunden. Beispiel aus `~/.gemini/GEMINI.md`:

```markdown
## Zweites Gehirn (SecondBrain)

Die massgeblichen Regeln stehen in der Vault-eigenen Regel-Datei:

@~/Obsidian/SecondBrain/CLAUDE.md
```

Codex CLI unterstuetzt `@-Import` ebenfalls (Versions-abhaengig). Falls eine KI das
nicht unterstuetzt, schreibst du als Fallback eine explizite **Lese-Anweisung**:
"Lies beim Session-Start die Datei `~/Obsidian/SecondBrain/CLAUDE.md`."

### Warum heisst die Datei `CLAUDE.md`?

Historisch — sie ist beim Setup mit Claude Code entstanden. Der **Inhalt** ist
KI-agnostisch. Du koenntest die Datei umbenennen zu `VAULT.md` oder `RULES.md`, das
funktioniert solange du in allen globalen Configs den Pfad aktualisierst. Wir
behalten den Namen, weil er sich als Konvention durchgesetzt hat und Claude Code
ihn als Default sucht.

## Das Drei-Ebenen-Modell

Wenn du das Setup ernsthaft mit Skills nutzt, hast du drei Persistenz-Ebenen
fuer dein Wissen — und jede hat einen klaren Zweck:

| Ebene             | Zweck                                         | Ort                                    |
| ----------------- | --------------------------------------------- | -------------------------------------- |
| Implementation    | SKILL.md, Skripte, Templates                  | `~/.claude/skills/<skill-name>/`       |
| Code & Versionierung | README.md, Changelog, Versions-Tags        | GitHub-Repo (z.B. `vibercoder79/claudecodeskills`) |
| Wissen & Kontext  | Qualitative Doku, Verknuepfungen, Erkenntnisse | SecondBrain: `03 Bereiche/Skills/`     |

Die wichtige Regel: **das SecondBrain ist die Wissens-SSoT, nicht der Skill-Ordner.**
Wenn ein Skill auf eine Farbpalette zugreifen muss, liest er sie aus
`~/Obsidian/SecondBrain/00 Kontext/Branding.md` — nicht aus einer Kopie in seinem
eigenen `references/`. Aendert sich die Palette, ist sie ueberall aktuell.

Siehe Diagramm: [`diagramme/03-drei-ebenen-modell.png`](../diagramme/03-drei-ebenen-modell.png)

## Was in den Vault gehoert, was nicht

Eine wiederkehrende Frage: liegt Information **A** im Vault oder woanders?

Faustregel:

| Frage | Vault | Anderswo |
| ----- | ----- | -------- |
| Brauche ich das in 6 Monaten noch? | Ja → Vault | Nein → temporaer (Chat) |
| Sollen mehrere KIs es lesen? | Ja → Vault | Nein → KI-spezifische Memory |
| Ist es Code (ausfuehrbar)? | Nein | Ja → Git-Repo |
| Ist es eine Entscheidung mit Begruendung? | Ja → `Decisions/` | — |
| Ist es Code-Snippet ohne Repo? | Ja → `04 Ressourcen/` | — |
| Ist es persoenliche Identitaet (Passwort)? | Nein, niemals | Keychain / Passwort-Manager |

Vault ist Markdown-Wissen. Code lebt in Git-Repos. Geheimnisse leben nirgendwo
sichtbar.

## KI-agnostische Methodik

Innerhalb des Vaults gibt es einen besonderen Ort: `00 Kontext/Workflows/`.
Dort liegen **methodische Anleitungen**, die mehrere KIs ausfuehren sollen — z.B.
`Projekt-Anlegen.md` (9-Fragen-Onboarding fuer neue Projekte). Diese Datei ist die
Single Source of Truth fuer den Workflow.

- Claude Code hat einen Skill `/projekt-init`, der die Methodik **automatisch**
  ausfuehrt (mit MCP-Discovery fuer Backlog-Tools etc.)
- Gemini CLI liest dieselbe Datei und fuehrt den Workflow **manuell** durch
  (stellt dieselben Fragen, legt dieselben Ordner an, nutzt dieselben Templates).
- Codex CLI macht das ebenso manuell.

Die Methodik existiert genau einmal. Die Ausfuehrung haengt von der KI-Faehigkeit
ab. Aenderst du eine Frage im Onboarding, aendert sich das Verhalten in allen KIs.

## Wo liegt was?

Eine Schnell-Uebersicht:

```
~/                                       (Home)
├── .claude/
│   ├── CLAUDE.md                       (Globale Claude-Config — verweist auf Vault)
│   └── skills/                          (Claude-spezifische Skills)
├── .gemini/
│   └── GEMINI.md                       (Globale Gemini-Config — @-Import Vault)
├── .codex/
│   └── AGENTS.md                       (Globale Codex-Config — verweist auf Vault)
└── Obsidian/
    └── SecondBrain/
        ├── CLAUDE.md                   (★ Single Source of Truth)
        ├── AGENTS.md                   (Codex-Spiegel mit "Codex"-Sprache)
        ├── Index.md                    (★ Vault-Cover, von /lint generiert)
        ├── log.md                      (★ Verarbeitungs-Chronologie)
        ├── 00 Kontext/                 (Profile, Templates, Workflows)
        │   ├── Projekt-Struktur.md
        │   ├── User-Story-Template.md
        │   └── Workflows/
        │       └── Projekt-Anlegen.md
        ├── 01 Inbox/                   (Brain Dumps)
        ├── 02 Projekte/                (Aktive Projekte mit Enddatum)
        ├── 03 Bereiche/                (Laufende Verantwortungen)
        ├── 04 Ressourcen/              (Referenzmaterial, Research, KI-Archive)
        ├── 05 Daily Notes/             (Eines pro Tag)
        ├── 06 Archiv/                  (Abgeschlossen)
        └── 07 Anhaenge/                (Bilder, PDFs)
```

Sternchen ★ markiert die Dateien, die das ganze System zusammenhalten.

## Naechstes Kapitel

→ [03 — Vault-Struktur: PARA in Praxis](03-vault-struktur.md)
