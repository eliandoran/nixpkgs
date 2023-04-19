{ stdenv, fetchurl, unzip, makeWrapper, procps, openjdk17 }:

stdenv.mkDerivation rec {

  pname = "sonarqube";
  version = "9.9.0.65466";

  src = fetchurl {
    url = "https://binaries.sonarsource.com/Distribution/${pname}/${pname}-${version}.zip";
    sha256 = "sha256-9bMEWsQLmd/Cq0XAmQB09LFeQmvbkVM9d/O5S3PT1BE=";
  };

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  buildInputs = [
    openjdk17
  ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
      mkdir -p $out/sonarqube
      cd ${pname}-${version}
      cp -R conf extensions logs web data lib temp $out/sonarqube
      ${if stdenv.isi686 then "cp -R bin/linux-x86-32 $out/sonarqube/bin"
        else if stdenv.isx86_64 then"cp -R bin/linux-x86-64 $out/sonarqube/bin"
        else "echo 'architecture not yet supported'; exit -1;"}
      sed -i s=/usr/bin/ps=${procps}/bin/ps= $out/sonarqube/bin/sonar.sh

      # Wrap with JRE.
      makeWrapper $out/sonarqube/bin/sonar.sh $out/bin/sonarqube \
        --prefix SONAR_JAVA_PATH : ${openjdk17}/bin/java;
  '';

}
