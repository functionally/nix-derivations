{ stdenv, fetchurl, unzip, jre }:

let

  name = "protege-${version}";
  version = "5.2.0";

in

  stdenv.mkDerivation rec {

    inherit name;

    src = fetchurl {
      name = "Protege-${version}-platform-independent.zip";
      url = https://github-production-release-asset-2e65be.s3.amazonaws.com/42326586/4d407ec0-08dd-11e7-94f7-5fe186a4f36f?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20170903%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20170903T133642Z&X-Amz-Expires=300&X-Amz-Signature=a6b3fb18c51220b75f8bdae5497ad12bd25497e651413093f9b973b8c314297d&X-Amz-SignedHeaders=host&actor_id=2235898&response-content-disposition=attachment%3B%20filename%3DProtege-5.2.0-platform-independent.zip&response-content-type=application%2Foctet-stream;
      sha256 = "7585ecdf3bfec6cf009bb69ea0f5a6063de0339ce64bff81462b7415f133a5f0";
    };

    buildInputs = [ unzip ];

    buildCommand = ''
      mkdir -p $out/share $out/bin
      cd $out
      unzip $src -d share
      sed -e "2,10d"                              \
          -e "1acd $out/share/Protege-${version}" \
          -e "s@^java@${jre}/bin//&@"             \
          $out/share/Protege-${version}/run.sh    > bin/protege
      chmod a+x bin/protege
    '';

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
