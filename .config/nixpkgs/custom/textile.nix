{
  stdenv
, fetchgit
, fetchurl
, go_1_12
}:

stdenv.mkDerivation rec {

  name = "textile-0.7.6";

  src = fetchgit {
    url    = "https://github.com/textileio/go-textile.git"         ;
    rev    = "2904cf0b7e331fab5b19d4355fc2271284ab3084"            ;
    sha256 = "0slykqmsw5p45dzxvl65zxyngx79dai9wd56v201vghl0vrsdpd3";
  };

  src_deps = fetchurl {
    name   = "go-textile-v0.7.6-dependencies.tar.gz"                             ;
    url    = "http://ipfs.io/ipfs/QmcKRKaCFTszteg9HDsmuT6WiWgLznJbWsfVxUX6TNCpRH";
    sha256 = "1r6ibik9xx59i1l9gy4prmnva95cr68g99qqwfwlbvbd9zsmy9jf"              ;
  };

  nativeBuildInputs = [ go_1_12 ];

  buildPhase = ''
    sed -i -e '159s/200/12/ ; 160s/500/15/ ; 163s/600/12/ ; 164s/900/15/ ; 167s/20/15/' core/config.go
    sed -i -e ' 88s/200/12/ ;  89s/500/15/ ;  84s/600/12/ ;  85s/900/15/ ;  86s/20/15/' repo/config/init_ipfs.go
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
