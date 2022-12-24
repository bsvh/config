{ inputs, outputs, lib, config, pkgs, ... }: {

  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./hardware/ubik.nix
    ./common.nix
    ./desktops/hyprland.nix
    ./desktops/gnome.nix
  ];

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  desktops.gnome.enable = true;
  networking.hostName = "ubik";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  zramSwap.enable = true;

  hardware.i2c.enable = true;
  services.ddccontrol.enable = true;

  hardware.bluetooth.enable = true;
  hardware.enableRedistributableFirmware = true;

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  programs.fuse.userAllowOther = true;

  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
      "/var/lib/systemd/coredump"
      "/var/lib/fprint"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  users.mutableUsers = false;
  users.users = {
    bsvh = {
      passwordFile = "/persist/system/etc/password";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJLhTCXxyCc5upLFYajiEpLZlRmBCfC44d98lC3Ooyl cardno:13 794 712"
      ];
      extraGroups = [ "wheel" "video" "networkmanager" "i2c" ];
    };
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = true;
  };
  services.fwupd.enable = true;
  
  # Desktop environment
  networking.networkmanager.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  
  environment.systemPackages = with pkgs; [
    helix
    ddcutil
    ddcui
  ];
  

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
