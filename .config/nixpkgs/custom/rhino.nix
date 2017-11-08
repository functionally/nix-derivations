{ stdenv, fetchurl, unzip, jre, makeWrapper }:

let

  aname = "rhino";
  name = "${aname}-${version}";
  version = "1.7.7.2";

in

  stdenv.mkDerivation rec {

    inherit name;

    src = fetchurl {
      name = "rhino-${version}.zip";
      url = "https://github.com/mozilla/rhino/releases/download/Rhino1_7_7_2_Release/rhino-1.7.7.2.zip";
      sha256 = "0iq2m9x2501l50kqk9v3lzbbpz3i4aapxajsndhh0dnx2xbmj8xj";
    };

    nativeBuildInputs = [ unzip ];
    buildInputs = [ makeWrapper ];

    buildCommand = ''
      mkdir -p $out/share/java $out/bin
      unzip -j $src rhino1.7.7.2/lib/rhino-1.7.7.2.jar -d $out/share/java/
      makeWrapper "${jre}/bin/java" "$out"/bin/rhino --add-flags "-jar $out/share/java/rhino-1.7.7.2.jar"
    '';

    meta = {
      homepage = "https://developer.mozilla.org/en-US/docs/Mozilla/Projects/Rhino";
      description = "Rhino is an open-source implementation of JavaScript written entirely in Java.";
      longDescription = ''
        Rhino is an open-source implementation of JavaScript written entirely in Java. It is typically embedded into Java applications to provide scripting to end users. It is embedded in J2SE 6 as the default Java scripting engine.
      '';
      platforms = stdenv.lib.platforms.all;
      license = stdenv.lib.licenses.mpl20;
    };

  }
