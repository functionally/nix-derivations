{ mkDerivation, aeson, base, hleap, kafka-device, stdenv
, websockets
}:
mkDerivation {
  pname = "kafka-device-leap";
  version = "0.2.1.2";
  src = /scratch/code.functionally.io/kafka-device-leap;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base hleap kafka-device websockets
  ];
  executableHaskellDepends = [
    aeson base hleap kafka-device websockets
  ];
  homepage = "https://bitbucket.org/functionally/kafka-device-leap";
  description = "Leap Motion events via a Kafka message broker";
  license = stdenv.lib.licenses.mit;
}
