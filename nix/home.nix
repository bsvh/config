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
    QT_QPA_PLATFORM = "wayland;xcb";
    NIXOS_OZONE_WL = "1";
    EDITOR = "hx";
  };
  home.shellAliases = {
    vi = "hx";
    vim = "hx";
    nvim = "hx";
  };
  home.packages = with pkgs; [
    anki
    bacon
    cachix
    emacsPgtkNativeComp
    fd
    fff
    ffmpeg
    fzf
    gcc
    hack-font
    htop
    httm
    mediainfo
    nixgl.nixGLIntel
    pandoc
    ripgrep
    rustup
    rust-analyzer
    sass
    tex
    zola
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
      pinentry-program /usr/bin/pinentry-qt
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
  home.file."custom.sh" = {
    source = ../bash_custom.sh;
    target = ".bashrc.d/custom.sh";
  };
  home.file."init.el" = {
    source = ../emacs/init.el;
    target = ".config/emacs/init.el";
  };
  home.file."early-init.el" = {
    source = ../emacs/early-init.el;
    target = ".config/emacs/early-init.el";
  };

  programs.helix.enable = true;
  programs.helix.settings = {
    theme = "monokai";
  };
  programs.helix.languages = [
    {
      name = "rust";
      config.checkOnSave = { command = "clippy"; };
    }
  ];
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
      confirm_os_window_close = "0";
    };
    theme = "Monokai";
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
      formulahendry.auto-rename-tag
      formulahendry.auto-close-tag
      kamikillerto.vscode-colorize
      matklad.rust-analyzer
      redhat.vscode-yaml
      ritwickdey.liveserver
      vscodevim.vim
    ];
   userSettings = {
     "editor.bracketPairColorization.enabled" = true;
     "editor.fontFamily" = "'Hack NF FC Ligatured', 'Hack', 'Droid Sans Mono', 'monospace', monospace";
     "editor.fontLigatures" = true;
     "editor.formatOnSave" = true;
     "editor.formatOnPaste" = true;
     "editor.guides.bracketPairs" = "active";
     "editor.inlayHints.enabled" = true;
     "editor.inlayHints.fontSize" = 10;
     "rust-analyzer.checkOnSave.command" = "clippy";
     "telemetry.telemetryLevel" = "off";
     "window.menuBarVisibility" = "toggle";
     "workbench.colorTheme" = "Default Dark+";
     "[rust]" = {
       "editor.defaultFormatter" = "rust-lang.rust-analyzer";
     };
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
