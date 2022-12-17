{ config, pkgs, hyprland, ... }:

let
  qt = pkgs.libsForQt5;
in
{
  environment.systemPackages = with pkgs; [
    adwaita-qt
    breeze-qt5
    dex
    gnome.adwaita-icon-theme
    hyprpaper
    light
    lxqt.pavucontrol-qt
    mako
    qt.dolphin
    qt.qt5ct
    qt.polkit-qt
    wofi
    waybar
  ];
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPT_PLATFORMTHEME = "qt5ct";
  };

  programs.hyprland.enable = true;

  security.pam.services.swaylock = {
    text = "auth include login";
  };
  
  nix.settings.trusted-users = [ "root" "bsvh" ];
}
