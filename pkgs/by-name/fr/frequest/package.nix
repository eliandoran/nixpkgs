{ lib, stdenv, fetchFromGitHub, qt5 }:

let
  version = "1.2a";

  src = fetchFromGitHub {
    owner = "fabiobento512";
    repo = "FRequest";
    rev = "v${version}";
    hash = "sha256-fdn3MK5GWBOhJjpMtRaytO9EsVzz6KJknDhqWtAyXCc=";
  };

  commonLibsSrc = fetchFromGitHub {
    owner = "fabiobento512";
    name = "CommonLibs";
    repo = "CommonLibs";
    rev = "d3906931bb06ddf4194ff711a59e1dcff80fa82f";
    hash = "sha256-iLJJ95yJ+VjNPuk8fNEDvYBI0db0rcfJF12a9azGv1Y=";
  };

  commonUtilsSrc = fetchFromGitHub {
    owner = "fabiobento512";
    name = "CommonUtils";
    repo = "CommonUtils";
    rev = "53970984f6538d78350be1b9426032bcb5bcf818";
    hash = "sha256-nRv9DriSOuAiWhy+KkOVNEz5oSgNNNJZqk8sNwgbx8U=";
  };

in stdenv.mkDerivation {

  pname = "frequest";
  version = version;

  srcs = [
    src
    commonLibsSrc
    commonUtilsSrc
  ];
  sourceRoot = src.name;

  buildInputs = [
    qt5.qtbase
  ];

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    qt5.qmake
  ];

  installPhase = ''
    install -D FRequest $out/bin/FRequest
    install -D LinuxAppImageDeployment/frequest.desktop $out/share/applications/frequest.desktop
    install -D LinuxAppImageDeployment/frequest_icon.png $out/share/icons/hicolor/128x128/apps/frequest_icon.png
  '';

  meta = {
    description = "A fast, lightweight and opensource desktop application to make HTTP(s) requests";
    homepage = "https://fabiobento512.github.io/FRequest";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ eliandoran ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "frequest";
  };

}
