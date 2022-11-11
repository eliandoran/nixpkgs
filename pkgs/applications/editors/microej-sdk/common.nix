{ version, sha256, jdk, gtk }:

{ lib
, stdenv
, fetchurl
, makeDesktopItem
, makeWrapper
, openjdk11
, unzip
, glib, glib-networking
, gtk3
, libXtst
, libsecret
, webkitgtk
, ...
}:

stdenv.mkDerivation rec {
  pname = "microej-sdk";
  inherit version;

  src = fetchurl {
    url = "https://repository.microej.com/packages/SDK/${version}/zip/microej-sdk-${version}-linux_x86_64.zip";
    sha256 = sha256;
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
    makeWrapper jdk unzip
    glib gtk libXtst libsecret
  ] ++ lib.optional (webkitgtk != null) webkitgtk;

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

    makeWrapper $out/MicroEJ-SDK $out/bin/${pname} \
      --prefix PATH : ${jdk}/bin \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath ([ glib gtk libXtst libsecret ] ++ lib.optional (webkitgtk != null) webkitgtk)} \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
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
