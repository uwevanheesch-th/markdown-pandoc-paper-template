#!/usr/bin/env bash
# Build the PDF from the Markdown source using Pandoc.
# Usage:  ./scripts/build.sh            (build PDF)
#         ./scripts/build.sh tex        (build LaTeX instead of PDF)
#
# Run this from the project root (the folder that contains "document/").

set -euo pipefail

# Resolve the project root as the parent of this script's directory,
# so the script works no matter where it is called from.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR"

SRC="document/paper.md"
BIB="document/references.bib"
CSL="document/numeric.csl"
OUT_DIR="generated"
FORMAT="${1:-pdf}"      # "pdf" (default) or "tex"
OUT="$OUT_DIR/paper.$FORMAT"

mkdir -p "$OUT_DIR"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "ERROR: pandoc is not installed or not on your PATH." >&2
  echo "See the README for installation instructions." >&2
  exit 1
fi

echo "Building $OUT from $SRC ..."
pandoc "$SRC" \
  -s \
  --citeproc \
  --csl="$CSL" \
  --bibliography="$BIB" \
  --resource-path="document" \
  -o "$OUT"

echo "Done: $OUT"
