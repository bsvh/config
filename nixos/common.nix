{ config, pkgs, ... }:

{
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/New_York";

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  environment.etc = {
  	"wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
  		bluez_monitor.properties = {
  			["bluez5.enable-sbc-xq"] = true,
  			["bluez5.enable-msbc"] = true,
  			["bluez5.enable-hw-volume"] = true,
  			["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
  		}
  	'';
  };
  
  environment.systemPackages = (with pkgs; [
    anki
    arduino
    audacity
    cachix
    easyeffects
    element-desktop-wayland
    firefox-wayland
    font-manager
    freetube
    fsearch
    gimp-with-plugins
    git
    home-manager
    inkscape-with-extensions
    keepassxc
    lshw
    mpv
    nicotine-plus
    obs-studio
    usbutils
    pciutils
    picard
    qbittorrent
    thunderbird
    unzip
    vim
    wget
    yt-dlp
  ]) ++ (with pkgs.obs-studio-plugins; [
    wlrobs
    obs-gstreamer
    input-overlay
    obs-pipewire-audio-capture
  ]) ++ (with pkgs.gst_all_1; [
    gstreamer
    gst-vaapi
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    hack-font
    montserrat
    stix-two
    crimson
    alegreya
    iosevka-bin
    cantarell-fonts
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    libsForQt5.breeze-icons
  ];
  fonts.fontDir.enable = true;

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;
  services.flatpak.enable = true;
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.openFirewall = true;
  services.ipp-usb.enable = true;
  services.udisks2.enable = true;

  nix.settings.trusted-users = [ "root" "bsvh" ];
}
