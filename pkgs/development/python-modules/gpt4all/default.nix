{ buildPythonPackage
, fetchPypi }:

buildPythonPackage rec {
  pname = "gpt4all";
  version = "2.2.1.post1";

  src = fetchPypi {
    inherit pname;
    inherit version;
    hash = "";
  };
}
