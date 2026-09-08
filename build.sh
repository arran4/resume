#!/bin/bash
set -eo pipefail

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    export SOURCE_DATE_EPOCH=$(git log -1 --format=%ct)
else
    # Fallback if downloaded as a zip file, for instance.
    export SOURCE_DATE_EPOCH=$(date +%s)
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
