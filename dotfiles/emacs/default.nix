
{ config, pkgs,  ... }:

{
  programs.emacs.extraPackages = epkgs: [ 
    epkgs.esup
    epkgs.expand-region
    epkgs.hide-mode-line
    epkgs.markdown-mode
    epkgs.mixed-pitch
    epkgs.modus-themes
    epkgs.move-text
    epkgs.nix-mode
    epkgs.org-bullets
    epkgs.org-modern
    epkgs.python-black
    epkgs.pyvenv
    epkgs.rustic
    epkgs.use-package
    epkgs.writegood-mode
    epkgs.writeroom-mode
    epkgs.yuck-mode
   ];
}
