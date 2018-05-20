{ mkDerivation, aeson, base, binary, bytestring, cereal, linear
, milena, mtl, stdenv
}:
mkDerivation {
  pname = "kafka-device";
  version = "0.2.1.5";
  src = /scratch/code.functionally.io/kafka-device;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base binary bytestring cereal linear milena mtl
  ];
  executableHaskellDepends = [
    aeson base binary bytestring cereal linear milena mtl
  ];
  homepage = "https://bitbucket.org/functionally/kafka-device";
  description = "UI device events via a Kafka message broker";
  license = stdenv.lib.licenses.mit;
}
