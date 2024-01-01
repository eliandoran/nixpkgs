{ stdenv
, lib
, fetchurl
, dpkg
, makeWrapper
, autoPatchelfHook
, zlib
, libgcc
, fontconfig
, libX11
, lttng-ust
, icu
, libICE
, libSM
, libXcursor
, openssl }:

stdenv.mkDerivation rec {
  pname = "lunacy";
  version = "9.3.3";

  # see https://lunacy.docs.icons8.com/release-notes/
  src = fetchurl {
    url = "https://lcdn.icons8.com/setup/Lunacy_${version}.deb";
    hash = "sha256-boIbJA/UuiA3bmXbZXro3IhjFUh6JYsOEprq3n668xk=";
  };

  unpackCmd = ''
    mkdir -p root
    dpkg-deb -x $src root
  '';

  buildInputs = [
    zlib
    libgcc
    stdenv.cc.cc
    lttng-ust
    fontconfig.lib

    # Runtime deps
    libICE
    libSM
    libX11
    libXcursor
  ];

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib";
    cp -R "opt/icons8/lunacy" "$out/lib"
    cp -R "usr/share" "$out/share"
    install -D "opt/icons8/lunacy/Assets/LunacyLogo.png" "$out/share/icons/hicolor/200x200/apps/lunacy.png"

    patchelf \
      --add-needed libICE.so.6 \
      --add-needed libSM.so.6 \
      --add-needed libX11.so.6 \
      --add-needed libXcursor.so.1 \
      "$out/lib/lunacy/Lunacy"

    patchelf \
      --replace-needed liblttng-ust.so.0 liblttng-ust.so \
      $out/lib/lunacy/libcoreclrtraceptprovider.so

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/share/applications/lunacy.desktop \
      --replace "Exec=/opt/icons8/lunacy/Lunacy" "Exec=lunacy" \
      --replace "Icon=/opt/icons8/lunacy/Assets/LunacyLogo.png" "Icon=lunacy"
  '';

  postFixup = ''
    makeWrapper $out/lib/lunacy/Lunacy $out/bin/lunacy \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        icu
        openssl
      ]}
  '';

  meta = {
    description = "Free design software that keeps your flow with AI tools and built-in graphics";
    homepage = "https://icons8.com/lunacy";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ eliandoran ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    mainProgram = "lunacy";
  };

}
