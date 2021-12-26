{ openjdk11, gtk3, callPackage }:

callPackage (import ./common.nix rec {
  version = "21.11";
  sha256 = "sha256-pt8tB3mIHecfrdz4CSeKlnG2e6YnMK+/NshmpBp2vBo=";
  # officially SDK 21.11 supports both JRE 8 and 11, but on Linux it crashes
  # "Using GTK+ 2.x and GTK+ 3 in the same process is not supported
  jdk = openjdk11;
  # GTK 2 not supported ("no swt-pi4-gtk" when loading SWT).
  gtk = gtk3;
}) {}
