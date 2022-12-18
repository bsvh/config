
{config, pkgs, lib, ...}:
let
  desktop = config.desktops.gnome;
in
lib.mkIf (desktop.enable == true) {
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    geary
    gnome-music
    totem
    epiphany
  ]);

  services.geoclue2.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  environment.systemPackages = (with pkgs.gnomeExtensions; [
    appindicator
    dash-to-dock
    gsconnect
    just-perfection
    night-theme-switcher
    places-status-indicator
    pop-shell
  ]) ++ (with pkgs.gnome; [
    gnome-tweaks
  ]) ++ (with pkgs; [
    amberol
    apostrophe
    blanket
    celluloid
    lollypop
    pika-backup
    video-trimmer
    wike
  ]);
}
