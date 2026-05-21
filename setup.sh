#!/usr/bin/env bash
#
# SecondBrain Setup — interaktiver Setup-Helfer
#
# Was er tut:
#   1. Fragt nach deinem Vault-Pfad
#   2. Legt PARA-Ordner-Struktur an (idempotent)
#   3. Kopiert Vault-Templates (CLAUDE.md, AGENTS.md, 00 Kontext)
#   4. Optional: legt globale KI-Configs an (Claude Code, Gemini, Codex)
#   5. Optional: installiert die drei Skills (projekt-init, lint, ingest)
#
# Was er NICHT tut:
#   - Etwas ueberschreiben ohne Nachfrage
#   - API-Keys konfigurieren
#   - Claude Desktop einrichten (manuell — siehe templates/claude-desktop/README.md)
#   - Obsidian installieren oder Plugins aktivieren
#
# Aufruf:
#   bash setup.sh
#
# Sicherheits-Hinweis: das Script schreibt nur in das Vault-Verzeichnis und
# `~/.claude/`, `~/.gemini/`, `~/.codex/`. Es liest keine Secrets, schreibt keine
# Secrets, sendet nichts ins Netz.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
DEFAULT_VAULT="$HOME/Obsidian/SecondBrain"

# Farben (nur wenn Terminal)
if [[ -t 1 ]]; then
  BOLD='\033[1m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  RESET='\033[0m'
else
  BOLD=''
  GREEN=''
  YELLOW=''
  BLUE=''
  RESET=''
fi

info()    { printf "${BLUE}→${RESET} %s\n" "$1"; }
ok()      { printf "${GREEN}✓${RESET} %s\n" "$1"; }
warn()    { printf "${YELLOW}⚠${RESET} %s\n" "$1"; }
section() { printf "\n${BOLD}== %s ==${RESET}\n" "$1"; }

ask_yes_no() {
  # ask_yes_no "Frage?" default(y|n)
  local prompt="$1"
  local default="${2:-n}"
  local hint
  if [[ "$default" == "y" ]]; then
    hint="[Y/n]"
  else
    hint="[y/N]"
  fi
  printf "%s %s " "$prompt" "$hint"
  read -r answer
  answer="${answer:-$default}"
  [[ "$answer" =~ ^[Yy]$ ]]
}

# === Schritt 1: Vault-Pfad ===

section "1. Vault-Pfad"

printf "Wo soll dein SecondBrain-Vault liegen?\n"
printf "  Default: %s\n" "$DEFAULT_VAULT"
printf "  Eigener Pfad eingeben oder ENTER fuer Default: "
read -r VAULT_INPUT
VAULT_PATH="${VAULT_INPUT:-$DEFAULT_VAULT}"
VAULT_PATH="${VAULT_PATH/#\~/$HOME}"  # Tilde-Expansion

info "Vault-Pfad: $VAULT_PATH"

if [[ -d "$VAULT_PATH" ]]; then
  warn "Verzeichnis existiert bereits."
  if ! ask_yes_no "Im bestehenden Verzeichnis weiterarbeiten?" "y"; then
    info "Abbruch. Du kannst das Script jederzeit erneut starten."
    exit 0
  fi
fi

mkdir -p "$VAULT_PATH"
ok "Vault-Verzeichnis bereit: $VAULT_PATH"

# === Schritt 2: PARA-Ordner ===

section "2. PARA-Ordnerstruktur"

PARA_DIRS=(
  "00 Kontext/Workflows"
  "01 Inbox"
  "02 Projekte"
  "03 Bereiche/Skills"
  "04 Ressourcen/Research"
  "05 Daily Notes"
  "06 Archiv"
  "07 Anhaenge"
)

for dir in "${PARA_DIRS[@]}"; do
  mkdir -p "$VAULT_PATH/$dir"
done
ok "PARA-Ordner angelegt (8 Stueck)"

# === Schritt 3: Vault-Templates ===

section "3. Vault-Templates"

copy_if_missing() {
  local src="$1"
  local dst="$2"
  if [[ -e "$dst" ]]; then
    warn "Existiert bereits — nicht ueberschrieben: $(basename "$dst")"
  else
    cp "$src" "$dst"
    ok "Kopiert: $(basename "$dst")"
  fi
}

# Pflicht: Vault-CLAUDE.md (Hub-Datei, Single Source of Truth)
copy_if_missing "$REPO_DIR/templates/vault/CLAUDE.md" "$VAULT_PATH/CLAUDE.md"

# 00 Kontext: Templates + Workflows
mkdir -p "$VAULT_PATH/00 Kontext/Workflows"
for f in "Projekt-Struktur.md" "Projekt-Struktur.en.md" "User-Story-Template.md" "User-Story-Template.en.md"; do
  if [[ -f "$REPO_DIR/templates/vault/00 Kontext/$f" ]]; then
    copy_if_missing "$REPO_DIR/templates/vault/00 Kontext/$f" "$VAULT_PATH/00 Kontext/$f"
  fi
done

if [[ -f "$REPO_DIR/templates/vault/00 Kontext/Workflows/Projekt-Anlegen.md" ]]; then
  copy_if_missing \
    "$REPO_DIR/templates/vault/00 Kontext/Workflows/Projekt-Anlegen.md" \
    "$VAULT_PATH/00 Kontext/Workflows/Projekt-Anlegen.md"
fi

# === Schritt 4: Codex-Spiegel (optional) ===

section "4. Codex-Spiegel im Vault (optional)"

printf "Der Codex-Spiegel ist eine Variante der CLAUDE.md mit 'Codex'-Sprache.\n"
printf "Nur sinnvoll wenn du Codex CLI nutzt.\n"
if ask_yes_no "AGENTS.md im Vault-Wurzel anlegen?" "n"; then
  copy_if_missing "$REPO_DIR/templates/vault/AGENTS.md" "$VAULT_PATH/AGENTS.md"
fi

# === Schritt 5: Globale KI-Configs ===

section "5. Globale KI-Configs"

# Claude Code
if ask_yes_no "Claude Code Config (~/.claude/CLAUDE.md) anlegen?" "y"; then
  mkdir -p "$HOME/.claude"
  copy_if_missing "$REPO_DIR/templates/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
fi

# Gemini CLI
if ask_yes_no "Gemini CLI Config (~/.gemini/GEMINI.md) anlegen?" "n"; then
  mkdir -p "$HOME/.gemini"
  copy_if_missing "$REPO_DIR/templates/gemini/GEMINI.md" "$HOME/.gemini/GEMINI.md"
fi

# Codex CLI
if ask_yes_no "Codex CLI Config (~/.codex/AGENTS.md) anlegen?" "n"; then
  mkdir -p "$HOME/.codex"
  copy_if_missing "$REPO_DIR/templates/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
fi

# === Schritt 6: Skills installieren ===

section "6. Claude Code Skills (optional)"

printf "Drei Skills sind verfuegbar: projekt-init, lint, ingest.\n"
printf "Sie liegen unter ~/.claude/skills/ und werden von Claude Code automatisch geladen.\n"
if ask_yes_no "Alle drei Skills installieren?" "y"; then
  mkdir -p "$HOME/.claude/skills"
  for skill in projekt-init lint ingest; do
    if [[ -d "$HOME/.claude/skills/$skill" ]]; then
      warn "Skill existiert bereits — nicht ueberschrieben: $skill"
    elif [[ -d "$REPO_DIR/skills/$skill" ]]; then
      cp -r "$REPO_DIR/skills/$skill" "$HOME/.claude/skills/"
      ok "Skill installiert: $skill"
    else
      warn "Skill nicht gefunden im Repo: $skill"
    fi
  done
fi

# === Schritt 7: Pfad-Hinweise ===

section "7. Abschluss & naechste Schritte"

if [[ "$VAULT_PATH" != "$DEFAULT_VAULT" ]]; then
  warn "Du hast einen abweichenden Vault-Pfad gewaehlt."
  warn "Die kopierten Configs enthalten Default-Pfade (~/Obsidian/SecondBrain/)."
  warn "Pruefe und korrigiere die Pfade in den Configs:"
  echo "  - $VAULT_PATH/CLAUDE.md"
  [[ -f "$HOME/.claude/CLAUDE.md" ]] && echo "  - $HOME/.claude/CLAUDE.md"
  [[ -f "$HOME/.gemini/GEMINI.md" ]] && echo "  - $HOME/.gemini/GEMINI.md"
  [[ -f "$HOME/.codex/AGENTS.md" ]] && echo "  - $HOME/.codex/AGENTS.md"
  echo ""
  echo "  Schnellfix (z.B. mit sed):"
  echo "    grep -rl '~/Obsidian/SecondBrain' \"\$HOME/.claude/CLAUDE.md\" \"$VAULT_PATH\"/*.md | \\"
  echo "      xargs sed -i '' 's|~/Obsidian/SecondBrain|${VAULT_PATH/#$HOME/\~}|g'"
fi

echo ""
ok "Setup abgeschlossen."
echo ""
echo "Naechste Schritte:"
echo "  1. Obsidian oeffnen → 'Open folder as vault' → $VAULT_PATH"
echo "  2. Dataview-Plugin aktivieren (Settings → Community Plugins → Dataview)"
echo "  3. Eigenes Profil anlegen: $VAULT_PATH/00 Kontext/Über mich.md"
echo "  4. In Claude Code testen: \"Was steht in meiner Inbox?\""
echo ""
echo "Doku:"
echo "  - $REPO_DIR/README.md (Quickstart)"
echo "  - $REPO_DIR/handbuch/ (sieben Kapitel)"
echo ""
echo "Claude Desktop einrichten: siehe $REPO_DIR/templates/claude-desktop/README.md"
echo ""
