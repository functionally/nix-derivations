{ mkDerivation, base, GLUT, kafka-device, OpenGL, stdenv }:
mkDerivation {
  pname = "kafka-device-glut";
  version = "0.2.1.2";
  src = /scratch/code.functionally.io/kafka-device-glut;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base GLUT kafka-device OpenGL ];
  executableHaskellDepends = [ base GLUT kafka-device OpenGL ];
  homepage = "https://bitbucket.org/functionally/kafka-device-glut";
  description = "GLUT events via a Kafka message broker";
  license = stdenv.lib.licenses.mit;
}
