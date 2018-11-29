{
  stdenv
, fetchgit
, autoreconfHook
, boost
, curl
, db48
, hexdump
, libzip
, miniupnpc
, openssl
, pkgconfig
, qrencode
, which
, zlib
}:

let

  aname = "gridcoinresearchd";
  version = "4.0.0.0";

in

  stdenv.mkDerivation rec {

    name = "${aname}-${version}";

    src = fetchgit {
      url    = "https://github.com/gridcoin/Gridcoin-Research.git";
      rev    = "d544449ede53fb371671fecb1c8f1ced7c383ffc";
      sha256 = "07my2zw971srzxhmzaz4nslp8667zshdkp76gsxnix3s4fv5s2ds";
    };

    configureFlags = [
      "--with-tests=no"
      "--with-boost=${boost.dev}"
      "--with-boost-libdir=${boost.out}/lib"
    ];

####    preConfigure = ''
####      mkdir -p obj/zerocoin && chmod +x leveldb/build_detect_platform
####      ln -s makefile.unix Makefile
####    '';
####
####    installPhase = ''
####      strip gridcoinresearchd
####      mkdir -p $out/bin
####      install -m 755 gridcoinresearchd $out/bin/gridcoinresearchd
####    '';

    nativeBuildInputs = [
      autoreconfHook
      boost
      curl
      db48
      hexdump
      libzip
      miniupnpc
      openssl
      pkgconfig
      qrencode
      which
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
