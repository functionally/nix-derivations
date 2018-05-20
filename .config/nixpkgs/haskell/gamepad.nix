{ mkDerivation, base, stdenv, vrpn }:
mkDerivation {
  pname = "gamepad";
  version = "0.1.0.0";
  src = /scratch/code.functionally.io/gamepad;
  isLibrary = false;
  isExecutable = true;
  enableSeparateDataOutput = true;
  executableHaskellDepends = [ base vrpn ];
  homepage = "https://bitbucket.org/functionally/gamepad";
  description = "VRPN support for gamepad controllers";
  license = stdenv.lib.licenses.mit;
}
