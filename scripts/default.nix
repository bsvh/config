{ config,  ... }:

{
  home.file."imgcat.sh" = {
    source = ./imgcat.sh;
    target = ".local/bin/imgcat";
    executable = true;
  };
}
