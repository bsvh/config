{ config, pkgs, hyprland, lib, ... }:

let
  qt = pkgs.libsForQt5;
in
lib.mkIf (config.desktops.hyprland.enable == true) {
  environment.systemPackages = (with pkgs; [
    adwaita-qt
    breeze-qt5
    dex
    gnome.adwaita-icon-theme
    hyprpaper
    light
    lxqt.pavucontrol-qt
    mako
t
    wofi
    waybar
  ]) ++ (with pkgs.libForQt5; [
    dolphin
    qt5ct
    polkit-qt
  ]);
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
