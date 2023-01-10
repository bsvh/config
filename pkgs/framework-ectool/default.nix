{ stdenv, lib, fetchFromGitHub, pkg-config, libftdi, libusb1, bash, nettools }:


stdenv.mkDerivation rec {
  pname = "framework-ectool";
  version = "rev54c1403";

  src = fetchFromGitHub {
    owner = "DHowett";
    repo = "framework-ec";
    rev = "54c140399bbc3e6a3dce6c9f842727c4128367be";
    sha256 = "0zgydcnavrlaxnjci6yyqacdswi00irkvmcn9aa0yw1k7qbqkmys";
  };

  #nativeBuildInputs = [ inetutils ];
  nativeBuildInputs = [ pkg-config bash nettools ];
  buildInputs = [
    libftdi
    libusb1
  ];
  dontConfigure = true;

  postPatch = ''
    patchShebangs --build util/getversion.sh
  '';

  buildPhase = ''
    make utils PREFIX=${placeholder "out"}
  '';

  installPhase = ''
    install -Dm755 $out/util/ectool $out/bin/ectool
    printf "#!/bin/bash\n$out/bin/ectool --interface=fwk \$@" > "$out/bin/fw-ectool"
    chmod +x $out/bin/fw-ectool
  '';

  meta = with lib; {
    description = "Firmware interface tool for the Framework laptop.";
    homepage = "https://www.howett.net/posts/2021-12-framework-ec/#software";
    license = licenses.bsd3;
    platforms = platforms.x86_64;
    maintainers = with maintainers; [ bsvh ];
  };
}
