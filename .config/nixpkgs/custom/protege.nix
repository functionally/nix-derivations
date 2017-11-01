{ stdenv, fetchurl, unzip, jre, makeDesktopItem }:

let

  aname = "protege";
  name = "${aname}--${version}";
  version = "5.2.0";
  target = "$out/share/Protege-${version}";

in

  stdenv.mkDerivation rec {

    inherit name;

    src = fetchurl {
      name = "Protege-${version}-platform-independent.zip";
      url = https://github.com/protegeproject/protege-distribution/releases/download/v5.2.0/Protege-5.2.0-platform-independent.zip;
      sha256 = "1w556gqiax1b8s0zyjz6khry0g86lvss17mnkc0czipy7ggyr1bm";
    };

    buildInputs = [ unzip ];

    buildCommand = ''
      mkdir -p $out/share/applications $out/bin
      cd $out
      unzip $src -d share
      sed -e "2,10d"                  \
          -e "1acd ${target}"         \
          -e "s@^java@${jre}/bin//&@" \
          ${target}/run.sh            > bin/protege
      chmod +x bin/protege
      sed -e "s@#out#@$out@" ${desktopItem}/share/applications/${aname}.desktop > $out/share/applications/${aname}.desktop
    '';

    desktopItem = makeDesktopItem {
      name = aname;
      exec = "protege";
      desktopName = "Protégé Desktop";
      genericName = meta.description;
      categories = "Development;";
      type = "Application";
      terminal = "false";
      icon = "#out#/share/Protege-${version}/app/Protege.ico";
    };

    meta = {
      homepage = https://protege.stanford.edu/;
      description = "Protégé Desktop is a feature rich ontology editing environment.";
      longDescription = ''
        Protégé Desktop is a feature rich ontology editing environment with full support for the OWL 2 Web Ontology Language, and direct in-memory connections to description logic reasoners like HermiT and Pellet.
      '';
      platforms = stdenv.lib.platforms.linux;
      license = stdenv.lib.licenses.mit;
    };

  }
