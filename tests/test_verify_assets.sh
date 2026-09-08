#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
VERIFY_SCRIPT="$(readlink -f "$SCRIPT_DIR/../.github/scripts/verify_assets.sh")"

# Setup Mock pdfinfo
MOCK_DIR=$(mktemp -d)
cat << 'MOCK' > "$MOCK_DIR/pdfinfo"
#!/bin/bash
echo "Pages: ${MOCK_PDF_PAGES:-1}"
MOCK
chmod +x "$MOCK_DIR/pdfinfo"
export PATH="$MOCK_DIR:$PATH"

function run_test() {
  local ref="$1"
  local expected_exit="$2"

  echo "Testing verify assets for REF: $ref"

  # Ensure EXIT_CODE captures the actual return value, and we don't abort due to set -e
  set +e
  OUTPUT=$( "$VERIFY_SCRIPT" "$ref" 2>&1 )
  EXIT_CODE=$?
  set -e

  if [[ "$EXIT_CODE" != "$expected_exit" ]]; then
    echo "FAIL: Expected exit code $expected_exit, got $EXIT_CODE"
    echo "Output: $OUTPUT"
    return 1
  fi

  echo "PASS"
  echo ""
}

echo "Running verify tests..."

# Scenario 1: Missing PDF
rm -f Arran-Ubels-v1.0.0.pdf Arran-Ubels-v1.0.0-page-1.png assets/resume-preview.png
touch Arran-Ubels-v1.0.0-page-1.png assets/resume-preview.png
run_test "v1.0.0" 1

# Scenario 2: Missing PNG set
export MOCK_PDF_PAGES=1
touch Arran-Ubels-v1.0.0.pdf
rm -f Arran-Ubels-v1.0.0-page-*.png
touch assets/resume-preview.png
run_test "v1.0.0" 1

# Scenario 3: Missing Preview
rm -f assets/resume-preview.png
touch Arran-Ubels-v1.0.0-page-1.png
run_test "v1.0.0" 1

# Scenario 4: All valid (1 page PDF)
touch Arran-Ubels-v1.0.0-page-1.png assets/resume-preview.png
run_test "v1.0.0" 0

# Verify manifest for valid case
MANIFEST_FILE="release_manifest.txt"
if [[ ! -f "$MANIFEST_FILE" ]]; then
  echo "FAIL: release_manifest.txt not created"
  exit 1
fi
EXPECTED_MANIFEST=$(printf "Arran-Ubels-v1.0.0-page-1.png\nArran-Ubels-v1.0.0.pdf\nassets/resume-preview.png")
ACTUAL_MANIFEST=$(cat "$MANIFEST_FILE")
if [[ "$EXPECTED_MANIFEST" != "$ACTUAL_MANIFEST" ]]; then
  echo "FAIL: Manifest contents do not match expected output."
  echo "Expected:"
  echo "$EXPECTED_MANIFEST"
  echo "Actual:"
  echo "$ACTUAL_MANIFEST"
  exit 1
fi
echo "Manifest contents verified."
echo ""

# Scenario 5: Missing a middle page (requires a 2-page PDF for test)
export MOCK_PDF_PAGES=2
rm -f Arran-Ubels-v1.0.0-page-*.png
touch Arran-Ubels-v1.0.0-page-1.png assets/resume-preview.png
# It expects page-2.png now
run_test "v1.0.0" 1

# Scenario 6: Unexpected extra page
export MOCK_PDF_PAGES=1
rm -f Arran-Ubels-v1.0.0-page-*.png
touch Arran-Ubels-v1.0.0-page-1.png Arran-Ubels-v1.0.0-page-2.png assets/resume-preview.png
run_test "v1.0.0" 1

echo "All verify tests passed!"

# Cleanup
rm -f Arran-Ubels-v1.0.0.pdf Arran-Ubels-v1.0.0-page-*.png assets/resume-preview.png release_manifest.txt
rm -rf "$MOCK_DIR"
