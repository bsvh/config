{ inputs, outputs, lib, config, pkgs, ... }:
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
  ];

  home.stateVersion = "22.11";
}
