{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./home.nix
  ];

  nixpkgs = {
    overlays = [
      inputs.nixgl.overlay
    ];
  };

  home.packages = with pkgs; [ 
    nixgl.nixGLIntel
   ];

  fonts.fontconfig.enable = true;
}
