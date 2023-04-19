{ stdenv, fetchurl, unzip, procps }:

stdenv.mkDerivation rec {

  pname = "sonarqube";
  version = "9.9.0.65466";

  src = fetchurl {
    url = "https://binaries.sonarsource.com/Distribution/${pname}/${pname}-${version}.zip";
    sha256 = "sha256-9bMEWsQLmd/Cq0XAmQB09LFeQmvbkVM9d/O5S3PT1BE=";
  };

  nativeBuildInputs = [
    unzip
  ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
      mkdir -p $out
      cd ${pname}-${version}
      cp -R conf extensions logs web data lib temp $out
      ${if stdenv.isi686 then "cp -R bin/linux-x86-32 $out/bin"
        else if stdenv.isx86_64 then"cp -R bin/linux-x86-64 $out/bin"
        else "echo 'architecture not yet supported'; exit -1;"}
      sed -i s=/usr/bin/ps=${procps}/bin/ps= $out/bin/sonar.sh
  '';

}
