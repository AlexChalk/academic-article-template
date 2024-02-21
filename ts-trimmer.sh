#!/usr/bin/env bash

set -e

if ! type jq >/dev/null 2>&1; then
  echo 'ts-trimmer needs jq to work correctly'
  exit 1
fi

if ! type sed >/dev/null 2>&1; then
  echo 'ts-trimmer needs (gnu) sed to work correctly'
  exit 1
fi

if sed -i "" temp <<<"" 2>/dev/null; then
  echo 'ts-trimmer needs (gnu) sed to work correctly, you have Mac/BSD sed installed'
  exit 1
fi

if ! type pdftotext >/dev/null 2>&1; then
  echo 'ts-trimmer needs pdftotext to work correctly'
  exit 1
fi

tst() {
  local article
  local title_matcher='\[([^\[]*?)[[:space:]]?\](;|\.$)'
  local short_titles
  local remove_hyphens
  local remove_linebreaks
  local titles_clean
  local titles_to_rm=()
  local json_titles
  local json_file

  article=$(pdftotext "$1" -)

  # To capture multiline titles, we wrap the whole title in [], then join the multiliners using sed
  short_titles=$(echo "$article" | rg --multiline --only-matching "$title_matcher" --replace '[$1]')

  # Sed command: #39 at https://catonmat.net/sed-one-liners-explained-part-one (!N performs command for *non*-matching lines)
  remove_hyphens=$(echo "${short_titles[@]}" | sed --expression :a --expression '/-$/N; s/-\n//; ta')
  remove_linebreaks=$(echo "${remove_hyphens[@]}" | sed --expression :a --expression '/\]$/!N; s/\n/\ /; ta')

  titles_clean=$(echo "${remove_linebreaks[@]}" | tr --delete '^[' | tr --delete ']$')

  while read -r title; do
    local count
    local regexp_title

    regexp_title="${title// /[[:space:]]}, supra"

    count=$(echo "$article" | rg --multiline --count --include-zero "$regexp_title" || true)

    if (("$count" == 0)); then
      titles_to_rm+=("$title")
    fi
  done < <(echo "${titles_clean[@]}")

  if ((${#titles_to_rm[@]} == 0)); then
    echo ""
    echo "Nothing to remove; exiting"
    exit
  fi

  echo ""
  echo "TS Trimmer will remove the following unused titles from" "$2"":"
  echo ""

  for title in "${titles_to_rm[@]}"; do
    echo "- $title"
  done

  json_titles=$(printf '%s\n' "${titles_to_rm[@]}" | jq --raw-input . | jq --slurp .)
  json_file="$2"

  jq --argjson titles "$json_titles" '
    map(if ."title-short" as $ts | any($titles[]; . == $ts) then del(."title-short") else . end)
  ' "$json_file" >"$json_file.tmp" && mv "$json_file.tmp" "$json_file"

  echo ""
  echo "Done!"
}

# e.g. ./ts-trimmer.sh article.pdf bibliography.json
tst "$@"
