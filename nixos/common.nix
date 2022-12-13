{ config, pkgs, ... }:

{
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/New_York";
  
  environment.systemPackages = with pkgs; [
    cachix
    git
    home-manager
    pciutils
    vim
    wget
  ];

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  nix.settings.trusted-users = [ "root" "bsvh" ];
}
