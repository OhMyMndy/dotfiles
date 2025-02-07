#!/usr/bin/env bash

set -e
user="$1"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

output_folder="$HOME/.deezer/"
mkdir -p "$output_folder/${user}/playlists"

function add_to_cache() {
  local key="$1"
  local value="$2"
  local content="$3"

  # duckdb ~/.deezer/cache.db "insert into cache "
}

function fetch_data() {
  local page=1
  local url="https://api.deezer.com/user/${user}/playlists"
  local files=()
  while true; do
    local page_file="/$output_folder/${user}/playlists-${page}.json"
    files+=("$page_file")
    if [[ ! -f "$page_file" ]]; then
      echo "Downloading ${url}..."
      curl -s "${url}" -o "${page_file}"
    fi
    local next="$(jq -r .next "${page_file}")"

    if [[ "$page" == 1 ]]; then
      cat "$page_file" | jq -r .data >"/$output_folder/${user}/playlists.json"
    else
      cp "/$output_folder/${user}/playlists.json" /tmp/playlists.json
      jq -r -s '.[1] + .[0]["data"]' $page_file /tmp/playlists.json >"/$output_folder/${user}/playlists.json"
      rm /tmp/playlists.json
    fi
    if [[ "$next" == 'null' ]]; then
      break
    fi

    page=$((page + 1))
    url="$next"
  done

  playlists="$(jq -r '.[] | [.id, .tracklist, . | tojson] | @tsv' "$output_folder/${user}/playlists.json")"

  while IFS= read -r playlist; do
    page=1
    files=()
    title="$(echo "${playlist}" | cut -d$'\t' -f1)"
    url="$(echo "${playlist}" | cut -d$'\t' -f2 | tr -d '"')"
    data="$(echo "${playlist}" | cut -d$'\t' -f3)"
    while true; do
      playlist_file_name="$output_folder/${user}/playlists/$title/$page.json"
      mkdir -p "$output_folder/${user}/playlists/$title/"

      if [[ ! -f "$playlist_file_name" ]]; then
        echo "Downloading playlist $title page $page"
        curl -s "$url" -o "$playlist_file_name"
        # TODO: small timeout
      fi
      files+=("$playlist_file_name")
      url="$(jq -r .next "${playlist_file_name}")"

      if [[ "$page" == 1 ]]; then
        cat "$playlist_file_name" | jq -r .data >"/$output_folder/${user}/playlists/$title.json"
      else
        cp "/$output_folder/${user}/playlists/$title.json" /tmp/playlist.json
        jq -r -s '.[1] + .[0]["data"]' "$playlist_file_name" /tmp/playlist.json >"/$output_folder/${user}/playlists/$title.json"
        rm /tmp/playlist.json
      fi
      if [[ "$url" == 'null' ]]; then
        break
      fi

      page=$((page + 1))
    done
    # set -x
    # jq -r -s '[.[0].data.[]]' "${files[@]}" \
    # jq -r -s '[.[0].data.[]]' "${files[@]}" | jq -r '. | {tracks:.}' \
    # >"$output_folder/${user}/playlists/$title.json"
    # echo "$(jq -r --argjson playlist "$data" '.playlist = $playlist' "$output_folder/${user}/playlists/$title.json"))" >"$output_folder/${user}/playlists/$title.json"
    # echo "$(jq -r --argjson playlist "$data" '. += [$playlist]' "$output_folder/${user}/playlists.json")" >"$output_folder/${user}/playlists.json"
    # exit
  done <<<"$playlists"
}

# fetch_data

function fetch_artists_and_albums() {
  while IFS= read -r artist; do
    echo $artist
    mkdir -p "$output_folder/${user}/artist/"
    artist_file="$output_folder/${user}/artist/$artist.json"
    artist_albums_file="$output_folder/${user}/artist/${artist}-albums.json"

    local url="https://api.deezer.com/artist/$artist"
    if [[ ! -f "$artist_file" ]]; then
      echo "Downloading artist $artist"
      curl -s "$url" -o "$artist_file"
    fi

    local url="https://api.deezer.com/artist/$artist/albums"
    if [[ ! -f "$artist_albums_file" ]]; then
      echo "Downloading artist $artist albums"
      curl -s "$url" -o - | jq -r ".data[] | .+{ \"artist_id\": $artist }" >"$artist_albums_file"
    fi
  done <<<"$(cat "$output_folder/${user}/all-playlist-tracks.json" | jq -r '.[] | .artist' | jq -s '. | map({ (.id|tostring): . }) | add | .[] | .id')"
}

fetch_artists_and_albums

# exit

jq '.[]' ~/.deezer/${user}/playlists/*.json | jq -s | jq -r . >"$output_folder/${user}/all-playlist-tracks.json"

if [[ -f ~/.deezer/duck.db ]]; then
  rm ~/.deezer/duck.db
fi
#
# cat "$output_folder/${user}/all-playlist-tracks.json" | jq -r '.[] | .+{ "album_id": .album.id, "artist_id": .artist.id } | del(. | .album, .artist) | to_entries | unique | from_entries' | duckdb ~/.deezer/duck.db "create table track as select * from read_json('/dev/stdin')"

cat "$DIR/deezer.sql" | duckdb ~/.deezer/duck.db
# cat "$output_folder/${user}/all-playlist-tracks.json" | jq -r '.[] | .album' | jq -s '. | map({ (.id|tostring): . }) | add | .[]' | duckdb ~/.deezer/duck.db "create table album as select * from read_json('/dev/stdin')"
# duckdb ~/.deezer/duck.db "create unique index album_id_idx on album (id)"

# find ~/.deezer/4954552082/artist/ -regextype sed -regex '.*/[0-9]*\.json' -print0 | xargs -0 -I{} bash -c "cat \"{}\" | duckdb ~/.deezer/duck.db \"insert or replace into artist select * from read_json_auto('/dev/stdin')\""
jq '.' $(find ~/.deezer/4954552082/artist/ -regextype sed -regex '.*/[0-9]*\.json') | jq -s | duckdb ~/.deezer/duck.db "insert or replace into artist select * from read_json_auto('/dev/stdin')"

# cat "$output_folder/${user}/all-playlist-tracks.json" | jq -r '.[] | .artist' | jq -s '. | map({ (.id|tostring): . }) | add | .[]' | duckdb ~/.deezer/duck.db "create table artist as select * from read_json('/dev/stdin')"
# duckdb ~/.deezer/duck.db "create unique index artist_id_idx on artist (id)"

# cat "$output_folder/${user}/all-playlist-tracks.json" | jq -r '. | map({ (.id|tostring): . }) | add | .[] |  .+{ "album_id": .album.id, "artist_id": .artist.id } | del(. | .album, .artist)' | duckdb ~/.deezer/duck.db "create table track as select * from read_json('/dev/stdin')"
cat "$output_folder/${user}/all-playlist-tracks.json" |
  jq -r '. | map({ (.id|tostring): . }) | add | .[] |  .+{ "album_id": .album.id, "artist_id": .artist.id } | del(. | .album, .artist)' |
  duckdb ~/.deezer/duck.db "INSERT OR REPLACE INTO track SELECT * FROM read_json_auto('/dev/stdin')"
# duckdb ~/.deezer/duck.db "create unique index track_id_idx on track (id)"

jq '.data[]' $(find ~/.deezer/4954552082/artist/ -regextype sed -regex '.*/[0-9]*-albums\.json') | jq -s | jq '. |  map({ (.id|tostring): . }) | add | .[]' | duckdb ~/.deezer/duck.db "insert or replace into album select * from read_json_auto('/dev/stdin')"

cat "$output_folder/${user}/playlists.json" | duckdb ~/.deezer/duck.db "INSERT OR REPLACE INTO playlist select * from read_json_auto('/dev/stdin')"
# cat "$output_folder/${user}/playlists.json" | duckdb ~/.deezer/duck.db "create table playlist as select * from read_json('/dev/stdin')"
# duckdb ~/.deezer/duck.db "create unique index playlist_id_idx on playlist (id)"
