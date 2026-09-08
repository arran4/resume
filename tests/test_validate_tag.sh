#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
VALIDATE_SCRIPT="$SCRIPT_DIR/../.github/scripts/validate_tag.sh"

function run_test() {
  local tag="$1"
  local expected_exit="$2"
  local expected_prerelease="$3"
  local expected_publish="$4"

  echo "Testing tag: $tag"

  OUTPUT=$( DEFAULT_BRANCH=main "$VALIDATE_SCRIPT" "$tag" 2>&1 ) || EXIT_CODE=$?
  EXIT_CODE=${EXIT_CODE:-0}

  if [[ "$EXIT_CODE" != "$expected_exit" ]]; then
    echo "FAIL: Expected exit code $expected_exit, got $EXIT_CODE"
    echo "Output: $OUTPUT"
    return 1
  fi

  if [[ "$expected_exit" == "0" ]]; then
    if ! echo "$OUTPUT" | grep -q "prerelease=$expected_prerelease"; then
      echo "FAIL: Expected prerelease=$expected_prerelease"
      echo "Output: $OUTPUT"
      return 1
    fi
    if ! echo "$OUTPUT" | grep -q "publish=$expected_publish"; then
      echo "FAIL: Expected publish=$expected_publish"
      echo "Output: $OUTPUT"
      return 1
    fi
  fi

  echo "PASS"
  echo ""
}

# Ensure we're in a git repo
git rev-parse --is-inside-work-tree >/dev/null

# Delete any old tags just in case
git tag -d $(git tag -l "v*") 2>/dev/null || true
git tag -d malformed 2>/dev/null || true
git branch -D unreachable_branch 2>/dev/null || true

# Lightweight tags
git tag -f v1.2.3 origin/main
git tag -f v1.2.3-rc origin/main
git tag -f v1.2.3-rc.1 origin/main
git tag -f v1.2.3-alpha.1 origin/main
git tag -f v1.2.3-beta.1 origin/main
git tag -f v1.2.3-test.1 origin/main
git tag -f malformed origin/main

# Annotated tags
git tag -a -m "annotated test" v1.2.3-test.2 origin/main
git tag -a -m "annotated rc" v1.2.3-rc.2 origin/main

# Unrelated suffixes that should fail validation
git tag -f v1.2.3-contest origin/main
git tag -f v1.2.3-orchestra origin/main

# Unreachable tag
git checkout -b unreachable_branch origin/main~5
git commit --allow-empty -m "Unreachable commit"
git tag -f v1.2.3-unreachable HEAD
git checkout main

echo "Running validation tests..."

# Valid standard suffixes
run_test "v1.2.3" 0 "false" "true"
run_test "v1.2.3-rc" 0 "true" "true"
run_test "v1.2.3-rc.1" 0 "true" "true"
run_test "v1.2.3-alpha.1" 0 "true" "true"
run_test "v1.2.3-beta.1" 0 "true" "true"
run_test "v1.2.3-test.1" 0 "false" "false"

# Annotated tags
run_test "v1.2.3-test.2" 0 "false" "false"
run_test "v1.2.3-rc.2" 0 "true" "true"

# Negative tests (should fail validation)
run_test "v1.2.3-contest" 1 "" ""
run_test "v1.2.3-orchestra" 1 "" ""
run_test "malformed" 1 "" ""
run_test "v1.2.3-unreachable" 1 "" ""

echo "All validate tests passed!"

# Cleanup test tags
git tag -d $(git tag -l "v*") 2>/dev/null || true
git branch -D unreachable_branch 2>/dev/null || true
