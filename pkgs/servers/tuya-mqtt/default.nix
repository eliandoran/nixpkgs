{ pkgs, nodejs, fetchFromGitHub, ... }:

let
  nodePackages = import ./composition.nix { inherit pkgs; };
in nodePackages.package.override {
  src = fetchFromGitHub {
    owner = "TheAgentK";
    repo = "tuya-mqtt";
    rev = "v3.0.4";
    sha256 = "sha256-0rPjd8YEKSnn7J5ld2oNQ7pfONuCv+TJUD4/MwkoP9Q=";
  };

  preRebuild = ''
    substituteInPlace tuya-mqtt.js --replace \
      "CONFIG = require('./config')" \
      "CONFIG = JSON.parse(fs.readFileSync('./config.json', 'utf-8'));"
  '';

  postInstall = ''
    # Build an executable since the upstream package.json file does not have a "bin" entry.
    mkdir -p $out/bin

    cat <<EOF > $out/bin/tuya-mqtt
    #!/bin/sh
    exec ${nodejs}/bin/node $out/lib/node_modules/tuya-mqtt/tuya-mqtt.js "\$@"
    EOF

    chmod +x $out/bin/tuya-mqtt
  '';
}
