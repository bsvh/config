function hx
    if test $LIGHT_TERMINAL_THEME -eq 1
        command hx -c /home/bsvh/.config/helix/light-config.toml $argv;
    else
        command hx $argv;
    end
end
