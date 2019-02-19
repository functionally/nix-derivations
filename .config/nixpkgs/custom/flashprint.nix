# FIXME: Slicing fail in the GUI, but works at the command line.

{
  stdenv, fetchurl, dpkg, patchelf, makeDesktopItem,
  gcc, libGL, libGLU, qt59, udev
}:

let

  aname = "flashprint";
  version = "3.25.1";
  name = "${aname}-${version}";

in

  stdenv.mkDerivation rec {
    inherit name;
    src = fetchurl {
      name = "${name}.deb";
      url = "http://www.sz3dp.com/upfile/2018/12/03/20181203162713_662.deb";
      sha256 = "1haxm7s1d5chnvrl9sjdp45n5ph3pz8q984m8jqdcbampfvh7c1b";
    };

  nativeBuildInputs = [
    dpkg
  ];

  libPath = stdenv.lib.makeLibraryPath [
    qt59.qtbase
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
