function hx
    if test -n "$LIGHT_TERMINAL_THEME"
        command hx -c /home/bsvh/.config/helix/light-config.toml $argv;
    else
        command hx $argv;
    end
end
