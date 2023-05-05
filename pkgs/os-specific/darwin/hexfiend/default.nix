{ stdenv, lib, fetchurl, undmg, ... }:

stdenv.mkDerivation rec {
  version = "2.16.0";
  pname = "hexfiend";

  src = fetchurl {
    inherit version;
    url = "https://github.com/HexFiend/HexFiend/releases/download/v${version}/Hex_Fiend_2.16.dmg";
    sha256 = "sha256-jO57bW5TyuQ0mjKKsSwDoGLp2TZ1d+m159flVGaVrLc=";
  };

  sourceRoot = "Hex Fiend.app";
  buildInputs = [ undmg ];
  installPhase = ''
    mkdir -p "$out/Applications/Hex Fiend.app"
    cp -R . "$out/Applications/Hex Fiend.app"
  '';

  meta = with lib; {
    description = "Open-source macOS hex editor";
    homepage = "http://hexfiend.com/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ eliandoran ];
    platforms = [ "x86_64-darwin" ];
  };
}
