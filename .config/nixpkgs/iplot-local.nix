with import <nixpkgs> {};

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

  iplot =
    let
      aname = "iplot";
      version = "1.0";
    in
      deriveR {
        name = "r-${aname}-${version}";
        src = fetchgit {
          url = "https://github.nrel.gov/bbush/iplot";
          rev = "e36ce4dbebd646f21fd11cf71a9f270829cd87ff";
          sha256="0x1p9vns8jmkkw2wf4zhlqxky97a2rnnikq73d8x3bvb7hxdyjmf";
        };
        postPatch = ''
        '';
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
    phases = "buildPhase";
    dontBuild = true;
    buildInputs = [
      R
      iplot
      rPackages.codetools
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
