
{
  stdenv, fetchurl, dpkg, patchelf, makeDesktopItem,
  gcc, qt5
}:

let

  aname = "teigha";
  version = "4.3.2.0";
  name = "${aname}-${version}";

in

  stdenv.mkDerivation rec {
    inherit name;
    src = fetchurl {
      name = "${name}.deb";
      url = "https://download.opendesign.com/guestfiles/TeighaFileConverter/TeighaFileConverter_QT5_lnxX64_4.7dll.deb";
      sha256 = "07bwyg19336nlj69a402glm5pc2wvkg00xn5h3cd13vqnkjs2v6a";
    };

  nativeBuildInputs = [
    dpkg
  ];

  libPath = stdenv.lib.makeLibraryPath [
    qt5.qtbase
    gcc.cc
  ];
  dontStrip = true;

  unpackPhase = ''
    mkdir pkg
    dpkg-deb -x $src pkg
    sourceRoot=pkg
  '';

  installPhase = ''
    mkdir -p $out
    cp -pr usr/* $out/
    rm $out/bin/TeighaFileConverter
    ln -s $out/bin/TeighaFileConverter_${version}/TeighaFileConverter $out/bin/TeighaFileConverter
    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$out/bin/TeighaFileConverter_${version}:${libPath}" \
      $out/bin/TeighaFileConverter_${version}/TeighaFileConverter
  '';

  desktopItem = makeDesktopItem {
    name = aname;
    exec = "TeighaFileConverter";
    desktopName = "TeighaFileConverter";
    genericName = meta.description;
    categories = "Graphics";
    type = "Application";
    terminal = "false";
    icon = "#out#/share/icons/hicolor/64x64/apps/TeighaFileConverter.png";
  };

  meta = {
    homepage = https://www.opendesign.com/guestfiles/teigha_file_converter;
    description = "Teigha File Converter";
    longDescription = ''
      For converting between different versions of .dwg and .dxf
    '';
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
  };
}
