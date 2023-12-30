{ lib, stdenv, fetchFromGitHub, libsForQt5,
readline, tcl, python3 }:

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
    tcl
  ];

  buildPhase = ''
    qmake SQLiteStudio3/SQLiteStudio3.pro
    make

    qmake Plugins/Plugins.pro \
      "DEFINES += PYTHON_VERSION=${python3.pythonVersion}"
    make
  '';

  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    libsForQt5.qmake
  ];

  patches = [
    ./0001-Add-global-pro.patch
  ];

  meta = {
    description = "A free, open source, multi-platform SQLite database manager.";
    homepage = "https://sqlitestudio.pl";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ eliandoran ];
    platforms = [ "x86_64-linux" ];
  };

}
