{ pkgs, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, glib, rustPlatform
, appstream-glib, desktop-file-utils
, tdlib
, gtk4, libadwaita
}:

let
  tdlib_1_8_2 = pkgs.tdlib.overrideAttrs (oldAttrs: rec {
    version = "1.8.2";
    src = fetchFromGitHub {
      owner = "tdlib";
      repo = "td";
      rev = "3f54c301ead1bbe6529df4ecfb63c7f645dd181c";
      sha256 = "sha256-QeybMazyjtcc01fFKdzEv4jVaIFULRAzCTYdlpGyhzk=";
    };
    cargoSha256 = "8afe1ec42c3ac6a47f9e1f8edd7796b026cb80625cb9eb993a72c70a083efb13";
  });
in stdenv.mkDerivation rec {
  pname = "telegrand";
  version = "unstable-2022-11-19";

  src = fetchFromGitHub {
    owner = "melix99";
    repo = "telegrand";
    rev = "426ab4130152971d58846ca69dfff3f21eb1385d";
    sha256 = "sha256-DYYlzkQDKmqY+hfvZOQvFjAm7Jnh63PgyBDZyAdHbAA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
    appstream-glib # appstream-util
    desktop-file-utils # update-desktop-database
  ] ++ (with rustPlatform; [
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    gtk4
    libadwaita
    tdlib_1_8_2
  ];
}