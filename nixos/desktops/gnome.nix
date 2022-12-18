
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

  programs.dconf.enable = true;
  services.geoclue2.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  environment.systemPackages = (with pkgs.gnome; [
    gnome-tweaks
  ]) ++ (with pkgs; [
    amberol
    apostrophe
    blanket
    celluloid
    foliate
    lollypop
    pika-backup
    qgnomeplatform
    video-trimmer
    wike
  ]);

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gnome";
    QT_QPA_PLATFORM = "wayland;xcb";
  };
}
