#!/usr/bin/env bash
target="$1"

current=$(niri msg --json workspaces |
  jq -r '.[] | select(.is_focused) | (.name // (.idx|tostring))')

if [ "$current" = "$target" ]; then
  niri msg action focus-workspace-previous
else
  niri msg action focus-workspace "$target"
fi
