#!/bin/bash
set -eo pipefail

if [ -n "$SOURCE_DATE_EPOCH" ]; then
    # Already explicitly supplied
    :
elif git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    # Derive deterministic date from the last commit affecting the source file.
    export SOURCE_DATE_EPOCH=$(git log -1 --format=%ct -- resume.typ)
else
    echo "Error: SOURCE_DATE_EPOCH is not set and cannot derive deterministic date (not inside a git work tree)." >&2
    exit 1
fi

if [ -n "$1" ]; then
  OUTPUT_PREFIX="$1"
else
  OUTPUT_PREFIX="resume"
fi

OUTPUT_DIR=$(dirname "$OUTPUT_PREFIX")

TYPST_FONT_PATHS=./fonts typst compile resume.typ "${OUTPUT_PREFIX}.pdf"

mkdir -p "$OUTPUT_DIR/assets"
TYPST_FONT_PATHS=./fonts typst compile --ppi 300 --pages 1 resume.typ "$OUTPUT_DIR/assets/resume-preview.png"

TYPST_FONT_PATHS=./fonts typst compile -f png resume.typ "${OUTPUT_PREFIX}-page-{n}.png"
