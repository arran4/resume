#!/usr/bin/env bash
set -euo pipefail

# This script verifies release assets and generates a manifest.
# Inputs:
#   REF (from arg 1)
# Outputs (to stdout and GITHUB_STEP_SUMMARY):
#   Manifest of expected files. Exits 1 if any missing.

REF="${1:-}"

if [[ -z "$REF" ]]; then
  echo "Error: REF is required." >&2
  exit 1
fi

MANIFEST_FILE="release_manifest.txt"
> "$MANIFEST_FILE"

# 1. Exact tagged PDF
PDF_FILE="Arran-Ubels-${REF}.pdf"
if [[ ! -f "$PDF_FILE" ]]; then
  echo "Error: Missing exact tagged PDF: $PDF_FILE" >&2
  exit 1
fi
echo "$PDF_FILE" >> "$MANIFEST_FILE"

# 2. Complete expected page-PNG set produced by the build
# We derive the expected page count from the generated PDF.
if ! command -v pdfinfo >/dev/null 2>&1; then
  echo "Error: pdfinfo command not found. Please install poppler-utils." >&2
  exit 1
fi

PAGE_COUNT=$(pdfinfo "$PDF_FILE" | grep "^Pages:" | awk '{print $2}')
if [[ -z "$PAGE_COUNT" || ! "$PAGE_COUNT" =~ ^[0-9]+$ ]]; then
  echo "Error: Could not determine page count from $PDF_FILE" >&2
  exit 1
fi

if [[ "$PAGE_COUNT" -eq 0 ]]; then
  echo "Error: PDF has 0 pages." >&2
  exit 1
fi

for ((i=1; i<=PAGE_COUNT; i++)); do
  PNG_FILE="Arran-Ubels-${REF}-page-${i}.png"
  if [[ ! -f "$PNG_FILE" ]]; then
    echo "Error: Missing expected page PNG: $PNG_FILE" >&2
    exit 1
  fi
  echo "$PNG_FILE" >> "$MANIFEST_FILE"
done

# Check if there are unexpected extra PNG pages (e.g. page count is 2, but page-3.png exists)
NEXT_PAGE=$((PAGE_COUNT + 1))
UNEXPECTED_PNG="Arran-Ubels-${REF}-page-${NEXT_PAGE}.png"
if [[ -f "$UNEXPECTED_PNG" ]]; then
  echo "Error: Found unexpected extra page PNG: $UNEXPECTED_PNG" >&2
  exit 1
fi

# 3. assets/resume-preview.png
PREVIEW_FILE="assets/resume-preview.png"
if [[ ! -f "$PREVIEW_FILE" ]]; then
  echo "Error: Missing preview image: $PREVIEW_FILE" >&2
  exit 1
fi
echo "$PREVIEW_FILE" >> "$MANIFEST_FILE"

# Sort the manifest deterministically
sort "$MANIFEST_FILE" -o "$MANIFEST_FILE"

echo "## Release Artifacts Manifest" >> "${GITHUB_STEP_SUMMARY:-/dev/null}"
echo '```' >> "${GITHUB_STEP_SUMMARY:-/dev/null}"
cat "$MANIFEST_FILE" >> "${GITHUB_STEP_SUMMARY:-/dev/null}"
echo '```' >> "${GITHUB_STEP_SUMMARY:-/dev/null}"

cat "$MANIFEST_FILE"
