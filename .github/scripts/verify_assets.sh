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
# We rely on globbing to find what was produced. If none were produced, it's an error.
shopt -s nullglob
PNG_FILES=(Arran-Ubels-${REF}-page-*.png)
shopt -u nullglob

if [[ ${#PNG_FILES[@]} -eq 0 ]]; then
  echo "Error: Missing expected page-PNG set (Arran-Ubels-${REF}-page-*.png)" >&2
  exit 1
fi

for png in "${PNG_FILES[@]}"; do
  echo "$png" >> "$MANIFEST_FILE"
done

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
