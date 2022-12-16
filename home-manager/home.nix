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
  imports = [ 
    ../dotfiles
    ../scripts
  ];
  nixpkgs = {
    overlays = [
      inputs.emacs-overlay.overlay
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

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
    vim = "hx";
    nvim = "hx";
  };
  home.packages = with pkgs; [
    anki
    bacon
    cachix
    fd
    fff
    ffmpeg-full
    fzf
    gcc
    hack-font
    htop
    httm
    iosevka-bin
    just
    mediainfo
    meld
    mitscheme
    pandoc
    ripgrep
    rustup
    rust-analyzer
    sass
    tex
    timg
    wezterm
    zola
  ];
  programs.fish.enable = true;
  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacsPgtk;
  programs.helix.enable = true;
  programs.helix.package = inputs.helix.packages."x86_64-linux".default;
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Brendan Van Hook";
    userEmail = "brendan@vastactive.com";
    diff-so-fancy.enable = true;
    extraConfig = {
      merge.tool = "meld";
      mergetool.meld = {
        cmd = ''
          meld "$LOCAL" "$BASE" "$REMOTE" --output "$MERGED"
        '';
      };
    };
  };
  programs.starship = {
    enable = true;
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
  };
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
  };

  xdg.configFile."stop-gnome-ssh" = {
    target = "autostart/gnome-keyring-ssh.desktop";
    text = ''
      [Desktop Entry]
      Type=Application
      Name=SSH Key Agent
      Comment=Prevent gnome-keyring from using ssh
      OnlyShowIn=GNOME;Unity;MATE;
      Hidden=true
    '';
  };

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "22.11";
}
