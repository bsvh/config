{ pkgs ? (import ../nixpkgs.nix) {} }: {
  hack-ligatured = pkgs.callPackage ./hack-ligatured {};
}
