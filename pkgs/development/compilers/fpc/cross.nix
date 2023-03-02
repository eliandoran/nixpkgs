{ stdenv, fetchurl, undmg, cpio, xar, lib, gawk, fetchpatch, breakpointHook }:

let
  osTarget = "win64";
  cpuTarget = "x86_64";

  startFPC = import ./binary.nix { inherit stdenv fetchurl undmg cpio xar lib; };
in stdenv.mkDerivation rec {
  version = "3.2.2";
  pname = "fpc";

  src = fetchurl {
    url = "mirror://sourceforge/freepascal/fpcbuild-${version}.tar.gz";
    sha256 = "85ef993043bb83f999e2212f1bca766eb71f6f973d362e2290475dbaaf50161f";
  };

  glibc = stdenv.cc.libc.out;

  makeFlags = [
    "OS_TARGET=${osTarget}" "CPU_TARGET=${cpuTarget}"
    "NOGDB=1" "FPC=${startFPC}/bin/fpc"
  ];

  installTargets = "crossinstall";
  installFlags = [
    "OS_TARGET=${osTarget}" "CPU_TARGET=${cpuTarget}"
    "INSTALL_PREFIX=\${out}"
  ];

  # Patch paths for linux systems. Other platforms will need their own patches.
  patches = [
    ./mark-paths.patch # mark paths for later substitution in postPatch
  ] ++ lib.optional stdenv.isAarch64 (fetchpatch {
    # backport upstream patch for aarch64 glibc 2.34
    url = "https://gitlab.com/freepascal.org/fpc/source/-/commit/a20a7e3497bccf3415bf47ccc55f133eb9d6d6a0.patch";
    hash = "sha256-xKTBwuOxOwX9KCazQbBNLhMXCqkuJgIFvlXewHY63GM=";
    stripLen = 1;
    extraPrefix = "fpcsrc/";
  });

  postPatch = ''
    # substitute the markers set by the mark-paths patch
    substituteInPlace fpcsrc/compiler/systems/t_linux.pas --subst-var-by dynlinker-prefix "${glibc}"
    substituteInPlace fpcsrc/compiler/systems/t_linux.pas --subst-var-by syslibpath "${glibc}/lib"
    # Replace the `codesign --remove-signature` command with a custom script, since `codesign` is not available
    # in nixpkgs
    substituteInPlace fpcsrc/compiler/Makefile \
      --replace \
        "\$(CODESIGN) --remove-signature" \
        "${./remove-signature.sh}" \
      --replace "ifneq (\$(CODESIGN),)" "ifeq (\$(OS_TARGET), darwin)"
  '';

  preInstall = ''
    ls -l
  '';

  nativeBuildInputs = [
    breakpointHook
  ];

  buildInputs = [ startFPC gawk ];

}
