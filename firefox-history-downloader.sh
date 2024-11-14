#!/usr/bin/env bash

set -e

rm -f /tmp/place.sqlite
cp ~/.var/app/org.mozilla.firefox/.mozilla/firefox/*/places.sqlite /tmp/place.sqlite

echo "select distinct url from moz_places where url not like 'https://consent.google.com/%' and url not like 'https://accounts.google.com/%' and url not like 'https://login.microsoftonline.com/%' and url not like 'https://login.live.com/%' and url not like 'https://login.tailscale.com/%' and url not like '%/auth/%' and url not like 'https://auth.%' order by last_visit_date desc;" |
    sqlite3 /tmp/place.sqlite >/tmp/firefox-history.txt

output_dir="$HOME/.firefox-history"
mkdir -p "$output_dir"

# File containing URLs
url_file="/tmp/firefox-history.txt"

LAST_EXECUTED_COMMAND=
VARIABLES=
function _trap_DEBUG() {
    # echo "# $BASH_COMMAND";
    LAST_EXECUTED_COMMAND="$BASH_COMMAND"
    # while read -r -e -p "debug> " _command; do
    #     if [ -n "$_command" ]; then
    #         eval "$_command";
    #     else
    #         break;
    #     fi;
    # done
}

function _trap_ERR() {
    VARIABLES="$(
        set -o posix
        set
    )"
    echo "Variables:"
    echo $VARIABLES
    echo "ERR: $LAST_EXECUTED_COMMAND"
}

trap '_trap_DEBUG' DEBUG
trap '_trap_ERR' ERR
# Read each URL from the file
while IFS= read -r url; do
    # Clean the URL by removing the protocol (http:// or https://)
    clean_url="${url#http://}"
    clean_url="${clean_url#https://}"

    if [[ $url != http* ]]; then
        continue
    fi

    # Extract domain and path for directory structure
    domain=$(echo "$clean_url" | cut -d '/' -f 1)
    path=$(echo "$clean_url" | cut -d '/' -f 2- | sed 's/[^a-zA-Z0-9\/]/_/g')

    # Prepare directory and filename
    dir_path="$output_dir/$domain/$(dirname "$path" | sed 's/[^a-zA-Z0-9]/_/g')"
    mkdir -p "$dir_path"

    # Extract filename from the last part of the path, default to "index.html" if empty
    filename=$(basename "$path")
    [[ -z "$filename" ]] && filename="index"
    output_file="$dir_path/${filename:0:50}.html"

    # Check if the file already exists, if so, skip to the next URL
    if [[ -f "$output_file" ]]; then
        # echo "File $output_file already exists, skipping $url"
        continue
    fi
    # set -x
    # Get the content type of the URL (after cleaning it)
    output="$(curl -m5 -sIL "$url" || true)"
    content_type=$(echo "$output" | grep -i '^Content-Type:' | tail -1 | awk '{print $2}' | tr -d '\r')
    # Only proceed if the content type is HTML or plain text
    if [[ "$content_type" == text/html* || "$content_type" == text/plain* ]]; then
        # Download the page content and save it
        curl -m5 -sL "$url" -o - | sed -E "s#((href|src)=[\"'])(\.?/([^\"']+))([\"'])#\1${domain}/\4\5#g" >"$output_file" || true
        # set +x
        echo "Saved $url as $output_file"
    # else
    #     pass
    #     # echo "Skipping $url (content type: $content_type)"
    fi
done <"$url_file"
