{ config, pkgs, ... }:

let
  user = "bsvh";
in
{
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  programs.home-manager.enable = true;
  programs.fish = {
    enable = true;
    functions = {
      mkcd = "mkdir -p $argv[1] && cd $argv[1]";
    }; 
  };
  programs.neovim = {
    enable = true;
    withPython3 = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-tmux-navigator
    ];
    extraConfig = ''
      silent !mkdir -p ~/.local/share/nvim/undo
      silent !mkdir -p ~/.local/share/nvim/backup
      silent !mkdir -p ~/.cache/nvim/backup
      set relativenumber
      set number
      set undofile
      set backup
      set undodir=~/.local/share/nvim/undo//
      set backupdir=~/.local/share/nvim/backup//
      set directory=~/.cache/nvim/swap//
    '';
  };
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
    ];
  } ;

  home.packages = with pkgs; [
    cachix
    emacsPgtkNativeComp
    htop
    pandoc
    rustup
  ];
  home.stateVersion = "22.11";
}
