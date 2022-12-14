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

  home.file."gpg.conf" = {
    target = ".gnupg/gpg.conf";
    text = ''
      no-comments
      no-emit-version
      no-greeting
      keyid-format 0xlong
      list-options show-uid-validity
      verify-options show-uid-validity
      with-fingerprint
      use-agent
    '';
  };
  home.file."gpg-agent.conf" = {
    target = ".gnupg/gpg-agent.conf";
    text = ''
      pinentry-program /usr/bin/pinentry-gnome3
      enable-ssh-support
      default-cache-ttl 60
      max-cache-ttl 120
    '';
  };
  home.file."scdaemon.conf" = {
    target = ".gnupg/scdaemon.conf";
    text = ''
      pcsc-shared
      card-timeout 5
    '';
  };
}
