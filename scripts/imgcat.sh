#!/usr/bin/env bash

isimage() {
  filetype="$(file "$1" | cut -d " " -f 2)"
  imagetypes=(
    "GIF"
    "JPEG"
    "PNG"
  )
  [[ " ${imagetypes[*]} " =~ " ${filetype} " ]]
 }


if [ "$TERM" == "wezterm" ] && [ "$#" -eq 1 ] &&  isimage "${1}"; then
  wezterm imgcat "${1}"
else
  cat "${@}"
fi
