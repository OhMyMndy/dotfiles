#!/usr/bin/env bash

set -e
user="$1"

output_folder="$HOME/.deezer/"
mkdir -p "$output_folder/${user}/playlists"

page=1
url="https://api.deezer.com/user/${user}/playlists"
files=()
while true; do
  page_file="/$output_folder/${user}/${page}.json"
  files+=("$page_file")
  if [[ ! -f "$page_file" ]]; then
    echo "Downloading ${url}..."
    curl -s "${url}" -o "${page_file}"
  fi
  next="$(jq -r .next "${page_file}")"

  if [[ "$next" == 'null' ]]; then
    break
  fi

  page=$((page + 1))
  url="$next"
done

jq -r -s '[.[].data.[]]' "${files[@]}" | jq . >"$output_folder/${user}.json"
playlists="$(jq -r '.[] | [.id, .tracklist, . | tojson] | @tsv' "$output_folder/${user}.json")"
echo "[]" >"$output_folder/${user}/playlists.json"

while IFS= read -r playlist; do
  page=1
  files=()
  title="$(echo "${playlist}" | cut -d$'\t' -f1)"
  url="$(echo "${playlist}" | cut -d$'\t' -f2 | tr -d '"')"
  data="$(echo "${playlist}" | cut -d$'\t' -f3)"
  while true; do
    playlist_file_name="$output_folder/${user}/playlists/$title-$page.json"

    if [[ ! -f "$playlist_file_name" ]]; then
      echo "Downloading playlist $title page $page"
      curl -s "$url" -o "$playlist_file_name"
      # TODO: small timeout
    fi
    files+=("$playlist_file_name")
    url="$(jq -r .next "${playlist_file_name}")"

    if [[ "$url" == 'null' ]]; then
      break
    fi

    page=$((page + 1))
  done
  set -x
  # jq -r -s '[.[0].data.[]]' "${files[@]}" \
  jq -r -s '[.[0].data.[]]' "${files[@]}" | jq -r '. | {tracks:.}' \
    >"$output_folder/${user}/playlists/$title.json"
  echo "$(jq -r --argjson playlist "$data" '.playlist = $playlist' "$output_folder/${user}/playlists/$title.json"))" >"$output_folder/${user}/playlists/$title.json"
  echo "$(jq -r --argjson playlist "$data" '. += [$playlist]' "$output_folder/${user}/playlists.json")" >"$output_folder/${user}/playlists.json"
  exit
done <<<"$playlists"
