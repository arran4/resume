#!/bin/bash
set -eo pipefail

echo "Running determinism regression test..."

# Ensure faketime is installed for this test
if ! command -v faketime &> /dev/null; then
    echo "faketime is not installed. Please install it (e.g., sudo apt-get install faketime) to run this test."
    exit 1
fi

if ! command -v pdftotext &> /dev/null; then
    echo "pdftotext is not installed. Please install poppler-utils to run this test."
    exit 1
fi
if ! command -v pdfinfo &> /dev/null; then
    echo "pdfinfo is not installed. Please install poppler-utils to run this test."
    exit 1
fi

DIR1=$(mktemp -d)
DIR2=$(mktemp -d)

# Build 1: Simulate building in the past
echo "Building in past environment (2020-01-01)..."
faketime "2020-01-01 12:00:00" ./build.sh "$DIR1/resume"

# Build 2: Simulate building in the future
echo "Building in future environment (2030-01-01)..."
faketime "2030-01-01 12:00:00" ./build.sh "$DIR2/resume"

echo "Comparing PDF bytes across wall clocks..."
if ! cmp -s "$DIR1/resume.pdf" "$DIR2/resume.pdf"; then
  echo "PDF bytes differ across wall clocks!"

  echo "Investigating extracted text differences..."
  pdftotext "$DIR1/resume.pdf" "$DIR1/resume.txt"
  pdftotext "$DIR2/resume.pdf" "$DIR2/resume.txt"
  if ! cmp -s "$DIR1/resume.txt" "$DIR2/resume.txt"; then
      echo "Extracted text differs! See diff below:"
      diff "$DIR1/resume.txt" "$DIR2/resume.txt" || true
  else
      echo "Extracted text matches exactly. The difference is only in non-visible metadata."
  fi

  echo "Failing test due to PDF byte-for-byte difference."
  exit 1
fi
echo "PDF bytes match exactly."

echo "Comparing PDF page count..."
PAGE_COUNT1=$(pdfinfo "$DIR1/resume.pdf" | grep "Pages:" | awk '{print $2}')
PAGE_COUNT2=$(pdfinfo "$DIR2/resume.pdf" | grep "Pages:" | awk '{print $2}')

if [ "$PAGE_COUNT1" -ne "$PAGE_COUNT2" ]; then
    echo "PDF page count differs! $PAGE_COUNT1 vs $PAGE_COUNT2"
    exit 1
fi
echo "PDF page count is deterministic ($PAGE_COUNT1 pages)."

echo "Comparing extracted text..."
pdftotext "$DIR1/resume.pdf" "$DIR1/resume.txt"
pdftotext "$DIR2/resume.pdf" "$DIR2/resume.txt"
if ! cmp -s "$DIR1/resume.txt" "$DIR2/resume.txt"; then
    echo "Extracted text differs!"
    exit 1
fi
echo "Extracted text matches exactly."

echo "Comparing PNGs..."
PAGES1=$(ls "$DIR1"/*.png | wc -l)
PAGES2=$(ls "$DIR2"/*.png | wc -l)

if [ "$PAGES1" -ne "$PAGES2" ]; then
  echo "PNG Page count differs! $PAGES1 vs $PAGES2"
  exit 1
fi
echo "PNG page count is deterministic ($PAGES1 files)."

for img in "$DIR1"/resume-page-*.png; do
  basename=$(basename "$img")
  if ! cmp -s "$img" "$DIR2/$basename"; then
    echo "PNG $basename differs!"
    exit 1
  fi
done

if ! cmp -s "$DIR1/assets/resume-preview.png" "$DIR2/assets/resume-preview.png"; then
    echo "Preview image differs!"
    exit 1
fi

echo "All PNG hashes match."

echo "Determinism check passed."
rm -rf "$DIR1" "$DIR2"
