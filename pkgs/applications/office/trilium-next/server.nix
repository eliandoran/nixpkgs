{
  stdenv,
  autoPatchelfHook,
  fetchurl,
  nixosTests,
  metaCommon,
  version,
}:

let
  serverSource.url = "https://github.com/TriliumNext/Notes/releases/download/v${version}/TriliumNextNotes-v${version}-server-linux-x64.tar.xz";
  serverSource.sha256 = "sha256-KHFXKlu7CT/OGjvw38ZE1Dg4ICw0r7F+rv3FtLZgtLk=";
in
stdenv.mkDerivation {
  pname = "trilium-next-server";
  inherit version;
  meta = metaCommon // {
    platforms = [ "x86_64-linux" ];
  };

  src = fetchurl serverSource;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  patches = [
    # patch logger to use console instead of rolling files
    ./0001-Use-console-logger-instead-of-rolling-files.patch
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/share/trilium-server

    cp -r ./* $out/share/trilium-server
    runHook postInstall
  '';

  postFixup = ''
    cat > $out/bin/trilium-server <<EOF
    #!${stdenv.cc.shell}
    cd $out/share/trilium-server
    exec ./node/bin/node src/main
    EOF
    chmod a+x $out/bin/trilium-server
  '';

  passthru.tests = {
    trilium-server = nixosTests.trilium-server;
  };
}
