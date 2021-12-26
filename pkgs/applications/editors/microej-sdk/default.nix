{ lib
, stdenv
, fetchurl
, makeDesktopItem
, makeWrapper
, openjdk8
, unzip
, glib
, gtk2
, libXtst
, libsecret
, ...
}:

let
  gtk = gtk2;
in stdenv.mkDerivation rec {
  pname = "microej-sdk";
  version = "4.1.5";

  src = fetchurl {
    url = "https://repository.microej.com/packages/SDK/${version}/zip/microej-sdk-${version}-linux_x86_64.zip";
    sha256 = "EaaukOzFwUB6A8vBneF1JDIFrH/ENu/EFjQkITdU518=";
  };

  desktopItem = makeDesktopItem {
    name = "MicroEJ SDK 4.1.5";
    exec = "microej-sdk";
    icon = "microej-sdk";
    comment = "Integrated Development Environment for developing embedded applications in Java";
    desktopName = "MicroEJ SDK";
    genericName = "MicroEJ Integrated Development Environment";
    categories = [ "Development" ];
  };

  buildInputs = [
    makeWrapper openjdk8 unzip
    glib gtk libXtst libsecret
  ];

  buildCommand = ''
    mkdir -p $out
    unzip -d $out $src

    # Patch binaries.
    interpreter=$(echo ${stdenv.cc.libc}/lib/ld-linux*.so.2)
    patchelf --set-interpreter $interpreter $out/MicroEJ-SDK

    # Create wrapper script.  Pass -configuration to store
    # settings in ~/.eclipse/org.eclipse.platform_<version> rather
    # than ~/.eclipse/org.eclipse.platform_<version>_<number>.
    productId=$(sed 's/id=//; t; d' $out/.eclipseproduct)

    makeWrapper $out/MicroEJ-SDK $out/bin/microej-sdk \
      --prefix PATH : ${openjdk8}/bin \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath ([ glib gtk libXtst libsecret ])} \
      --add-flags "-configuration \$HOME/.eclipse/''${productId}_${version}/configuration"

    # Create desktop item.
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
    mkdir -p $out/share/pixmaps
    ln -s $out/MicroEJ-SDK.xpm $out/share/pixmaps/microej-sdk.xpm

    # Increase max memory allocation
    echo -e "\n-Xms1024m\n-Xmx4096m\n-Xss1024m" >> $out/MicroEJ-SDK.ini
  '';
}
