status --is-interactive; and begin
    if test "$TERM" != dumb -a \( -z "$INSIDE_EMACE" -o "$INSIDE_EMACS" = vterm \)
        starship init fish
    end
end
