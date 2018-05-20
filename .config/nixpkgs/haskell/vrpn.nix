{ mkDerivation, base, stdenv, vrpn }:
mkDerivation {
  pname = "vrpn";
  version = "0.2.1.4";
  src = /scratch/code.functionally.io/vrpn;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base ];
  librarySystemDepends = [ vrpn ];
  executableHaskellDepends = [ base ];
  executableSystemDepends = [ vrpn ];
  homepage = "https://bitbucket.org/functionally/vrpn";
  description = "Bindings to VRPN";
  license = stdenv.lib.licenses.mit;
}
