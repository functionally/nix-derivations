# FIXME: Slicing fail in the GUI, but works at the command line.

{
  stdenv, fetchurl, dpkg, patchelf, makeDesktopItem,
  gcc, libGL, libGLU, qt5, udev
}:

let

  aname = "flashprint";
  version = "3.28.0";
  name = "${aname}-${version}";

in

  stdenv.mkDerivation rec {
    inherit name;
    src = fetchurl {
      name = "${name}.deb";
      url = "http://en.fss.flashforge.com/10000/software/a33f804f90a30e66e47bc75b6b6e6d7d.deb";
      sha256 = "15cvhhf0j38c98ap6cjxw51lriz8wyhzrdpmqi7wqpin6y0kd6nc";
    };

  nativeBuildInputs = [
    dpkg
  ];

  libPath = stdenv.lib.makeLibraryPath [
    qt5.qtbase
    libGL
    libGLU
    gcc.cc
    udev
  ];
##dontStrip = true;

  unpackPhase = ''
    mkdir pkg
    dpkg-deb -x $src pkg
    sourceRoot=pkg
  '';

  installPhase = ''
    mkdir -p $out/share/${name} $out/bin
    cp -pr usr/share/* $out/share/${name}/
    ln -s $out/share/${name}/FlashPrint/FlashPrint $out/bin/FlashPrint
    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/share/${name}/FlashPrint/FlashPrint
    ln -s $out/share/${name}/FlashPrint/engine/ffslicer.exe $out/bin/ffslicer.exe
    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/share/${name}/FlashPrint/engine/ffslicer.exe
  '';

  desktopItem = makeDesktopItem {
    name = aname;
    exec = "FlashPrint";
    desktopName = "FlashPrint";
    genericName = meta.description;
    categories = "Graphics";
    type = "Application";
    terminal = "false";
    icon = "#out#/share/${name}/icons/hicolor/64x64/apps/flashforge.png";
  };

  meta = {
    homepage = http://www.flashforge.com/flashprint/;
    description = "3D printing software by FlashForge.";
    longDescription = ''
      Flashprint,the mainstream slice software used by FlashForge, has gained outstanding reviews by the media and professionals.The software further offers an expert mode，which allows dozens of parameters to be set by the user, for greater printing flexibility.
    '';
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
  };
}
