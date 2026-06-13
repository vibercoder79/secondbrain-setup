#!/usr/bin/env python3
"""find_duplicates.py — Bigramm-Jaccard-Heuristik fuer Duplikats-Erkennung im SecondBrain.

Verwendung:
    python3 find_duplicates.py FILE_A FILE_B [--threshold 0.6]
    python3 find_duplicates.py --scan /pfad/zum/vault [--threshold 0.6]

Modi:
    Paar-Modus: Vergleicht genau zwei Dateien, gibt Aehnlichkeit aus.
    Scan-Modus:  Sucht title-gleiche Markdown-Dateien im Vault, vergleicht Inhalte
                  und gibt alle Paare ueber Schwelle aus.

Heuristik:
    - Frontmatter und Code-Bloecke werden entfernt
    - Markdown-Syntax wird normalisiert (Wikilinks, Headings, Listen)
    - Tokenisierung auf Wort-Bigrammen
    - Jaccard-Index ueber die Bigramm-Sets

Schutzzonen (im Scan-Modus uebersprungen):
    07 Anhaenge/, 06 Archiv/, .obsidian/, .git/
"""

from __future__ import annotations

import argparse
import re
import sys
from collections import defaultdict
from pathlib import Path

PROTECTED_DIRS = {"07 Anhaenge", "06 Archiv", ".obsidian", ".git", ".claudian"}


def strip_frontmatter(text: str) -> str:
    if text.startswith("---"):
        end = text.find("\n---", 3)
        if end != -1:
            return text[end + 4 :]
    return text


def strip_code_blocks(text: str) -> str:
    return re.sub(r"```.*?```", " ", text, flags=re.DOTALL)


def normalise(text: str) -> str:
    text = strip_frontmatter(text)
    text = strip_code_blocks(text)
    text = re.sub(r"\[\[([^\]|]+)(\|[^\]]+)?\]\]", r"\1", text)
    text = re.sub(r"[#>*_`\-]", " ", text)
    text = re.sub(r"\s+", " ", text)
    return text.lower().strip()


def bigrams(text: str) -> set[tuple[str, str]]:
    tokens = text.split()
    return {(tokens[i], tokens[i + 1]) for i in range(len(tokens) - 1)}


def jaccard(a: set, b: set) -> float:
    if not a and not b:
        return 0.0
    union = a | b
    if not union:
        return 0.0
    return len(a & b) / len(union)


def similarity(path_a: Path, path_b: Path) -> float:
    try:
        text_a = path_a.read_text(encoding="utf-8", errors="ignore")
        text_b = path_b.read_text(encoding="utf-8", errors="ignore")
    except OSError as exc:
        print(f"FEHLER beim Lesen: {exc}", file=sys.stderr)
        return 0.0
    return jaccard(bigrams(normalise(text_a)), bigrams(normalise(text_b)))


def iter_vault(root: Path):
    for path in root.rglob("*.md"):
        rel_parts = path.relative_to(root).parts
        if any(part in PROTECTED_DIRS for part in rel_parts):
            continue
        yield path


def scan(root: Path, threshold: float) -> int:
    by_name: dict[str, list[Path]] = defaultdict(list)
    for path in iter_vault(root):
        by_name[path.name].append(path)

    pairs_found = 0
    for name, paths in sorted(by_name.items()):
        if len(paths) < 2:
            continue
        for i in range(len(paths)):
            for j in range(i + 1, len(paths)):
                score = similarity(paths[i], paths[j])
                if score >= threshold:
                    pairs_found += 1
                    print(
                        f"{score:.2f}\t{paths[i].relative_to(root)}\t{paths[j].relative_to(root)}"
                    )
    print(f"\nFertig. {pairs_found} Duplikats-Paare ueber Schwelle {threshold}.", file=sys.stderr)
    return pairs_found


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("files", nargs="*", help="Zwei Dateipfade fuer Paar-Modus.")
    parser.add_argument("--scan", metavar="VAULT", help="Scan-Modus: durchsucht das Vault nach Duplikats-Paaren.")
    parser.add_argument("--threshold", type=float, default=0.6, help="Jaccard-Schwelle (Default 0.6).")
    args = parser.parse_args()

    if args.scan:
        root = Path(args.scan).expanduser().resolve()
        if not root.is_dir():
            print(f"FEHLER: {root} ist kein Ordner.", file=sys.stderr)
            return 2
        return 0 if scan(root, args.threshold) >= 0 else 1

    if len(args.files) != 2:
        parser.print_help(sys.stderr)
        return 2

    path_a, path_b = Path(args.files[0]), Path(args.files[1])
    score = similarity(path_a, path_b)
    verdict = "DUPLIKAT" if score >= args.threshold else "unterschiedlich"
    print(f"Aehnlichkeit: {score:.2f} ({verdict}, Schwelle {args.threshold})")
    print(f"  A: {path_a}")
    print(f"  B: {path_b}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
