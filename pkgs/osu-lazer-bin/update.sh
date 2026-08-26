#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NIX_FILE="$SCRIPT_DIR/osu-lazer.nix"

if [[ ! -f "$NIX_FILE" ]]; then
  echo "Error: $NIX_FILE not found" >&2
  exit 1
fi

echo "Fetching latest release from ppy/osu..."
LATEST_TAG=$(curl -fsSL "https://api.github.com/repos/ppy/osu/releases/latest" | jq -r '.tag_name')

if [[ -z "$LATEST_TAG" || "$LATEST_TAG" == "null" ]]; then
  echo "Error: Could not determine latest release tag" >&2
  exit 1
fi

VERSION="${LATEST_TAG%-lazer}"

if [[ -z "$VERSION" ]]; then
  echo "Error: Could not parse version from tag '$LATEST_TAG'" >&2
  exit 1
fi

echo "Latest version: $VERSION (tag: $LATEST_TAG)"

CURRENT_VERSION=$(grep -oP 'version\s*=\s*"\K[^"]+' "$NIX_FILE")
echo "Current version: $CURRENT_VERSION"

if [[ "$VERSION" == "$CURRENT_VERSION" ]]; then
  echo "Already up to date."
  exit 0
fi

echo "Computing source hash for $LATEST_TAG..."
NAR_HASH=$(nix-prefetch-url --unpack --type sha256 \
  "https://api.github.com/repos/ppy/osu/tarball/$LATEST_TAG" \
  --name source 2>&1 | tail -1)

if [[ -z "$NAR_HASH" ]]; then
  echo "Error: Could not compute hash" >&2
  exit 1
fi

# Convert the plain hash to the sri format used in nix
SRI_HASH=$(nix hash convert --hash-algo sha256 "$NAR_HASH")

echo "New hash: $SRI_HASH"

echo "Updating $NIX_FILE..."
sed -i "s|version = \"$CURRENT_VERSION\"|version = \"$VERSION\"|g" "$NIX_FILE"
sed -i "s|hash = \"[^\"]*\"|hash = \"$SRI_HASH\"|g" "$NIX_FILE"

echo "Updated $CURRENT_VERSION -> $VERSION"
echo "Done."
