#!/bin/bash
set -euo pipefail

WORKFLOW=".github/workflows/typst.yaml"

echo "Validating workflow concurrency semantics..."

FAIL=0

if ! grep -q "group: \${{ github.workflow }}-\${{ github.ref }}-\${{ github.event.inputs.update_preview == 'true' && 'writer' || 'reader' }}" "$WORKFLOW"; then
  echo "FAIL: Missing or incorrect top-level concurrency group."
  FAIL=1
else
  echo "✓ Top-level concurrency group isolates read-only vs preview-writing runs."
fi

if ! grep -q "cancel-in-progress: \${{ github.ref_type != 'tag' && github.event.inputs.update_preview != 'true' }}" "$WORKFLOW"; then
  echo "FAIL: Missing or incorrect top-level cancel-in-progress logic."
  FAIL=1
else
  echo "✓ Top-level cancel-in-progress correctly protects tags and preview writers."
fi

if ! grep -q "group: preview-writer-\${{ github.event.repository.default_branch }}" "$WORKFLOW"; then
  echo "FAIL: Missing or incorrect job-level concurrency group for create-preview-pr."
  FAIL=1
else
  echo "✓ Job-level concurrency serializes preview writers on the default branch."
fi

if ! awk '/create-preview-pr:/,/steps:/' "$WORKFLOW" | grep -q "cancel-in-progress: false"; then
  echo "FAIL: Missing or incorrect job-level cancel-in-progress logic (should be false)."
  FAIL=1
else
  echo "✓ Job-level cancel-in-progress prevents writers from aborting each other."
fi

if [ $FAIL -ne 0 ]; then
  kill -s TERM $$
fi

echo "All concurrency semantics validated successfully."
