{ lib, fetchzip }:

let
  version = "3.003";
  fc_version = "3.1";
  jbm_version = "2.242";
  nerd_version = "2.1";
in fetchzip {
  name = "ligatured-hack-font-${version}";

  url = "https://github.com/gaplo917/Ligatured-Hack/releases/download/v${version}/Hack-v${version}+Nerdv${nerd_version}+FC${fc_version}+JBMv${jbm_version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/hack
  '';

  sha256 = "e99bb3f5ff2b42802d1c6d415630acf683dd49588284b8b4744c54b823d68405";

  meta = with lib; {
    description = "A typeface designed for source code";
    longDescription = ''
      Hack is hand groomed and optically balanced to be a workhorse face for
      code. It has deep roots in the libre, open source typeface community and
      expands upon the contributions of the Bitstream Vera & DejaVu projects.
      The face has been re-designed with a larger glyph set, modifications of
      the original glyph shapes, and meticulous attention to metrics.
    '';
    homepage = "https://github.com/gaplo917/Ligatured-Hack";

    /*
     "The font binaries are released under a license that permits unlimited
      print, desktop, and web use for commercial and non-commercial
      applications. It may be embedded and distributed in documents and
      applications. The source is released in the widely supported UFO format
      and may be modified to derive new typeface branches. The full text of
      the license is available in LICENSE.md" (From the GitHub page)
    */
    license = licenses.free;
    #maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
