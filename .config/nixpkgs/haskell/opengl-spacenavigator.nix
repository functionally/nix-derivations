{ mkDerivation, base, binary, data-default, GLUT, OpenGL, stdenv }:
mkDerivation {
  pname = "opengl-spacenavigator";
  version = "0.1.5.5";
  src = /scratch/code.functionally.io/opengl-spacenavigator;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base binary data-default GLUT OpenGL ];
  executableHaskellDepends = [
    base binary data-default GLUT OpenGL
  ];
  homepage = "https://bitbucket.org/functionally/opengl-spacenavigator";
  description = "Library and example for using a SpaceNavigator-compatible 3-D mouse with OpenGL";
  license = stdenv.lib.licenses.mit;
}
