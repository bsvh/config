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
    desktops.kde= {
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