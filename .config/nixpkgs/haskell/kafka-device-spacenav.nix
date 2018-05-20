{ mkDerivation, aeson, base, binary, bytestring, cereal
, kafka-device, stdenv, yaml
}:
mkDerivation {
  pname = "kafka-device-spacenav";
  version = "0.2.1.2";
  src = /scratch/code.functionally.io/kafka-device-spacenav;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base binary bytestring cereal kafka-device
  ];
  executableHaskellDepends = [
    aeson base binary bytestring cereal kafka-device yaml
  ];
  homepage = "https://bitbucket.org/functionally/kafka-device-spacenav";
  description = "Linux SpaceNavigator events via a Kafka message broker";
  license = stdenv.lib.licenses.mit;
}
