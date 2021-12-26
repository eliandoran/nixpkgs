{ openjdk11, gtk3, callPackage }:

callPackage (import ./common.nix rec {
  version = "22.06";
  sha256 = "sha256-ZnN0O11X8/oBI6zfXHMcSxdhJ+65U4EGZULGet4GQ+c=";
  # JDK 11 is required for SDK 22.06
  # Source: https://docs.microej.com/en/latest/SDKUserGuide/systemRequirements.html
  jdk = openjdk11;
  # GTK 2 not supported ("no swt-pi4-gtk" when loading SWT).
  gtk = gtk3;
}) {}
