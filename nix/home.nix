{ config, pkgs, ... }:

let
  user = "bsvh";
in
{
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  programs = {
    home-manager.enable = true;
    neovim = {
      enable = true;
      withPython3 = true;
      viAlias = true;
      vimAlias = true;
    };
    tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        vim-tmux-navigator
      ];
    };
  };

  home.packages = with pkgs; [
    cachix
    emacsPgtkNativeComp
    htop
    pandoc
    rustup
  ];
  home.stateVersion = "22.11";
}
