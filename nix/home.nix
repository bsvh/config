{ config, pkgs, lib, inputs, ... }:

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
    fd
    fff
    ffmpeg
    fzf
    gcc
    hack-font
    htop
    httm
    mediainfo
    mitscheme
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
  home.file."emacsclient-open.sh" = {
    target = ".local/bin/emacsclient-open";
    executable = true;
    text = ''
    #!/usr/bin/env bash
      emacsclient -n -e "(> (length (frame-list)) 1)" | grep -q t
      if [[ "$?" == "1" || "$new_frame" == "yes" ]]; then
        emacsclient --no-wait --create-frame --alternate-editor "" ''${@}
      else
          emacsclient --no-wait --alternate-editor "" ''${@}
      fi
    '';
  };
  home.file."emacs-protocol.desktop" = {
    target = ".local/share/applications/org-protocol.desktop";
    text = ''
      [Desktop Entry]
      Name=org-protocol
      Exec=/home/bsvh/.local/bin/emacsclient-open %u
      Type=Application
      Terminal=false
      Categories=System;
      MimeType=x-scheme-handler/org-protocol;
    '';
    onChange = ''
      which update-desktop-database 2>/dev/null && update-desktop-database ~/.local/share/applications/
      which kbuildsyscoca5 2>/dev/null && kbuildsyscoca5
      xdg-mime default org-protocol.desktop x-scheme-handler/org-protocol
    '';
  };

  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacsPgtkNativeComp;
  programs.emacs.extraPackages = epkgs: [ 
    epkgs.esup
    epkgs.expand-region
    epkgs.hide-mode-line
    epkgs.markdown-mode
    epkgs.mixed-pitch
    epkgs.modus-themes
    epkgs.move-text
    epkgs.nix-mode
    epkgs.org-bullets
    epkgs.org-modern
    epkgs.python-black
    epkgs.pyvenv
    epkgs.rustic
    epkgs.use-package
    epkgs.writegood-mode
    epkgs.writeroom-mode
    epkgs.yuck-mode
   ];
  programs.helix.enable = true;
  programs.helix.package = inputs.helix.packages."x86_64-linux".default;
  programs.helix.settings = {
    theme = "monokai_pro_spectrum";
    editor.bufferline = "multiple";
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
      edwin = "mit-scheme --eval \"(edwin 'console)\"";
    };     
  };
  programs.git = {
    enable = true;
    userName = "Brendan Van Hook";
    userEmail = "brendan@vastactive.com";
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
  programs.wezterm.enable = true;
  programs.wezterm.extraConfig = ''
    return {
      enable_wayland = true,
      color_scheme = "Molokai",
      font = wezterm.font {
        family = 'Hack Nerd Font FC Ligatured',
        harfbuzz_features = { "zero", "ss01", "cv05", "calt=1", "clig=1", "liga=1" },
      },
      font_size = 11,
      use_fancy_tab_bar = false,
      hide_tab_bar_if_only_one_tab = true,
      colors = {
        background = "#222222",
      },
    }
'';

  home.stateVersion = "22.11";
}
