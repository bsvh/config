{ inputs, outputs, lib, config, pkgs, ... }: {

  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./hardware/testbox.nix
    ./common.nix
    ./desktops/hyprland.nix
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

  networking.hostName = "testbox";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
      "/var/lib/systemd/coredump"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];
    files = [
      "/etc/machine-id"
      { file = "/etc/ssh/ssh_host_ed25519_key"; mode = "u=rw,g=,o="; }
      { file = "/etc/ssh/ssh_host_rsa_key"; mode = "u=rw,g=,o="; }
      { file = "/etc/ssh/ssh_host_ed25519_key.pub"; mode = "u=rw,g=r,o=r"; }
      { file = "/etc/ssh/ssh_host_rsa_key.pub"; mode = "u=rw,g=r,o=r"; }
    ];
  };

  users.mutableUsers = false;
  users.users = {
    bsvh = {
      initialPassword = "changeme";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJLhTCXxyCc5upLFYajiEpLZlRmBCfC44d98lC3Ooyl cardno:13 794 712"
      ];
      extraGroups = [ "wheel" ];
    };
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = true;
  };
  
  # Desktop environment
  networking.networkmanager.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.videoDrivers = [ "qxl" ];
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  
  environment.systemPackages = with pkgs; [
    helix
  ];
  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
