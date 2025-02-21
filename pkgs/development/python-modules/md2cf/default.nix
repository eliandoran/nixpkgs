{ buildPythonPackage, fetchFromGitHub, setuptools, requests, mistune, pyyaml, chardet, gitignorefile, rich, rich-argparse }:

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
  pname = "md2cf";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iamjackg";
    repo = "md2cf";
    rev = "v${version}";
    hash = "sha256-wvnD19K1nXgnC5vYwh+IuglMiiNBju+DPu/4osx8VqA=";
  };

  dependencies = [
    requests
    mistune0_8
    pyyaml
    chardet
    gitignorefile
    rich
    rich-argparse
  ];

  pythonRelaxDeps = true;

  build-system = [ setuptools ];
}
