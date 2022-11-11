{ openjdk11, gtk3, callPackage }:

callPackage (import ./common.nix rec {
  version = "22.06";
  sha256 = "sha256-ZnN0O11X8/oBI6zfXHMcSxdhJ+65U4EGZULGet4GQ+c=";
  jdk = openjdk11;
  gtk = gtk3;
}) {}