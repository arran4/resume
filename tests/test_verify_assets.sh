#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
VERIFY_SCRIPT="$SCRIPT_DIR/../.github/scripts/verify_assets.sh"

function run_test() {
  local ref="$1"
  local expected_exit="$2"

  echo "Testing verify assets for REF: $ref"

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

# To test this, we need a valid PDF file. Let's create one.
if ! command -v groff >/dev/null 2>&1; then
  sudo apt-get update && sudo apt-get install -y groff gsfonts
fi
echo "Hello World" | groff -Tps | ps2pdf - Arran-Ubels-v1.0.0.pdf

# Scenario 1: Missing PDF
rm -f Arran-Ubels-v1.0.0.pdf Arran-Ubels-v1.0.0-page-1.png assets/resume-preview.png
touch Arran-Ubels-v1.0.0-page-1.png assets/resume-preview.png
run_test "v1.0.0" 1

# Scenario 2: Missing PNG set
echo "Hello World" | groff -Tps | ps2pdf - Arran-Ubels-v1.0.0.pdf
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

# Scenario 5: Missing a middle page (requires a 2-page PDF for test)
# Mock pdfinfo since creating a multi-page PDF might be tricky in a one-liner
# Actually we can just create a wrapper for pdfinfo to return "Pages: 2"
mkdir -p mock_bin
cat << 'MOCK' > mock_bin/pdfinfo
#!/bin/bash
echo "Pages: 2"
MOCK
chmod +x mock_bin/pdfinfo
export PATH="$PWD/mock_bin:$PATH"

rm -f Arran-Ubels-v1.0.0-page-*.png
touch Arran-Ubels-v1.0.0-page-1.png assets/resume-preview.png
# It expects page-2.png now
run_test "v1.0.0" 1

# Scenario 6: Unexpected extra page
touch Arran-Ubels-v1.0.0-page-2.png Arran-Ubels-v1.0.0-page-3.png
run_test "v1.0.0" 1

echo "All verify tests passed!"

# Cleanup
rm -f Arran-Ubels-v1.0.0.pdf Arran-Ubels-v1.0.0-page-*.png assets/resume-preview.png
rm -rf mock_bin
