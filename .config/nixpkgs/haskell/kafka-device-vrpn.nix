{ mkDerivation, base, kafka-device, stdenv, vrpn }:
mkDerivation {
  pname = "kafka-device-vrpn";
  version = "0.2.1.2";
  src = /scratch/code.functionally.io/kafka-device-vrpn;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base kafka-device vrpn ];
  executableHaskellDepends = [ base kafka-device vrpn ];
  homepage = "https://bitbucket.org/functionally/kafka-device-vrpn";
  description = "VRPN events via a Kafka message broker";
  license = stdenv.lib.licenses.mit;
}
