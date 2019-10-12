{
  stdenv
, fetchgit
, fetchurl
, go_1_12
}:

stdenv.mkDerivation rec {

  name = "textile-0.7.4";

  src = fetchgit {
    url    = "https://github.com/textileio/go-textile.git"         ;
    rev    = "2618daee223632ed89b28fc86053674b4270b35a"            ;
    sha256 = "1dv1d83cgxcis4b038r8653svqhl1h45f4gf35ihvbfm432jd0kw";
  };

  src_deps = fetchurl {
    name   = "go-textile-v0.7.4-dependencies.tar.gz"                             ;
    url    = "http://ipfs.io/ipfs/QmNUfjkXkXSicyamS8aDhM5E8369s83fGfwFeZz5xseSCe";
    sha256 = "0c73lnc9ayn90y217fzjwpb2f8rphjm580y5c5shn40a9ac86i41"              ;
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
