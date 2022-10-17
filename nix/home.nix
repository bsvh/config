{ config, pkgs, lib, ... }:

let
  user = "bsvh";
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
    dvisvgm
    dvipng
    wrapfig
    amsmath
    ulem
    hyperref
    capt-of;
  });
in
{
  fonts.fontconfig.enable = true;
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  home.packages = with pkgs; [
    cachix
    emacsPgtkNativeComp
    fd
    hack-font
    htop
    pandoc
    ripgrep
    rustup
    tex
  ];
  home.file."gpg.conf" = {
    source = ../gnupg/gpg.conf;
    target = ".gnupg/gpg.conf";
  };
  home.file."gpg-agent.conf" = {
    source = ../gnupg/gpg-agent.conf;
    target = ".gnupg/gpg-agent.conf";
  };
  home.file."scdaemon.conf" = {
    source = ../gnupg/scdaemon.conf;
    target = ".gnupg/scdaemon.conf";
  };

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
    settings = {
      format = lib.concatStrings [
        "[┌───────────────────> ](bold green)"
        "$all"
        "$line_break"
        "[│](bold green) $directory"
        "$line_break"
        "[└─$character](bold green) "
      ];
      continuation_prompt = "▶▶";
      directory = {
        truncation_length = 5;
        truncation_symbol = "…/";
      };
      character = {
        success_symbol = ">";
        error_symbol = ">";
      };
    };
  };
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g mouse on
    '';
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
    ];
  } ;
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      matklad.rust-analyzer
      redhat.vscode-yaml
      vscodevim.vim
    ];
    userSettings = {
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "'Hack', 'Droid Sans Mono', 'monospace', monospace";
    };
  };

  home.stateVersion = "22.11";
}
