{ inputs, outputs, lib, config, pkgs, ... }:
let
  obsp = pkgs.obs-studio-plugins;
  qt = pkgs.libsForQt5;
in
{
  imports = [
    ./home.nix
  ];

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  desktops.gnome.enable = true;
  desktops.gnome.swapEscape = false;

  xdg.enable = true;
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
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_QPA_PLATFORM="wayland;xcb";
  };

  home.packages = with pkgs; [
  ];

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    gtk.enable = true;
  };

  programs.bash.enable = true;
  programs.bash.enableCompletion = true;
  programs.bash.initExtra = ''
  if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && $(which fish 2>/dev/null) && -z ''${BASH_EXECUTION_STRING} ]]; then
  	exec env SHELL=fish fish
  fi
  '';
  
  programs.gpg = {
    enable = true;
    mutableKeys = true;
    mutableTrust = true;
    publicKeys = [
      { 
        source = ../dotfiles/gnupg/pubkey_curve25519.asc;
        trust = "ultimate";
      }
      { 
        source = ../dotfiles/gnupg/pubkey_rsa.asc;
        trust = "ultimate";
      }
    ];
    settings = {
      no-comments = true;
      no-emit-version = true;
      no-greeting = true;
      keyid-format ="0xlong";
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      with-fingerprint = true;
    };
    scdaemonSettings = {
      disable-ccid = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
    enableScDaemon = true;
    enableSshSupport = true;
  };

  home.stateVersion = "22.11";
}
