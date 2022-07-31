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
  }
