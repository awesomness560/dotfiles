#!/usr/bin/env bash

if pkill -INT wf-recorder; then
  noctalia msg notification-show "Recording" -- "Saved to ~/Videos"
  exit 0
fi

region=$(slurp) || exit 0
mkdir -p ~/Videos
out=~/Videos/rec-$(date +%F-%H%M%S).mp4

noctalia msg notification-show "Recording" -- "Started"
wf-recorder -g "$region" -f "$out"
