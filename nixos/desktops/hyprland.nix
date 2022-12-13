{ config, pkgs, hyprland, ... }:

{
  imports = [
    hyprland.nixosModules.default
  ];
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/New_York";
  
  environment.systemPackages = with pkgs; [
    cachix
    git
    home-manager
    vim
    wget
  ];

  programs.hyprland.enable = true;
  
  nix.settings.trusted-users = [ "root" "bsvh" ];
}
