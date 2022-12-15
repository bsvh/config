# iso.nix
{ config, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    firefox
    keepassxc
    nvme-cli
    wget
    vim
    git
    tmux
    gparted
    gnupg
    pinentry-gnome
    ccid
    pcsclite
    pcsctools
    just
  ];
}
