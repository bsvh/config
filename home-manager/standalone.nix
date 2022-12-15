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
