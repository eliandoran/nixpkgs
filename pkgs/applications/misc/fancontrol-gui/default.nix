{ stdenv, fetchFromGitHub
, cmake, extra-cmake-modules
, qtbase, ki18n
, kauth, kdbusaddons, knotifications, kpackage, kdeclarative
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "fancontrol-gui";
  version = "unstable-2022-06-06";

  src = fetchFromGitHub {
    owner = "Maldela";
    repo = pname;
    rev = "5bfa8fa9c880db2374c75d2d25107da3926b8f29";
    sha256 = "sha256-n5Rl5fedZLtc1d2q9IWjwyc/gLaym2mcCxcxFe9sPIk=";
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
