{ mkDerivation, base, data-default, GLUT, OpenGL, stdenv, vector }:
mkDerivation {
  pname = "opengl-dlp-stereo";
  version = "0.1.5.4";
  src = /scratch/code.functionally.io/opengl-dlp-stereo;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base data-default GLUT OpenGL vector ];
  executableHaskellDepends = [
    base data-default GLUT OpenGL vector
  ];
  homepage = "https://bitbucket.org/functionally/opengl-dlp-stereo";
  description = "Library and example for using DLP stereo in OpenGL";
  license = stdenv.lib.licenses.mit;
}
