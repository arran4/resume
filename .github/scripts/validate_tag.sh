#!/usr/bin/env bash
set -euo pipefail

# This script validates a release tag and determines release properties.
# Inputs:
#   TAG_NAME (from env or arg 1)
# Outputs (to stdout and GITHUB_OUTPUT):
#   prerelease (true/false)
#   publish (true/false)

TAG_NAME="${1:-${TAG_NAME:-}}"

if [[ -z "$TAG_NAME" ]]; then
  echo "Error: TAG_NAME is required." >&2
  exit 1
fi

if [[ ! "$TAG_NAME" =~ ^v[0-9]+\.[0-9]+\.[0-9]+([-.][0-9A-Za-z.]+)?$ ]]; then
  echo "Invalid release tag format: $TAG_NAME" >&2
  exit 1
fi

PRERELEASE="false"
PUBLISH="true"

# Case-insensitive check for test tags
if echo "$TAG_NAME" | grep -iq "test"; then
  PUBLISH="false"
# Case-insensitive check for prerelease tags
elif echo "$TAG_NAME" | grep -iqE "rc|alpha|beta"; then
  PRERELEASE="true"
fi

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "prerelease=$PRERELEASE" >> "$GITHUB_OUTPUT"
  echo "publish=$PUBLISH" >> "$GITHUB_OUTPUT"
fi

echo "Tag classification:"
echo "  prerelease=$PRERELEASE"
echo "  publish=$PUBLISH"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  # Determine default branch
  DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "")
  if [[ -z "$DEFAULT_BRANCH" ]]; then
    if git show-ref --verify --quiet refs/remotes/origin/main 2>/dev/null; then
      DEFAULT_BRANCH="main"
    elif git show-ref --verify --quiet refs/remotes/origin/master 2>/dev/null; then
      DEFAULT_BRANCH="master"
    else
      DEFAULT_BRANCH="main"
    fi
  fi

  # Resolve lightweight and annotated tags
  if git show-ref --verify --quiet "refs/tags/$TAG_NAME" 2>/dev/null; then
    TAG_COMMIT=$(git rev-parse "refs/tags/${TAG_NAME}^{commit}")
  else
    TAG_COMMIT=$(git rev-parse "${TAG_NAME}^{commit}" 2>/dev/null || echo "")
    if [[ -z "$TAG_COMMIT" ]]; then
        echo "Error: Tag $TAG_NAME not found in git." >&2
        exit 1
    fi
  fi

  echo "Release tag: $TAG_NAME"
  echo "Resolved commit: $TAG_COMMIT"
  echo "Default branch: $DEFAULT_BRANCH"

  # We use origin/$DEFAULT_BRANCH for reachability if it exists, otherwise local $DEFAULT_BRANCH
  TARGET_BRANCH="origin/$DEFAULT_BRANCH"
  if ! git show-ref --verify --quiet "refs/remotes/$TARGET_BRANCH" 2>/dev/null; then
    TARGET_BRANCH="$DEFAULT_BRANCH"
  fi

  if git merge-base --is-ancestor "$TAG_COMMIT" "$TARGET_BRANCH" 2>/dev/null; then
    echo "Reachability: VALID (commit is reachable from $TARGET_BRANCH)"
  else
    echo "Reachability: INVALID (commit is NOT reachable from $TARGET_BRANCH)" >&2
    exit 1
  fi
fi
