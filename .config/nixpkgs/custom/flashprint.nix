# FIXME: Slicing fail in the GUI, but works at the command line.

{
  stdenv, fetchurl, dpkg, patchelf, makeDesktopItem,
  gcc, mesa, qt5, udev
}:

let

  aname = "flashprint";
  version = "3.22.0";
  name = "${aname}-${version}";

in

  stdenv.mkDerivation rec {
    inherit name;
    src = fetchurl {
      name = "${name}.deb";
      url = "http://www.sz3dp.com/upfile/2018/03/30/20180330181621_276.deb";
      sha256 = "0cjlrmpyw772vcxc627214dg7x1x9a2hgil3llgjh3lqk33zk3sj";
    };

  nativeBuildInputs = [
    dpkg
  ];

  libPath = stdenv.lib.makeLibraryPath [
    qt5.qtbase
    gcc.cc
    mesa
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
