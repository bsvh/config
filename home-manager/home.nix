{ config, pkgs, lib, inputs, ... }:

let
  user = "bsvh";
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
    amsmath
    capt-of
    dvipng
    dvisvgm
    hyperref
    mathtools
    physics
    ulem
    wrapfig;
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
    DIRENV_LOG_FORMAT="";
  };
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/desktop";
    documents = "${config.home.homeDirectory}/documents";
    download = "${config.home.homeDirectory}/downloads";
    music = "${config.home.homeDirectory}/music";
    pictures = "${config.home.homeDirectory}/pictures";
    videos = "${config.home.homeDirectory}/videos";
    templates = "${config.home.homeDirectory}/templates";
    publicShare = "${config.home.homeDirectory}/public";
  };
  home.shellAliases = {
    vim = "hx";
    nvim = "hx";
  };
  home.packages = with pkgs; [
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
    sioyek
    tex
    timg
    yubikey-touch-detector
    wezterm
  ];
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    if test "$TERM" != dumb -a \( -z "$INSIDE_EMACS" -o "$INSIDE_EMACS" = vterm \)
        eval (/home/bsvh/.nix-profile/bin/starship init fish)
    end
    enable_transience
    set -e LIBVA_DRIVERS_PATH LIBGL_DRIVERS_PATH LD_LIBRARY_PATH __EGL_VENDOR_LIBRARY_FILENAMES
  '';
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
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };
  programs.starship = {
    enable = true;
    # Disabled here b/c need transient prompt needs to be run after starship
    # Enabled manually in fish.interactiveShellInit
    enableFishIntegration = false;
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
  xdg.configFile."start-yubikey-touch-detector" = {
    target = "autostart/yubikey-touch-detector.desktop";
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Yubikey Touch Detector
      Exec=yubikey-touch-detector -libnotify
      Comment=Start Yubikey Touch Detector
    '';
  };

  programs.kitty = {
    enable = true;
    settings = {
      font_size = "10.0";
      font_family = "Hack NF FC Ligatured";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      hide_window_decorations = true;
      window_padding_width = "6";
      confirm_os_window_close = "0";
      background = "#222222";
    };
    theme = "Monokai";
  };

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "22.11";
}
