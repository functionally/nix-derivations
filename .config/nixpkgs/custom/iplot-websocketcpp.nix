{gitLocal ? true, stdenv, fetchgit, openssl, zlib, R, rPackages}:

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

  websockets =
    deriveR {
      name = "r-websockets-0.0.0.9000";
      src = fetchgit {
        url    = "https://github.com/rstudio/websocket.git";
        rev    = "d572af5dec5a35db17f021a9540e783d6e3a2f4c";
        sha256 ="0i76d8cmdnbfb19y1ia7w3n31gj4c2q9793gavjc0zm1428l6prj";
      };
      postPatch = ''
      '';
      buildInputs = [
        openssl
        rPackages.Rcpp
        rPackages.R6
        rPackages.later
        rPackages.BH
        rPackages.AsioHeaders
      ];
    };
in

  let
    aname = "iplot-websocketcpp";
    version = "1.1.0-2519e9";
  in
    deriveR {
      name = "r-${aname}-${version}";
      src = fetchgit {
        url    = if gitLocal
                   then "git://127.0.0.1/"
                   else "https://github.nrel.gov/InsightCenter/iplot.git";
        rev    = "2519e9b4f9c73ca3bbe5df57b1a8a30227c8ee6a";
        sha256 ="0g2c3yjgx3ciqlm5y78qdjqvfd5rbyxafddvdkxax99z7flrrd7b";
      };
      postPatch = ''
      '';
      buildInputs = [
        openssl
        zlib
        rPackages.codetools
        rPackages.Rcpp
        rPackages.jsonlite
        websockets
      ];
    }
