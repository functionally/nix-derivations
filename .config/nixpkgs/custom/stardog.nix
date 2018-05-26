{ stdenv, fetchgit, unzip, jre }:

let

  aname = "stardog";
  name = "${aname}-${version}";
  version = "5.0.2";

in

  stdenv.mkDerivation rec {

    inherit name;

    src = fetchgit {
      url    = "git://127.0.0.1/";
      rev    = "07a79f9c66a4d5f4836b69eca5d2b54879ef819d";
      sha256 = "1rw9nqcjp6kl6ygz9g9dg512hlxsqcwm9a75bha20pb2gxnk2yjf";
    };

    buildInputs = [ unzip ];

    buildCommand = ''
      mkdir -p $out/share/applications
      cd $out
      unzip $src/stardog-5.0.2.zip -d share
      patchShebangs share/stardog-5.0.2/bin/stardog
      patchShebangs share/stardog-5.0.2/bin/stardog-admin
      patchShebangs share/stardog-5.0.2/bin/stardog-server
      patchShebangs share/stardog-5.0.2/bin/stardog-completion.sh
      patchShebangs share/stardog-5.0.2/bin/helpers.sh
      ln -s $out/share/stardog-5.0.2/bin
      sed -i -e 's@..JAVA_HOME.@${jre}@g' share/stardog-5.0.2/bin/{stardog,stardog-admin,stardog-server,helpers.sh}
    '';

    meta = {
      homepage = https://protege.stanford.edu/;
      description = "The knowledge graph platform for the enterprise.";
      longDescription = ''
        With Stardog you can unify, query, search, and analyze all your data.
      '';
      platforms = stdenv.lib.platforms.linux;
    };

  }
