{ stdenv, fetchgit, fetchurl, R, rPackages, openssl, zlib }:

let

  deriveR = {name, src, buildInputs, postPatch}:
    stdenv.mkDerivation {
      inherit name;
      inherit src;
      inherit postPatch;
      buildInputs = [R] ++ buildInputs;
      configurePhase = ''
        runHook preConfigure
        export R_LIBS_SITE="$R_LIBS_SITE''${R_LIBS_SITE:+:}$out/library"
        runHook postConfigure
      '';
      buildPhase = ''
        runHook preBuild
        runHook postBuild
      '';
      installFlags = [];
      rCommand = "R";
      installPhase = ''
        runHook preInstall
        mkdir -p $out/library
        $rCommand CMD INSTALL $installFlags --configure-args="$configureFlags" -l $out/library .
        runHook postInstall
      '';
      postFixup = ''
        if test -e $out/nix-support/propagated-native-build-inputs; then
            ln -s $out/nix-support/propagated-native-build-inputs $out/nix-support/propagated-user-env-packages
        fi
      '';
      checkPhase = ''
        # noop since R CMD INSTALL tests packages
      '';
  };

  roxygen2 =
    let
      aname = "roxygen2";
      version = "6.0.1";
      snapshot = "2017-11-27";
    in
      deriveR {
        name = "r-${aname}-${version}";
        src = fetchurl {
          name = "${aname}-${version}.tar.gz";
          url = "http://mran.revolutionanalytics.com/snapshot/${snapshot}/src/contrib/${aname}_${version}.tar.gz";
          sha256="0xpzziminf225kjwhyl51kgkzhplyzhk5farhf5s822krl2xqbfj";
        };
        buildInputs = [
          rPackages.brew
          rPackages.commonmark
          rPackages.desc
          rPackages.digest
          rPackages.R6
          rPackages.Rcpp
          rPackages.stringi
          rPackages.stringr
          rPackages.xml2
        ];
      };

  iplot =
    let
      aname = "iplot";
      version = "dev";
    in
      deriveR {
        name = "r-${aname}-${version}";
        src = fetchgit {
          url = "https://github.nrel.gov/InsightCenter/iplot";
          rev = "1177irxsddg70kmpg9jbi5fxp8k635zfr0h9ch6jf589jx0fz00";
          sha256="1177irxsddg70kmpg9jbi5fxp8k635zfr0h9ch6jf589jx0fz00b";
        };
        postPatch = "
          sed -e '/Imports/s/0\.12\.13/0.12.11/' -i DESCRIPTION
        ";
        buildInputs = [
          openssl
          zlib
          rPackages.Rcpp
          rPackages.jsonlite
        ];
      };

in

  stdenv.mkDerivation rec {
    name = "r-iplot-local";
    buildInputs = [
      R
      iplot
      rPackages.data_table
      rPackages.ggplot2
      rPackages.jsonlite
      rPackages.Rcpp
    ];
    shellHook = ''
      R
      exit
    '';
  }
