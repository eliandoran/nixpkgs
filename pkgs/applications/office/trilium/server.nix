{ stdenv, lib, autoPatchelfHook, fetchurl, nixosTests }:

let
  serverSource.url = "https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-server-${version}.tar.xz";
  serverSource.sha256 = "0l53kps7rhf8rx9zx29psvjl3611y7pymfkh2yb13h6iv1c77gdf";
  version = "0.58.5";
in stdenv.mkDerivation rec {
  pname = "trilium-server";
  inherit version;
  meta = with lib; {
    description = "Hierarchical note taking application with focus on building large personal knowledge bases";
    homepage = "https://github.com/zadam/trilium";
    license = licenses.agpl3Plus;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ fliegendewurst ];
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
