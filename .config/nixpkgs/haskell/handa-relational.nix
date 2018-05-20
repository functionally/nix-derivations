{ mkDerivation, aeson, base, binary, data-default, handa-data
, scientific, split, stdenv, text, vinyl, vinyl-utils
}:
mkDerivation {
  pname = "handa-relational";
  version = "1.0.0.0";
  src = /scratch/code.functionally.io/handa-relational;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base binary data-default handa-data scientific split text
    vinyl vinyl-utils
  ];
  executableHaskellDepends = [
    aeson base binary data-default handa-data scientific split text
    vinyl vinyl-utils
  ];
  license = stdenv.lib.licenses.mit;
}
