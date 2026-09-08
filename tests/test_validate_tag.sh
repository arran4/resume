#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
VALIDATE_SCRIPT="$(readlink -f "$SCRIPT_DIR/../.github/scripts/validate_tag.sh")"

function run_test() {
  local tag="$1"
  local expected_exit="$2"
  local expected_prerelease="$3"
  local expected_publish="$4"

  echo "Testing tag: $tag"

  # Ensure EXIT_CODE captures the actual return value, and we don't abort due to set -e
  set +e
  OUTPUT=$( DEFAULT_BRANCH=main "$VALIDATE_SCRIPT" "$tag" 2>&1 )
  EXIT_CODE=$?
  set -e

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

# Create an isolated temporary git repo
TEST_DIR=$(mktemp -d)
echo "Setting up isolated test repository at $TEST_DIR"
pushd "$TEST_DIR" > /dev/null

git init -b main
git config user.email "test@example.com"
git config user.name "Test User"
git commit --allow-empty -m "Initial commit"

# Create a local 'origin/main' ref manually to avoid network operations
git update-ref refs/remotes/origin/main HEAD
git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main

# Lightweight tags
git tag v1.2.3 HEAD
git tag v1.2.3-rc HEAD
git tag v1.2.3-rc.1 HEAD
git tag v1.2.3-alpha.1 HEAD
git tag v1.2.3-beta.1 HEAD
git tag v1.2.3-test.1 HEAD
git tag malformed HEAD

# Annotated tags
git tag -a -m "annotated test" v1.2.3-test.2 HEAD
git tag -a -m "annotated rc" v1.2.3-rc.2 HEAD

# Unrelated suffixes that should fail validation
git tag v1.2.3-contest HEAD
git tag v1.2.3-orchestra HEAD

# Unreachable tag - valid format, but unmerged commit
git checkout -b unreachable_branch HEAD
git commit --allow-empty -m "Unreachable commit"
git tag v1.2.4-rc.3 HEAD
# Also test an annotated unreachable tag
git commit --allow-empty -m "Another Unreachable commit"
git tag -a -m "annotated unreachable" v1.2.4-rc.4 HEAD
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

# Reachability tests (valid format, but unreachable from main)
run_test "v1.2.4-rc.3" 1 "" ""
run_test "v1.2.4-rc.4" 1 "" ""

echo "All validate tests passed!"

popd > /dev/null
rm -rf "$TEST_DIR"
