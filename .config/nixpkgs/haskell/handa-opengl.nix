{ mkDerivation, aeson, array, base, binary, data-default, GLUT
, OpenGL, opengl-dlp-stereo, split, stdenv, vector-space
}:
mkDerivation {
  pname = "handa-opengl";
  version = "0.1.13.4";
  src = /scratch/code.functionally.io/handa-opengl;
  libraryHaskellDepends = [
    aeson array base binary data-default GLUT OpenGL opengl-dlp-stereo
    split vector-space
  ];
  homepage = "https://bitbucket.org/functionally/handa-opengl";
  description = "Utility functions for OpenGL and GLUT";
  license = stdenv.lib.licenses.mit;
}
