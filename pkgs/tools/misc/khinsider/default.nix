{ fetchFromGitHub, stdenv, python3Packages, installShellFiles, ... }:

python3Packages.buildPythonApplication rec {
  pname = "khinsider";
  version = "unstable-2022-05-09";

  src = fetchFromGitHub { 
    owner = "obskyr";
    repo = pname;
    rev = "b1683fbf2897f04242bd8e67eade940d1b6f2f16";
    sha256 = "sha256-sSxLicoqS41Ofw5M0K3ERbYZAYe4lgQPKpzWdHNl0vA=";
  };

  nativeBuildInputs = [
    python3Packages.wrapPython    
    installShellFiles
  ];

  format = "other";

  propagatedBuildInputs = with python3Packages; [
    requests
    beautifulsoup4
  ];

  patches = [
    ./0001-Remove-package-installation.patch
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 $src/khinsider.py $out/bin/khinsider
  '';

}