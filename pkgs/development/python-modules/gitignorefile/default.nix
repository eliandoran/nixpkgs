{ buildPythonPackage, fetchFromGitHub, setuptools }:

buildPythonPackage {
  pname = "gitignorefile";
  version = "unstable-2022-09-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "excitoon";
    repo = "gitignorefile";
    rev = "822a7da50b46f4cd8964c57195f95056dc222092"; # upstream has no tags
    hash = "sha256-fdzsYiETmHA0bU68u4Qd49K1DtuY0N5IZKBMxJnKBRs=";
  };

  build-system = [ setuptools ];
}
