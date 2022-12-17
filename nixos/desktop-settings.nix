{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    desktops.useGnome = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable the GNOME desktop environment.
      '';
    };
    desktops.useHyprland = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable the Hyprland desktop environment.
      '';
    };
    desktops.useKde = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable the KDE desktop environment.
      '';
    };
  };
}