#!/bin/fish

# Uses fish event handlers to emit OSC codes
# See: https://fishshell.com/docs/current/language.html#event
#      https://fishshell.com/docs/current/cmds/function.html#cmd-function

status is-interactive || exit 0
function __wezterm_mark_prompt_start --on-event fish_prompt --on-event fish_cancel --on-event fish_posterror
    test "$__wezterm_prompt_state" != prompt-start
    and echo -en "\e]133;D\a"
    set --global __wezterm_prompt_state prompt-start
    echo -en "\e]133;A\a"
end
__wezterm_mark_prompt_start

function __wezterm_mark_output_start --on-event fish_preexec
    set --global __wezterm_prompt_state pre-exec
    echo -en "\e]133;C\a"
end

function __wezterm_mark_output_end --on-event fish_postexec
    set --global __wezterm_prompt_state post-exec
    echo -en "\e]133;D;$status\a"
end
