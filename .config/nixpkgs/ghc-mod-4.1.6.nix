{ mkDerivation, base, Cabal, containers, deepseq, directory
, doctest, filepath, ghc, ghc-syb-utils, hlint, hspec, io-choice
, old-time, process, stdenv, syb, time, transformers
}:
mkDerivation {
  pname = "ghc-mod";
  version = "4.1.6";
  sha256 = "093wafaizr2xf7vmzj6f3vs8ch0vpcmwlrja6af6hshgaj2d80qs";
  revision = "1";
  editedCabalFile = "0fbjvkx4c3fgd2w7p4fsbcrmarcas2psc589q08qh3d8q28l06hq";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    base Cabal containers deepseq directory filepath ghc ghc-syb-utils
    hlint io-choice old-time process syb time transformers
  ];
  executableHaskellDepends = [
    base containers directory filepath ghc
  ];
  testHaskellDepends = [
    base Cabal containers deepseq directory doctest filepath ghc
    ghc-syb-utils hlint hspec io-choice old-time process syb time
    transformers
  ];
  homepage = "http://www.mew.org/~kazu/proj/ghc-mod/";
  description = "Happy Haskell Programming";
  license = stdenv.lib.licenses.bsd3;
}
