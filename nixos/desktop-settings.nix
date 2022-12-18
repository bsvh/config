{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    desktops.gnome = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the GNOME desktop environment.
        '';
      };
      swapEscape = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Swap the caps lock key with the escape key.
        '';
      };
      terminalCommand = mkOption {
        type = types.str;
        default = "kitty";
        description = ''
          Command to run to invoke a terminal.
        '';
      };
      terminalCommandLight = mkOption {
        type = types.str;
        default = "kitty -c ${config.xdg.configHome}/kitty-light.conf";
        description = ''
          Command to run to invoke a terminal.
        '';
      };
    };
    desktops.hyprland = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the hyprland desktop environment.
        '';
      };
    };
    desktops.kde = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the KDE desktop environment.
        '';
      };
    };
  };
}