#!/usr/bin/env bash
  emacsclient -n -e "(> (length (frame-list)) 1)" | grep -q t
  if [[ "$?" == "1" || "$new_frame" == "yes" ]]; then
    emacsclient --no-wait --create-frame --alternate-editor "" ''${@}
  else
      emacsclient --no-wait --alternate-editor "" ''${@}
  fi
