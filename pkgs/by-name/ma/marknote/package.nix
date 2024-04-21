{ stdenv, fetchgit, cmake, extra-cmake-modules, qt6, kdePackages }:

stdenv.mkDerivation (finalAttrs: {
  pname = "marknote";
  version = "1.1.1";

  src = fetchgit {
    url = "https://invent.kde.org/office/marknote.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wjLFMd5yokfAtq8hYYK2KBwUjKqVL8ujzxoWY8BbizU=";
  };

  patches = [
    ./0001-Downgrade-kf.patch
  ];

  buildInputs = with qt6; [
    qtbase
  ] ++ (with kdePackages; [
    kirigami
    kirigami-addons
    qtsvg
    kdePackages.kirigami
  ]);

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdePackages.kconfig
  ];
})
