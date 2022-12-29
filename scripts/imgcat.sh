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

if which timg >/dev/null 2>&1; then
  imgcat=timg
elif [ "${TERM}" == "wezterm" ]; then
  imgcat="wezterm imgcat"
elif [ "${TERM}" == "xterm-kitty" ]; then
  imgcat="kitty +kitten icat"
else
  echo "No available terminal image viewer"
fi


if [ "$#" -eq 1 ] &&  isimage "${1}"; then
  $imgcat "${1}"
else
  cat "${@}"
fi
