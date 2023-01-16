{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rei3";
  version = "3.2.4";

  src = fetchFromGitHub {
    owner = "r3-team";
    repo = "r3";
    rev = "v${version}";
    sha256 = "sha256-rCni39PCX4rm14n0OjRsFccrxsmnRhjsgk93Jkfzr+s=";
  };

  vendorSha256 = "sha256-JceYBlCtkwlua2gN4j2x7sUDQ4L78OoN/fEVCxmba1k=";

}
