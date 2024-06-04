{ stdenv, fetchgit, freeglut, libGL, libGLU, fftw }:

stdenv.mkDerivation rec {

	pname = "rtspeccy";
	version = "23.08";

	src = fetchgit {
		url = "https://uninformativ.de/git/rtspeccy.git";
    rev = "v${version}";
    hash = "sha256-QMPEuFQxOKE2X03fM8E/XMFLfTYncohYoNbNhhJwx1o=";
	};

  buildInputs = [
    freeglut
    libGL
    libGLU
    fftw
  ];
  installFlags = [ "prefix=$(out)" ];

  configurePhase = ''
    runHook preConfigure
    cp config.h.example config.h
    runHook postConfigure
  '';

}
