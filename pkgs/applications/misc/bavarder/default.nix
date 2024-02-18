{ stdenv
, lib
, fetchFromGitHub
, appstream-glib
, blueprint-compiler
, desktop-file-utils
, glib
, gettext
, gobject-introspection
, libadwaita
, meson
, ninja
, pkg-config
, python3Packages
, wrapGAppsHook4
, libportal-gtk4
, gtksourceview5
}:

python3Packages.buildPythonApplication rec {
  pname = "bavarder";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Bavarder";
    repo = "Bavarder";
    rev = version;
    hash = "sha256-Ip0MFTxfJnI4C6W5a3CRZ3wGSykn+ONKNA5oFfvA/fg=";
  };

  format = "other";
  dontWrapGApps = true;

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    gettext
    glib
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    libportal-gtk4
    gtksourceview5
  ];

  propagatedBuildInputs = with python3Packages; [
    babel
    baichat-py
    lxml
    pygobject3
    requests
    openai
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://github.com/Bavarder/Bavarder";
    description = "Chit-chat with GPT ";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ _0xMRTT ];
  };
}
