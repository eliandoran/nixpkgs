{ rustPlatform, fetchFromGitHub, pkg-config, dbus }:

rustPlatform.buildRustPackage {
  pname = "flipper-pc-monitor-backend";
  version = "unstable-2024-01-17";

  src = fetchFromGitHub {
    owner = "TheSainEyereg";
    repo = "flipper-pc-monitor-backend";
    rev = "f1f02753d6fa0445f6a9f0bae17ca3a743aedabd";
    hash = "sha256-DGjG6z2pchIBL3uHRylQp9FUh35XSApoaqNKtxJCmTo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "xmltojson-0.1.3" = "sha256-+BDU3nihDA7f4T56IAQRgAERew52TC7hVNtXvF8IhXU=";
    };
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';
}
