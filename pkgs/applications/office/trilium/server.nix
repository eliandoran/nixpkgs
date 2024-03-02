{ stdenv, autoPatchelfHook, fetchurl, nixosTests
, metaCommon }:

let
  serverSource.url = "https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-server-${version}.tar.xz";
  serverSource.sha256 = "1x08g2zb9b3n8f58bgx5878q53xz8n2jlvh18bbwaqp720wxb04h";
  version = "0.62.6";
in stdenv.mkDerivation {
  pname = "trilium-server";
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
    exec ./node/bin/node src/www
    EOF
    chmod a+x $out/bin/trilium-server
  '';

  passthru.tests = {
    trilium-server = nixosTests.trilium-server;
  };
}
