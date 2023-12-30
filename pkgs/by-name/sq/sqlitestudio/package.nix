{ stdenv, fetchFromGitHub, pkg-config, libsForQt5 }:

stdenv.mkDerivation rec {
  pname = "sqlitestudio";
  version = "3.4.4";

  src = fetchFromGitHub {
    inherit version;
    owner = "pawelsalawa";
    repo = "sqlitestudio";
    rev = version;
    hash = "sha256-5oBYv8WxyfVvvqr15XApvn6P/lBxR8b6E+2acRkvX0U=";
  };

  nativeBuildInputs = [
    pkg-config
    libsForQt5.wrapQtAppsHook
    libsForQt5.qmake
  ];

  qmakeFlags = [ "SQLiteStudio3/SQLiteStudio3.pro" "DESTDIR=${placeholder "out"}/bin" ];

}
