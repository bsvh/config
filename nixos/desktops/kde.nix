{config, pkgs, lib, ...}:
let
  desktop = config.desktops.kde;
in
lib.mkIf (desktop.enable == true) {
  programs.dconf.enable = true;
  services.geoclue2.enable = true;
  services.xserver.displayManager.sddm.enable = true;

  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma5.supportDDC.enable = true;
  services.xserver.desktopManager.plasma5.useQtScaling.enable = true;

  environment.systemPackages = (with pkgs.libsForQt5; [
    sddm-kcm
  ]) ++ (with pkgs; [
    vorta
  ]);
}