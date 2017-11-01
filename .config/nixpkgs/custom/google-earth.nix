{ stdenv, fetchurl, glibc, mesa, freetype, glib, libSM, libICE, libXi, libXv
, libXrender, libXrandr, libXfixes, libXcursor, libXinerama, libXext, libX11, qt4
, zlib, fontconfig, xkeyboard_config, makeWrapper, dpkg }:

let
  arch =
    if stdenv.system == "x86_64-linux" then "amd64"
    else if stdenv.system == "i686-linux" then "i386"
    else abort "Unsupported architecture";
  sha256 =
    if arch == "amd64"
    then "05j4j93w64s3gzrp30v4h4sfcwbbndww7g9rkvg09c7rgkl374iw"
    else "0gndbxrj3kgc2dhjqwjifr3cl85hgpm695z0wi01wvwzhrjqs0l2";
  fullPath = stdenv.lib.makeLibraryPath [
    glibc
    glib
    stdenv.cc.cc
    libSM
    libICE
    libXi
    libXv
    mesa
    libXrender
    libXrandr
    libXfixes
    libXcursor
    libXinerama
    freetype
    libXext
    libX11
    qt4
    zlib
    fontconfig
    xkeyboard_config
  ];
in
stdenv.mkDerivation rec {
  version = "7.1.4.1529";
  name = "google-earth-${version}";

  src = fetchurl {
    url = "https://dl.google.com/earth/client/current/google-earth-stable_current_${arch}.deb";
    inherit sha256;
  };

  phases = "unpackPhase installPhase";

  nativeBuildInputs = [ dpkg makeWrapper ];

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase =''
    mkdir -p $out/bin
    mv * $out/
    makeWrapper $out/opt/google/earth/pro/googleearth \
          $out/bin/google-earth \
          --prefix "QT_XKB_CONFIG_ROOT" ":" "${xkeyboard_config}/share/X11/xkb"
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${fullPath}:\$ORIGIN" \
      $out/opt/google/earth/pro/googleearth-bin
    for a in $out/opt/google/earth/pro/*.so* ; do
      patchelf --set-rpath "${fullPath}:\$ORIGIN" $a
    done
  '';

  dontPatchELF = true;

  libPath = fullPath;

  meta = {
    description = "A world sphere viewer";
    homepage = http://earth.google.com;
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
