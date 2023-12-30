{ stdenv, fetchFromGitHub, libsForQt5, readline }:

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

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qttools
    readline
  ];

  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    libsForQt5.qmake
  ];

  qmakeFlags = [
    "SQLiteStudio3/SQLiteStudio3.pro"
  ];

}
