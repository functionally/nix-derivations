{
  stdenv
, fetchgit
, fetchurl
, go_1_12
}:

stdenv.mkDerivation rec {

  name = "textile-0.5.4";

  src = fetchgit {
    url    = "https://github.com/textileio/go-textile.git"         ;
    rev    = "a07d47f5e1e9925069b968c68786a6629ae4fdf6"            ;
    sha256 = "041vwd0gzmmflqw3xwc5542qc2s5xjaangbqz6jrxazck38xkmp9";
  };

  src_deps = fetchurl {
    name   = "go-textile-v0.5.4-dependencies.tar.gz"                                           ;
    url    = "https://gateway.pinata.cloud/ipfs/QmQrDg12WgmvuiSg1rAAgbpoKPcUi7uR128BgHTgUjj5MA";
    sha256 = "1jrdrm3ks3hf1vy67aplcgkx6fh71lc6cvdvzyvdiqmf8di3g92y"                            ;
  };

  nativeBuildInputs = [ go_1_12 ];

  buildPhase = ''
    DOWNLOADDIR=$PWD/downloads
    mkdir $DOWNLOADDIR
    tar xf $src_deps -C $DOWNLOADDIR
    export GOPATH=$DOWNLOADDIR:$GOPATH
    mkdir cache
    export GOCACHE=$PWD/cache
    go build .
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp go-textile $out/bin/textile
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
