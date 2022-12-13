{ config, pkgs, ... }:

{
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/New_York";
  
  environment.systemPackages = with pkgs; [
    cachix
    git
    home-manager
    vim
    wget
  ];
  nix.settings.trusted-users = [ "root" "bsvh" ];
}
