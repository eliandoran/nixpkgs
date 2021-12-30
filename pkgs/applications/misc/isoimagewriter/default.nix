{ stdenv, fetchgit
, cmake, extra-cmake-modules
, qt5, kdelibs4support
, qgpgme, kf5gpgmepp
}:

stdenv.mkDerivation rec {
  pname = "isoimagewriter";
  version = "0.8";
  src = fetchgit {
    url = "https://github.com/KDE/isoimagewriter.git";
    rev = "v0.8";
    sha256 = "xRj6SRcGTzPz3BMlwiK8ZEYoyfOtqcvM90JoMuEg+pI=";
  };

  nativeBuildInputs = [
    cmake extra-cmake-modules
    qt5.wrapQtAppsHook
    kdelibs4support
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qgpgme
    kf5gpgmepp
  ];
}
