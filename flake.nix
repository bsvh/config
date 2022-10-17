{
  description = "Home Manager Configuration";

  inputs = {
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/4cec379c853658bc1eab0344b1e525e1ab3acc73";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, emacs-overlay, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ 
          inputs.emacs-overlay.overlay
          nixpkgs.legacyPackages.${system}.callPackage
            ./nix/overlays/ligatured-hack.nix {};
        ];
      };
    in {
      homeConfigurations.bsvh = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./nix/home.nix
        ];

      };
    };
}
