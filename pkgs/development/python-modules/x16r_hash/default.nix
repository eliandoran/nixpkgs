{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  version = "1.0.1";
  pname = "x16r_hash";

  src = fetchFromGitHub {
    owner = "brian112358";
    repo = pname;
    rev = "d79211ee8b5d86a9709caefded79f318a1d9f3a8";
    hash = "sha256-sy4NbaWJfPxVYhtd7XP0DTz7QdV2umaEIr6Spxrtg2M=";
  };

  meta = with lib; {
    description = "Python module for the x16r hash function";
    homepage = "https://github.com/brian112358/x16r_hash";
    license = licenses.mit;
    maintainers = with maintainers; [ "eliandoran" ];
  };

}
