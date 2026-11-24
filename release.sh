#!/usr/bin/env bash
# Builds Bit plugins from the private source and syncs their public files
# here: release.sh <source> <owner/repo> [plugin...] (none: every plugin).
#
# For each plugin whose <name>-v<version> release doesn't exist yet, it
# builds the programs for the platforms its .bit/plugin.json names into
# dist/<tag>/ with checksums.txt, and copies its manifests, skills and
# README (never its code) into plugins/<name>/, "binaries" pointed at this
# repository's release. Then .claude-plugin/marketplace.json is written
# from the source's, for the plugins here. The tags to publish are printed
# into dist/tags. FORCE=1 builds those released already too.
set -euo pipefail

src=$(cd "$1" && pwd)
repo=$2
shift 2
here=$(cd "$(dirname "$0")" && pwd)
dist="$here/dist"
mkdir -p "$dist" "$here/plugins"
: > "$dist/tags"

names=("$@")
if [[ ${#names[@]} -eq 0 ]]; then
  names=($(jq -r '.plugins[].name' "$src/.claude-plugin/marketplace.json"))
fi

released() { gh release view "$1" -R "$repo" >/dev/null 2>&1; }

for name in "${names[@]}"; do
  dir="$src/plugins/$name"
  [[ -f "$dir/.claude-plugin/plugin.json" && -f "$dir/.bit/plugin.json" ]] || { echo "$name: no plugin in $dir" >&2; exit 1; }
  version=$(jq -r .version "$dir/.claude-plugin/plugin.json")
  tag="$name-v$version"
  if [[ -z "${FORCE:-}" ]] && released "$tag"; then
    echo "$name: $tag is released already"
    continue
  fi
  bin=$(grep -m1 -o 'go build[^\n]*-o bin/[^ ]*' "$dir/justfile" | sed 's|.*bin/||')
  out="$dist/$tag"
  rm -rf "$out" && mkdir -p "$out"
  for p in $(jq -r '.platforms[]' "$dir/.bit/plugin.json"); do
    os=${p%/*} arch=${p#*/}
    (cd "$dir" && CGO_ENABLED=0 GOOS=$os GOARCH=$arch go build -trimpath -ldflags="-s -w" -o "$out/$bin" .)
    COPYFILE_DISABLE=1 tar -C "$out" -czf "$out/${bin}_${os}_${arch}.tar.gz" "$bin"
    rm "$out/$bin"
  done
  (cd "$out" && shasum -a 256 -- *.tar.gz > checksums.txt)

  # Public files only: the code stays in the source.
  pub="$here/plugins/$name"
  rm -rf "$pub" && mkdir -p "$pub"
  for f in .claude-plugin .codex-plugin .bit skills commands agents hooks .mcp.json README.md; do
    [[ -e "$dir/$f" ]] && cp -R "$dir/$f" "$pub/"
  done
  url="https://github.com/$repo/releases/download/$name-v\${VERSION}/${bin}_\${OS}_\${ARCH}.tar.gz"
  jq --arg url "$url" '.binaries = $url' "$dir/.bit/plugin.json" > "$pub/.bit/plugin.json"
  echo "$tag" >> "$dist/tags"
  echo "$name: built $tag"
done

# The catalog: the source's entries for the plugins here.
present=$(ls "$here/plugins" | jq -R . | jq -s .)
jq --argjson present "$present" '.plugins |= map(select(.name as $n | $present | index($n)))' \
  "$src/.claude-plugin/marketplace.json" > "$here/.claude-plugin/marketplace.json"
