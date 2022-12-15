{
  description = "bsvh's NixOS and Home Manager Configuration";

  nixConfig.substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    "https://helix.cachix.org"
    "https://hyprland.cachix.org"
  ];
  nixConfig.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
  ];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:guibou/nixGL";
    helix.url = "github:helix-editor/helix";
    hyprland.url = "github:hyprwm/Hyprland";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, impermanence, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    in 
    rec {
      nixosConfigurations = {
        testbox = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs hyprland; };
          modules = [
            ./nixos/testbox.nix
          ];
        };
        ubik = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs hyprland; };
          modules = [
            ./nixos/ubik.nix
            inputs.nixos-hardware.nixosModules.framework
          ];
        };
      };
      homeConfigurations = {
        standalone = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };

          modules = [
            ./home-manager/standalone.nix
          ];
        };
        nixos = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };

          modules = [
            ./home-manager/nixos.nix
            hyprland.homeManagerModules.default
          ];
        };
      };
    };
}
