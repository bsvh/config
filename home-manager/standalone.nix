{ inputs, outputs, lib, config, pkgs, ... }: {
{ inputs, outputs, lib, config, pkgs, ... }:
let
  nixGLWrap = pkg: pkgs.runCommand "${pkg.name}-nixgl-wrapper" {} ''
    mkdir $out
    ln -s ${pkg}/* $out
    rm $out/bin
    mkdir $out/bin
    for bin in ${pkg}/bin/*; do
     wrapped_bin=$out/bin/$(basename $bin)
     echo "exec ${lib.getExe pkgs.nixgl.nixGLIntel} $bin \"\$@\"" > $wrapped_bin
     chmod +x $wrapped_bin
    done
  '';
in
{
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
    (nixGLWrap obs-studio)
   ];

  fonts.fontconfig.enable = true;

  programs.kitty.package = nixGLWrap pkgs.kitty;

  home.file."gpg.conf" = {
    source = ../dotfiles/gnupg/gpg.conf;
    target = ".gnupg/gpg.conf";
  };
  home.file."gpg-agent.conf" = {
    source = ../dotfiles/gnupg/gpg-agent.conf;
    target = ".gnupg/gpg-agent.conf";
  };
  home.file."scdaemon.conf" = {
    source = ../dotfiles/gnupg/scdaemon.conf;
    target = ".gnupg/scdaemon.conf";
    text = ''
      pcsc-shared
      card-timeout 5
    '';
  };

  xdg.configFile."wezterm_host_settings" = {
    text = ''
      return {
            set_environment_variables = {
              TERMINFO_DIRS = '${config.home.profileDirectory}/share/terminfo',
              WSLENV = 'TERMINFO_DIRS',
            },
      }
    '';
    target = "wezterm/host_settings.lua";
  };
}
