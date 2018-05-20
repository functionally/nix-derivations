{ mkDerivation, base, bson, bson-generic, daft, monad-control
, mongoDB, mtl, raft, stdenv, text, vinyl
}:
mkDerivation {
  pname = "daft-mongodb";
  version = "0.4.17.4";
  src = /scratch/code.functionally.io/daft-mongodb;
  libraryHaskellDepends = [
    base bson bson-generic daft monad-control mongoDB mtl text vinyl
  ];
  testHaskellDepends = [
    base bson bson-generic daft monad-control mongoDB mtl raft text
    vinyl
  ];
  license = stdenv.lib.licenses.unfree;
}
