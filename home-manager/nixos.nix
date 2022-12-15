{ inputs, outputs, lib, config, pkgs, ... }:
let
  obsp = pkgs.obs-studio-plugins;
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

  home.packages = with pkgs; [
    anki
    arduino
    audacity
    celluloid
    easyeffects
    ffmpeg-full
    firefox
    foliate
    freetube
    gimp-with-plugins
    inkscape-with-extensions
    keepassxc
    mpv
    nicotine-plus
    obs-studio
    obsp.wlrobs
    obsp.obs-gstreamer
    obsp.input-overlay
    obsp.obs-pipewire-audio-capture
    pavucontrol
    picard
    qbittorrent
    super-slicer
    thunderbird
    vorta
    yt-dlp
  ];

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
