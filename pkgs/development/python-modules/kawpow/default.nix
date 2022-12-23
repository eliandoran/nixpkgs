{ lib
, buildPythonPackage
, fetchPypi
, cmake
, cffi
, gtest
, gbenchmark
, pytest
, python
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "0.9.4.4";
  pname = "kawpow";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dbea4631b407f4c68426825b021d843d40d895ae84fc8ea34aac23298f197d6";
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    cffi
  ];

  preBuild = ''
    cd ..
  '';

  # Tests are bypassed to avoid: `ModuleNotFoundError: No module named 'tests'`
  # or `no tests ran` if using pytestCheckHook. Was unable to find any Python
  # tests inside the pip source archive.
  doCheck = false;

  cmakeFlags = [
    "-DHUNTER_ENABLED=OFF"
    "-DKAWPOW_BUILD_TESTS=OFF"
    "-Dbenchmark_DIR=${gbenchmark}/lib/cmake/benchmark"
    "-DGTest_DIR=${gtest.dev}/lib/cmake/GTest"
    "-DGTest_DIR=${gtest.src}/googletest"
    "-DCMAKE_PREFIX_PATH=${gtest.dev}/lib/cmake"
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "C/C++ implementation of Kawpow - the Ravencoin Proof of Work algorithm";
    homepage = "https://github.com/RavenCommunity/cpp-kawpow";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };

}
