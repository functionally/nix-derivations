{ mkDerivation, aeson, attoparsec, base, binary, bytestring, cereal
, containers, data-default, ghc-prim, mtl, parallel, scientific
, split, stdenv, stm, text, time, tostring, zlib
}:
mkDerivation {
  pname = "raft";
  version = "0.3.11.1";
  src = /scratch/code.functionally.io/raft;
  libraryHaskellDepends = [
    aeson attoparsec base binary bytestring cereal containers
    data-default ghc-prim mtl parallel scientific split stm text time
    tostring zlib
  ];
  homepage = "https://bitbucket.org/functionally/raft";
  description = "Miscellaneous Haskell utilities for data structures and data manipulation";
  license = stdenv.lib.licenses.mit;
}
