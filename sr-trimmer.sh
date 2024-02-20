#!/usr/bin/env bash

set -e

if ! type jq >/dev/null 2>&1; then
  echo 'sr-trimmer needs jq to work correctly'
  exit 1
fi

srt() {
  local json_file
  json_file=$1

  # YYYY FOO -> FOO
  jq '
    map(if .year as $year | (.authority | tostring) | startswith($year) then .authority = .authority[5:] else . end)
  ' "$json_file" >"$json_file.tmp" && mv "$json_file.tmp" "$json_file"

  # [YYYY] FOO -> FOO
  jq '
    map(if .year as $year | (.authority | tostring)[1:] | startswith($year) then .authority = .authority[7:] else . end)
  ' "$json_file" >"$json_file.tmp" && mv "$json_file.tmp" "$json_file"

  jq '
    map(if .year as $year | (."series-reference" | tostring) | startswith($year) then ."series-reference" = ."series-reference"[5:] else . end)
  ' "$json_file" >"$json_file.tmp" && mv "$json_file.tmp" "$json_file"

  jq '
    map(if .year as $year | (."series-reference" | tostring)[1:] | startswith($year) then ."series-reference" = ."series-reference"[7:] else . end)
  ' "$json_file" >"$json_file.tmp" && mv "$json_file.tmp" "$json_file"

  echo ""
  echo "Done!"
}

# e.g. ./sr-trimmer.sh bibliography.json
srt "$@"
