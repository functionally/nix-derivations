{ stdenv, fetchurl, makeDesktopItem, jre } :

let

  aname = "processing";
  name = "${aname}-${version}";
  version = "3.3.6";
  target = "$out/share/${name}";

in

  stdenv.mkDerivation rec {

    inherit name;

    src = fetchurl {
      name = "${name}-linux64.tgz";
      url = "http://download.processing.org/${name}-linux64.tgz";
      sha256 = "0q3h9xqgdiwps8lzg88nk3mif1lq9sc0hbxph3qw69f6dmd10c7n";
    };

    buildInputs = [
      jre
    ];

    installPhase = ''
      mkdir -p ${target} $out/bin
      cp -r . ${target}
      rm -r ${target}/java
      ln -s ${jre} ${target}/java
      ln -s ${target}/processing $out/bin/processing
    '';

    desktopItem = makeDesktopItem {
      name = aname;
      exec = "processing";
      desktopName = "Processing";
      genericName = meta.description;
      categories = "Graphics;";
      type = "Application";
      terminal = "false";
    };
 
    meta = {
      homepage = https://processing.org/;
      description = "Processing is a flexible software sketchbook and a language for learning how to code within the context of the visual arts.";
      longDescription = ''
        Processing is a flexible software sketchbook and a language for learning how to code within the context of the visual arts. Since 2001, Processing has promoted software literacy within the visual arts and visual literacy within technology. There are tens of thousands of students, artists, designers, researchers, and hobbyists who use Processing for learning and prototyping.
      '';
      platforms = stdenv.lib.platforms.linux;
      license = stdenv.lib.licenses.gpl2Plus;
    };

  }
