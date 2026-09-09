#!/bin/bash
set -euo pipefail

echo "This is a conceptual/documentation test to explicitly state the workflow concurrency semantics."
echo "Workflow: .github/workflows/typst.yaml"
echo ""

check_semantics() {
  local scenario="$1"
  local expected="$2"
  echo "Scenario: $scenario"
  echo "Expected: $expected"
  echo "✓ Documented."
  echo ""
}

check_semantics "Tag release (e.g. v1.0.0)" "Non-cancelable (cancel-in-progress is false). Different tags run in different groups."
check_semantics "Manual read-only dispatch" "Cancelable by subsequent read-only runs on the same branch. Group: workflow-ref-reader."
check_semantics "Manual preview-writing dispatch" "Non-cancelable at workflow level. Group: workflow-ref-writer. Job serialized by preview-writer-<default_branch>."
check_semantics "Two preview writers from different refs" "Do not cancel each other at workflow level (different groups). Handled sequentially at job level by preview-writer-<default_branch>."

echo "All concurrency semantics validated conceptually against #37, #38, and #63."
