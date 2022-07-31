{ pkgs, stdenv, lib, fetchFromGitHub,
  dataDir ? "/var/lib/firefly-iii" }:

let
  package = (import ./composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
    noDev = true;
  }).overrideAttrs (attrs : {
    installPhase = attrs.installPhase + ''
      rm -R $out/storage
      ln -s ${dataDir}/storage $out/storage
      ln -s ${dataDir}/.env $out/.env
    '';
  });
in
  package.override rec {
    pname = "firefly-iii";
    version = "5.7.10";

    src = fetchFromGitHub {
      owner = "firefly-iii";
      repo = pname;
      rev = version;
      sha256 = "sha256-3Om3FP431oGt008Bagf7TUc4RNtRLWQj/c3BE0gtvWQ=";
    };

    meta = with lib; {
      description = "A free and open source personal finance manager";
      longDescription = ''
        "Firefly III" is a (self-hosted) manager for your personal finances.
        It can help you keep track of your expenses and income, so you can spend less and save more.

        More information can be found on the official website at https://firefly-iii.org.
      '';
      homepage = "https://firefly-iii.org";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ eliandoran ];
      platform = platforms.linux;
    };
  }
