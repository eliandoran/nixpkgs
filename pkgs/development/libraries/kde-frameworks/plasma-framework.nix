{
  mkDerivation, fetchpatch,
  extra-cmake-modules, kdoctools,
  kactivities, karchive, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons,
  kdeclarative, kglobalaccel, kguiaddons, ki18n, kiconthemes, kio,
  knotifications, kpackage, kservice, kwayland, kwindowsystem, kxmlgui,
  qtbase, qtdeclarative, qtscript, qtx11extras, kirigami2, qtquickcontrols2
}:

mkDerivation {
  name = "plasma-framework";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kactivities karchive kconfig kconfigwidgets kcoreaddons kdbusaddons
    kdeclarative kglobalaccel kguiaddons ki18n kiconthemes kio knotifications
    kwayland kwindowsystem kxmlgui qtdeclarative qtscript qtx11extras kirigami2
    qtquickcontrols2
  ];
  propagatedBuildInputs = [ kpackage kservice qtbase ];
  patches = [
    # patches included in 5.91, fix activity panel pushing windows in wayland
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/plasma-framework/-/commit/d40d36057a0ee9fcb4badc7ff8b56844da79dfc8.diff";
      sha256 = "09dmzx7dmcjjbw4gm3hrxbmkmqx614h6kznhvbfr9vcw88ymc6a9";
    })
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/plasma-framework/-/commit/b882b34d7b55975f679133ef86cfd12869e8bba5.diff";
      sha256 = "sha256-VcubC/rW3GZdxkpZojimGSxW/yjM645eViXYO6LxvOk=";
    })
  ];
}
