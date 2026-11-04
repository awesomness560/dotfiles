#!/usr/bin/env bash
ws=$(niri msg --json workspaces)
wins=$(niri msg --json windows)

entries=""
for n in 1 2 3 4 5 6 7 8 9; do
  id=$(jq -r --arg n "$n" '.[] | select(.name==$n) | .id' <<<"$ws")
  if [ -n "$id" ]; then
    count=$(jq --argjson id "$id" '[.[] | select(.workspace_id==$id)] | length' <<<"$wins")
  else
    count=0
  fi
  entries+="$n  ($count)\n"
done

sel=$(echo -e "$entries" | rofi -dmenu -i -p "" \
  -theme-str 'window { width: 22em; } listview { columns: 3; lines: 3; fixed-columns: true; spacing: 0.5em; } element { orientation: vertical; padding: 1.5em 0.5em; } element-text { horizontal-align: 0.5; }' |
  awk '{print $1}')

[ -n "$sel" ] && niri msg action focus-workspace "$sel"
