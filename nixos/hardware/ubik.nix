# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "size=2G" "mode=755" ];
    };

  fileSystems."/var/logs" =
    { device = "/dev/disk/by-partlabel/EncryptedNixOS";
      fsType = "btrfs";
      options = [ "subvol=@nixos-logs" "compress=zstd" "noatime" ];
    };

  boot.initrd.luks.devices."luksdev".device = "/dev/disk/by-uuid/a84878b6-a92e-40b3-8b17-ab253964a1e7";

  fileSystems."/swap" =
    { device = "/dev/disk/by-partlabel/EncryptedNixOS";
      fsType = "btrfs";
      options = [ "subvol=@swap" "compress=zstd" "noatime" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-partlabel/EncryptedNixOS";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "noatime" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-partlabel/EncryptedNixOS";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/files" =
    { device = "/dev/disk/by-partlabel/EncryptedNixOS";
      fsType = "btrfs";
      options = [ "subvol=@files" "compress=zstd" "noatime" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-partlabel/EncryptedNixOS";
      fsType = "btrfs";
      options = [ "subvol=@persist" "compress=zstd" "noatime" ];
    };

  fileSystems."/var/lib/flatpak" =
    { device = "/dev/disk/by-partlabel/EncryptedNixOS";
      fsType = "btrfs";
      options = [ "subvol=@flatpak" "compress=zstd" "noatime" ];
    };

  fileSystems."/var/lib/libvirt" =
    { device = "/dev/disk/by-partlabel/EncryptedNixOS";
      fsType = "btrfs";
      options = [ "subvol=@libvirt" "compress=zstd" "noatime" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-partlabel/UBIKEFI";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp170s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
