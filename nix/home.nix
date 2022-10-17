{ config, pkgs, ... }:

let
  user = "bsvh";
in
{
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  programs = {
    home-manager.enable = true;
  };

  home.packages = with pkgs; [
    htop
  ];
}
