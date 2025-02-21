{ buildPythonPackage, fetchFromGitHub, setuptools, mkdocs, requests, mistune, md2cf }:

let
  mistune0_8 = mistune.overridePythonAttrs (oldAttrs: rec {
    version = "0.8.4";
    src = fetchFromGitHub {
      inherit (oldAttrs.src) owner repo;
      inherit version;
      tag = "v${version}";
      hash = "sha256-H9L2cJZVWvcbcWAF8ZMLGJGE7DO1h2wNZCbeFA02p7g=";
    };
  });
in buildPythonPackage rec {
  pname = "mkdocs-with-confluence";
  version = "0.2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pawelsikora";
    repo = "mkdocs-with-confluence";
    rev = version;
    hash = "sha256-sgoSOAr+ClSW1NDt5ljePw5nsqoZXDkBi1gYA7lXBd4=";
  };

  dependencies = [
    requests
    mkdocs
    mistune0_8
    md2cf
  ];

  pythonImportsCheck = [ "mkdocs_with_confluence" ];

  build-system = [ setuptools ];

}
