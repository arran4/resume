#!/usr/bin/env bash
set -euo pipefail

# This script validates a release tag and determines release properties.
# Inputs:
#   TAG_NAME (from arg 1)
#   DEFAULT_BRANCH (from env DEFAULT_BRANCH)
# Outputs (to stdout and GITHUB_OUTPUT):
#   prerelease (true/false)
#   publish (true/false)

TAG_NAME="${1:-}"

if [[ -z "$TAG_NAME" ]]; then
  echo "Error: TAG_NAME is required." >&2
  exit 1
fi

if [[ -z "${DEFAULT_BRANCH:-}" ]]; then
  echo "Error: DEFAULT_BRANCH environment variable must be provided." >&2
  exit 1
fi

# The format should be vMAJOR.MINOR.PATCH[-SUFFIX]
# We'll use bash regex groups to parse the suffix if present
if [[ ! "$TAG_NAME" =~ ^v[0-9]+\.[0-9]+\.[0-9]+([-.]([0-9A-Za-z.]+))?$ ]]; then
  echo "Invalid release tag format: $TAG_NAME" >&2
  exit 1
fi

SUFFIX="${BASH_REMATCH[2]:-}"
PRERELEASE="false"
PUBLISH="true"

# Explicit policy for suffixes
if [[ -z "$SUFFIX" ]]; then
  # Stable release
  PRERELEASE="false"
  PUBLISH="true"
else
  # Check against allowed suffixes precisely
  # Convert suffix to lowercase for case-insensitive matching
  SUFFIX_LOWER=$(echo "$SUFFIX" | tr '[:upper:]' '[:lower:]')

  if [[ "$SUFFIX_LOWER" =~ ^test(\.[0-9]+)?$ ]]; then
    PUBLISH="false"
  elif [[ "$SUFFIX_LOWER" =~ ^(rc|alpha|beta)(\.[0-9]+)?$ ]]; then
    PRERELEASE="true"
  else
    echo "Error: Unrecognized tag suffix '${SUFFIX}'. Accepted suffixes are 'test', 'rc', 'alpha', 'beta' (optionally followed by a dot and a number)." >&2
    exit 1
  fi
fi

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "prerelease=$PRERELEASE" >> "$GITHUB_OUTPUT"
  echo "publish=$PUBLISH" >> "$GITHUB_OUTPUT"
fi

echo "Tag classification:"
echo "  prerelease=$PRERELEASE"
echo "  publish=$PUBLISH"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
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
