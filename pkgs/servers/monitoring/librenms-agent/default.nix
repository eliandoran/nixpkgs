{ stdenv, lib, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {

  pname = "librenms-agent";
  version = "unstable-2023-11-19";

  src = fetchFromGitHub {
    owner = "librenms";
    repo = pname;
    rev = "f6d6ff5b88bd47e738754fe72c4a4e5eb4e78d08";
    sha256 = "sha256-b62xkwJ09BQe/XRXZqnOr5JUpLjLIqYRETr/wTim/h4=";
  };

  installPhase = ''
    mkdir -p $out/bin
    install -m 0750 check_mk_agent $out/bin
  '';

  meta = with lib; {
    description = "Agent that provides data to LibreNMS";
    homepage = "https://github.com/librenms/librenms-agent";
    license = licenses.gpl2;
    maintainers = with maintainers; [ eliandoran ];
    platforms = platforms.linux;
  };

}
