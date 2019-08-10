{
  stdenv
, fetchgit
, fetchurl
, go_1_12
}:

stdenv.mkDerivation rec {

  name = "textile-0.6.9";

  src = fetchgit {
    url    = "https://github.com/textileio/go-textile.git"         ;
    rev    = "fee010289b16afa20c3cded3835d91969933d57a"            ;
    sha256 = "0pb0g45zwhdhzgwd6zy448z12zs5ki7yjqdidhmc3102jagv8860";
  };

  src_deps = fetchurl {
    name   = "go-textile-v0.6.9-dependencies.tar.gz"                                           ;
    url    = "https://gateway.pinata.cloud/ipfs/QmfTnyLbyHDEFMMSM7guEjuUyh9hp9sfRHAX8rriSpTT3r";
    sha256 = "1mjr43f20r7qdz7sjl9zq3ckprgilz9isnlxknwps2lyby4cfj7l"                            ;
  };

  nativeBuildInputs = [ go_1_12 ];

  buildPhase = ''
    DOWNLOADDIR=$PWD/downloads
    mkdir $DOWNLOADDIR
    tar xf $src_deps -C $DOWNLOADDIR
    export GOPATH=$DOWNLOADDIR:$GOPATH
    mkdir cache
    export GOCACHE=$PWD/cache
    go build ./cmd/textile
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp textile $out/bin/textile
  '';

  meta = {
    homepage = "https://textile.io/";
    description = "Textile is a set of tools and trust-less infrastructure for building censorship resistant and privacy preserving applications.";
    longDescription = ''
      Textile provides encrypted, recoverable, schema-based, and cross-application data storage built on IPFS and libp2p. While interoperable with the whole IPFS peer-to-peer network, Textile-flavored peers represent an additional layer or sub-network of users, applications, and services.
    '';
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.mit;
  };
}
