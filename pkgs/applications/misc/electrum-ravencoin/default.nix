{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, python3
, zbar
, secp256k1
, enableQt ? true
}:

let
  version = "v0.5.2";

  libsecp256k1_name =
    if stdenv.isLinux then "libsecp256k1.so.0"
    else if stdenv.isDarwin then "libsecp256k1.0.dylib"
    else "libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}";

  libzbar_name =
    if stdenv.isLinux then "libzbar.so.0"
    else if stdenv.isDarwin then "libzbar.0.dylib"
    else "libzbar${stdenv.hostPlatform.extensions.sharedLibrary}";

in

python3.pkgs.buildPythonApplication {
  pname = "electrum-ravencoin";
  inherit version;

  src = fetchFromGitHub {
    owner = "Electrum-RVN-SIG";
    repo = "electrum-ravencoin";
    rev = "refs/tags/${version}";
    sha256 = "sha256-uZOmGowYkpCu18nmwcnXoG3RcuQ+070XyPNH3AJhzyw=";
  };

  nativeBuildInputs = lib.optionals enableQt [ wrapQtAppsHook ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    aiohttp-socks
    aiorpcx
    attrs
    bitstring
    recordclass
    cryptography
    x16r_hash
    x16rv2_hash
    kawpow
    dnspython
    jsonrpclib-pelix
    matplotlib
    pbkdf2
    protobuf
    pysocks
    qrcode
    requests
    tlslite-ng
    # plugins
    btchip
    ckcc-protocol
    keepkey
    trezor
  ] ++ lib.optionals enableQt [
    pyqt5
    qdarkstyle
  ];

  postPatch = ''
    # make compatible with protobuf4 by easing dependencies ...
    substituteInPlace ./contrib/requirements/requirements.txt \
      --replace "protobuf>=3.12,<4" "protobuf>=3.12"
    # ... and regenerating the paymentrequest_pb2.py file
    protoc --python_out=. electrum/paymentrequest.proto

    substituteInPlace ./electrum/ecc_fast.py \
      --replace ${libsecp256k1_name} ${secp256k1}/lib/libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}
  '' + (if enableQt then ''
    substituteInPlace ./electrum/qrscanner.py \
      --replace ${libzbar_name} ${zbar.lib}/lib/libzbar${stdenv.hostPlatform.extensions.sharedLibrary}
  '' else ''
    sed -i '/qdarkstyle/d' contrib/requirements/requirements.txt
  '');

  postInstall = lib.optionalString stdenv.isLinux ''
    substituteInPlace $out/share/applications/electrum-ravencoin.desktop \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum-ravencoin %u"' \
                "Exec=$out/bin/electrum-ravencoin %u" \
      --replace 'Exec=sh -c "PATH=\"\\$HOME/.local/bin:\\$PATH\"; electrum-ravencoin --testnet %u"' \
                "Exec=$out/bin/electrum-ravencoin --testnet %u"
  '';

  postFixup = lib.optionalString enableQt ''
    wrapQtApp $out/bin/electrum-ravencoin
  '';

  checkInputs = with python3.pkgs; [ pytestCheckHook pyaes pycryptodomex ];

  preCheck = ''
    export ELECTRUMDIR=.
  '';

  pytestFlagsArray = [ "electrum/tests" ];

  postCheck = ''
    $out/bin/electrum-ravencoin help >/dev/null
  '';

  meta = with lib; {
    description = "Lightweight Groestlcoin wallet";
    longDescription = ''
      An easy-to-use Groestlcoin client featuring wallets generated from
      mnemonic seeds (in addition to other, more advanced, wallet options)
      and the ability to perform transactions without downloading a copy
      of the blockchain.
    '';
    homepage = "https://groestlcoin.org/";
    downloadPage = "https://github.com/Groestlcoin/electrum-ravencoin/releases/tag/v{version}";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ gruve-p ];
  };
}
