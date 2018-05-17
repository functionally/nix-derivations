{stdenv, fetchgit, boost, curl, db48, libzip, miniupnpc, openssl, qrencode, zlib}:

let

  aname = "gridcoinresearchd";
  version = "3.7.11.0";

in

  stdenv.mkDerivation rec {

    name = "${aname}-${version}";

    src = fetchgit {
      url    = "https://github.com/gridcoin/Gridcoin-Research.git";
      rev    = "375a78e6ac50c9615d76d12583ec8b78d0471bd0";
      sha256 = "1vnkyisaiglbgflvl2z5hwzpn8x33wisvar9ff2zydldny9j2y2v";
    };

    postUnpack = "sourceRoot=\${sourceRoot}/src";

    preConfigure = ''
      mkdir -p obj/zerocoin && chmod +x leveldb/build_detect_platform
      ln -s makefile.unix Makefile
    '';

    installPhase = ''
      strip gridcoinresearchd
      mkdir -p $out/bin
      install -m 755 gridcoinresearchd $out/bin/gridcoinresearchd
    '';

    nativeBuildInputs = [
      boost
      curl
      db48
      libzip
      miniupnpc
      openssl
      qrencode
      zlib
    ];

    meta = {
      homepage = "https://gridcoin.us/";
      description = "Gridcoin is an open source cryptocurrency (Ticker: GRC) which securely rewards volunteer computing performed on the BOINC platform.";
      longDescription = ''
        Gridcoin seeks to distinguish itself from Bitcoin by adopting "environmentally-friendly" approaches to distributing new coins and securing the network. Most notably, Gridcoin implements the novel Proof-of-Research (POR) scheme, which rewards users with Gridcoin for performing useful scientific computations on Berkeley Open Infrastructure for Network Computing (BOINC), a well-known distributed computing platform. Computing on these scientific projects supplants the cryptographic calculations involved in Bitcoin mining. Moreover, while Bitcoin secures its network through an energy intensive proof-of-work scheme, Gridcoin uses a more energy efficient proof-of-stake system.
      '';
      platforms = stdenv.lib.platforms.linux;
      license = stdenv.lib.licenses.mit;
    };
  }
