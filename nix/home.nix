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
  home.sessionVariables = {
    RUSTUP_HOME = "$HOME/.local/sdk/rust/rustup";
    CARGO_HOME = "$HOME/.local/sdk/rust/cargo";
    CARGO_ENV = "$HOME/.local/sdk/rust/cargo/env";
  };
  home.packages = with pkgs; [
    anki
    bacon
    cachix
    emacsPgtkNativeComp
    fd
    gcc
    hack-font
    htop
    nixgl.nixGLIntel
    pandoc
    ripgrep
    rustup
    rust-analyzer
    tex
  ];

  home.file."gpg.conf" = {
    target = ".gnupg/gpg.conf";
    text = ''
      no-comments
      no-emit-version
      no-greeting
      keyid-format 0xlong
      list-options show-uid-validity
      verify-options show-uid-validity
      with-fingerprint
      use-agent
    '';
  };
  home.file."gpg-agent.conf" = {
    target = ".gnupg/gpg-agent.conf";
    text = ''
      pinentry-program /usr/bin/pinentry-gnome3
      enable-ssh-support
    '';
  };
  home.file."scdaemon.conf" = {
    target = ".gnupg/scdaemon.conf";
    text = ''
      pcsc-shared
      card-timeout 5
    '';
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.helix.enable = true;
  programs.helix.settings = {
    theme = "autumn";
  };
  programs.home-manager.enable = true;
  programs.fish = {
    enable = true;
    functions = {
      mkcd = "mkdir -p $argv[1] && cd $argv[1]";
    }; 
  };
  programs.git = {
    enable = true;
    userName = "Brendan Van Hook";
    userEmail = "brendan@vastactive.com";
  };
  programs.kitty = {
    enable = true;
    settings = {
      font_size = "12.0";
      font_family = "Hack Nerd Font FC Ligatured";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      hide_window_decorations = true;
      window_padding_width = "6";
      theme = "Monokai";
      include =  "./theme.conf";
      confirm_os_window_close = "0";
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
     "editor.fontFamily" = "'Hack NF FC Ligatured', 'Hack', 'Droid Sans Mono', 'monospace', monospace";
     "editor.inlayHints.enabled" = true;
     "editor.formatOnSave" = true;
     "editor.formatOnPaste" = true;
     "workbench.colorCustomizations" = {
       "[Default Dark+]" = {
         "editorInlayHint.background" = "#1e1e1e";
         "editorInlayHint.foreground" = "#6e6d6d";
       };
     };
   };
  };

  home.stateVersion = "22.11";
}
