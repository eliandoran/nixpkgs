{ lib
, buildPythonPackage
, fetchPypi
, python
, pytest
}:

buildPythonPackage rec {
  version = "0.18.0.1";
  pname = "recordclass";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0767a6dc5b38118074ec5afd7596dd04a6cc992894f40eecdf4b587315ce465";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test $out/${python.sitePackages}
  '';

  meta = with lib; {
    description = "Mutable variants of tuple (mutabletuple) and collections.namedtuple (recordclass), which support assignments and more memory saving variants (dataobject, litelist, ...).";
    homepage = "https://bitbucket.org/intellimath/recordclass";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };

}
