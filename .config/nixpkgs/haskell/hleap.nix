{ mkDerivation, aeson, base, containers, data-default, mtl, stdenv
, text, unordered-containers, websockets
}:
mkDerivation {
  pname = "hleap";
  version = "0.1.2.7";
  src = /scratch/code.functionally.io/hleap;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base containers data-default mtl text unordered-containers
    websockets
  ];
  executableHaskellDepends = [
    aeson base containers data-default mtl text unordered-containers
    websockets
  ];
  homepage = "https://bitbucket.org/functionally/hleap";
  description = "Web Socket interface to Leap Motion controller";
  license = stdenv.lib.licenses.mit;
}
