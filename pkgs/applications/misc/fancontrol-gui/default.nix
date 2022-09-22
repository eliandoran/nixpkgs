{ stdenv, fetchFromGitHub
, cmake, extra-cmake-modules
, qtbase, ki18n
, kauth, kdbusaddons, knotifications, kpackage, kdeclarative
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "fancontrol-gui";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "Maldela";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hJaU8SL0b6GmTONGSIzUzzbex6KxHf2Np0bCX8YSSVM=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase ki18n
    kauth kdbusaddons knotifications kpackage kdeclarative
  ];
}
