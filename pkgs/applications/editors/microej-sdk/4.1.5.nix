{ openjdk8, gtk2, callPackage }:

callPackage (import ./common.nix rec {
  version = "4.1.5";
  sha256 = "sha256-EaaukOzFwUB6A8vBneF1JDIFrH/ENu/EFjQkITdU518=";
  jdk = openjdk8;
  gtk = gtk2;
}) {}