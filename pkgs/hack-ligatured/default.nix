{ stdenv, lib, fetchurl, unzip }:

let
  # Hack Font Version
  hv = "3.003";

  # Fira Code Version
  fcv = "3.1";

  # Jet Brains Mono Version
  jbmv = "2.242";

  #Nerd Version
  nv = "2.1.0";

  # Github stuff
  release = "v${hv}+Nv${nv}+FC+JBMv${jbmv}";
  ghuser = "gaplo917";
  repo = "Ligatured-Hack";

in stdenv.mkDerivation rec {
  pname = "hack-ligatured";
  version = "v${hv}+FC${fcv}+JBMv${jbmv}";

  src = fetchurl {
    url = "https://github.com/${ghuser}/${repo}/releases/download/${release}/HackLigatured-${version}.zip";
    sha256 = "01c4sqivhm2cfjsbi142b14xv0znmhq5chbd3hnq0hibzzsv76z9";
  };

  nativeBuildInputs = [ unzip ];
  dontInstall = true;

  unpackPhase = ''
    mkdir -p $out/share/fonts
    unzip -d $out/share/fonts/truetype $src \*.ttf -x __MACOSX/\*
  '';

  meta = with lib; {
    description = "The hack font patched with ligatures.";
    longDescription = ''
      Hack is hand groomed and optically balanced to be a workhorse face for
      code. It has deep roots in the libre, open source typeface community and
      expands upon the contributions of the Bitstream Vera & DejaVu projects.
      The face has been re-designed with a larger glyph set, modifications of
      the original glyph shapes, and meticulous attention to metrics.

      This version is patched to use ligatures from Fira Code and Jet Brains
      Mono as well as font symbols from Nerd font.
    '';
    homepage = "https://github.com/${ghuser}/${repo}/";
    license = licenses.free;
    platforms = platforms.all;
    maintainers = with maintainers; [ bsvh ];
  };
}
