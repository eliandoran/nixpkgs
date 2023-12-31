{ lib
, python3Packages
, fetchFromGitHub
, gettext
, gdk-pixbuf
, gobject-introspection
, wrapGAppsHook }:

python3Packages.buildPythonApplication {
  pname = "photocollage";
  version = "unstable-2023-08-21";

  src = fetchFromGitHub {
    owner = "adrienverge";
    repo = "PhotoCollage";
    rev = "d5a6f2bc7d9d6620427edc937639f384a893202c";
    hash = "sha256-hGBU/fU2CEak0s/t+YYn7io0ORKJel2GcCOmUfXULd8=";
  };

  propagatedBuildInputs = with python3Packages; [
    pillow
    pycairo
    pygobject3
  ];

  buildInputs = [
    gdk-pixbuf
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    wrapGAppsHook
  ];

  postInstall = ''
    install -D ./data/photocollage.desktop $out/share/applications/photocollage.desktop

    mkdir -p $out/share/icons/hicolor
    cp -r ./data/icons/hicolor/* $out/share/icons/hicolor
  '';

  meta = {
    description = "Graphical tool to make photo collage posters";
    homepage = "https://github.com/adrienverge/PhotoCollage";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ eliandoran ];
    platforms = lib.platforms.linux;
    mainProgram = "photocollage";
  };
}
