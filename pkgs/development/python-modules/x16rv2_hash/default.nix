{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.0";
  pname = "x16rv2_hash";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a919bc003454be47e58a71573a398915ad030dcff5be6d296cb6d1268c36713";
  };

  meta = with lib; {
    description = "X16Rv2 hashing algorithm that is used by Ravencoin beginning October 1st, 2019";
    homepage = "https://github.com/RavenCommunity/x16rv2_hash";
    license = licenses.mit;
    maintainers = with maintainers; [ "eliandoran" ];
  };

}
