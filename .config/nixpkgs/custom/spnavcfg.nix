
{ stdenv, fetchurl, pkgconfig, gtk2, libX11 }:

stdenv.mkDerivation rec {
  name    = "${pname}-${version}";
  pname   = "spnavcfg";
  version = "0.6";

  src = fetchurl {
    name   = "${pname}-${version}.tar.gz";
    url    = "https://sourceforge.net/projects/spacenav/files/spacenavd%20config%20gui/spnavcfg%200.3/spnavcfg-0.3.tar.gz/download";
    sha256 = "1msbxb6i01irrc5b5dvbxirwzf415y9cbdh8pz046hmx9s6hp5ac";
  };

  libPath = [ gtk2 libX11 ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gtk2 libX11 ];

  prePatch = ''
    sed -i -e 's/ -m 4775 / /' Makefile.in
  '';

  meta = with stdenv.lib; {
    description = "SpaceNavigator configuration tool";
    longDescription = ''
      A free, compatible alternative for 3Dconnexion's 3D input device drivers and SDK.
    '';
    homepage    = http://spacenav.sourceforge.net/;
    license     = licenses.gpl3;
    platforms   = platforms.linux;
  };
}
