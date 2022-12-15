{ config, pkgs, ... }:

{
  xdg.configFile = {
    "emacs/early-init.el" = {
      target = "emacs/early-init";
    };
    "emacs/init.el" = {
      target = "emacs/init";
    };
  }
}
