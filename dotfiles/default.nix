{ config,  ... }:

{
  imports = [ 
    ./emacs
    ./gnome
    ./hypr
   ];
  xdg.configFile = {
    "early-init.el" = {
      source = emacs/early-init.el;
      target = "emacs/early-init";
    };
    "init.el" = {
      source = emacs/init.el;
      target = "emacs/init";
    };
    "helix" = {
        source = helix/config.toml;
        target = "helix/config.toml";
    };
    "helix-light" = {
        source = helix/light-config.toml;
        target = "helix/light-config.toml";
    };
    "helix-languages" = {
      source = helix/languages.toml;
      target = "helix/languages.toml";
    };
    "wezterm" = {
      source = wezterm/wezterm.lua;
      target = "wezterm/wezterm.lua";
    };
    "wezterm-host" = {
      source = wezterm/host_settings.lua;
      target = "wezterm/host_settings.lua";
    };
    "mkcd" = {
      source = fish/functions/mkcd.fish;
      target = "fish/functions/mkcd.fish";
    };
    "edwin" = {
      source = fish/functions/edwin.fish;
      target = "fish/functions/edwin.fish";
    };
    "helix-alias" = {
      source = fish/functions/hx.fish;
      target = "fish/functions/hx.fish";
    };
    "starship" = {
      source = starship/starship.toml;
      target = "starship.toml";
    };
    "vscodium" = {
      source = vscodium/settings.json;
      target = "VSCodium/User/settings.json";
    };
  };
  
  home.file.bash_custom = {
    source = bash/bash_custom.sh;
    target = ".bashrc.d/bash_custom";
  };
}
