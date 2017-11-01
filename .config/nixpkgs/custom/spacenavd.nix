
{ stdenv, fetchgit, libX11 }:

stdenv.mkDerivation rec {
  name    = "${pname}-${version}";
  pname   = "spacenavd";
  version = "0.3";

  src = fetchgit {
    url    = "https://gitlab.com/RoPP/spacenavd.git";
    rev    = "1ad7d6d3d94acc560dfc1ea91bd59fd76028f277";
    sha256 = "070qih6pfis1a05wwvlh9qkc6i8bc2x8bj18arhh3d2lixck1b82";
  };

  libPath = [ libX11 ];

  buildInputs = [ libX11 ];

  meta = with stdenv.lib; {
    description = "SpaceNavigator daemon";
    longDescription = ''
      Spacenavd, is a free software replacement user-space driver (daemon), for
      3Dconnexion's space-something 6dof input devices. It's compatible with the
      original 3dxsrv proprietary daemon provided by 3Dconnexion, and works
      perfectly with any program that was written for the 3Dconnexion driver.
    '';
    homepage    = https://gitlab.com/RoPP/spacenavd;
    license     = licenses.gpl3;
    platforms   = platforms.linux;
  };
}
