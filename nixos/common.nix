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
  
  environment.systemPackages = with pkgs; [
    cachix
    font-manager
    fsearch
    git
    home-manager
    lshw
    usbutils
    pciutils
    unzip
    vim
    wget
  ];

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
    iosevka
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
