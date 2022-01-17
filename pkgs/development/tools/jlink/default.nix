{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, substituteAll
, qt4
, fontconfig
, freetype
, libusb
, libICE
, libSM
, ncurses5
, udev
, libX11
, libXext
, libXcursor
, libXfixes
, libXrender
, libXrandr
}:

let
  jlinkVersion = "760d";

  architecture = {
    x86_64-linux = "x86_64";
    i686-linux = "i386";
    armv7l-linux = "arm";
  }.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");

  sha256 = {
    x86_64-linux = "sha256-TndqfEcEYLMSTLVhlbKcy/r4rGYb6yaUmhFLS5dWtX8=";
    i686-linux = "1vdfxiwwxxr6vjybd0xl8iq79b5j7kd10bk9j22ghkg7b4mbsjrm";
    armv7l-linux = "0hpiirzy1921fca7b0bcrmc48r03r0lv0qph6xnqdkv66iplj1gz";
  }.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");

  url = {
    x86_64-linux = "https://www.segger.com/downloads/jlink/JLink_Linux_V${jlinkVersion}_x86_64.tgz";
    i686-linux = "https://www.segger.com/downloads/jlink/JLink_Linux_V${jlinkVersion}_i386.tgz";
    armv7l-linux = "https://www.segger.com/downloads/jlink/JLink_Linux_V${jlinkVersion}_arm.tgz";
  }.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation rec {
  pname = "jlink";
  version = jlinkVersion;

  src = fetchurl {
    url = url;
    sha256 = sha256;
    curlOpts = "-d accept_license_agreement=accepted -d non_emb_ctr=confirmed";
  };

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    qt4
    fontconfig
    freetype
    libusb
    libICE
    libSM
    ncurses5
    udev
    libX11
    libXext
    libXcursor
    libXfixes
    libXrender
    libXrandr
  ];

  runtimeDependencies = [ udev ];

  installPhase = ''
    mkdir -p $out/{JLink,bin}
    cp -R * $out/JLink
    ln -s $out/JLink/J* $out/bin/
    rm -r $out/bin/JLinkDevices.xml $out/JLink/libQt*

    # Install udev rules
    mkdir -p $out/etc/udev/rules.d
    cp ./99-jlink.rules $out/etc/udev/rules.d
  '';

  preFixup = ''
    patchelf --add-needed libudev.so.1 $out/JLink/libjlinkarm.so
  '';

  meta = with lib; {
    homepage = "https://www.segger.com/downloads/jlink";
    description = "SEGGER J-Link";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "i686-linux" "armv7l-linux" ];
    maintainers = with maintainers; [ mtetreault ];
  };
}
