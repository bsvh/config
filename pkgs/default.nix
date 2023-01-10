{ pkgs ? (import ../nixpkgs.nix) {} }: {
  hack-ligatured = pkgs.callPackage ./hack-ligatured {};
  framework-ectool = pkgs.callPackage ./framework-ectool {};
}
