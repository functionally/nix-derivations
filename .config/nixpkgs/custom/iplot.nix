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

in

  let
    aname = "iplot";
    version = "1.1.0-74c4daa";
  in
    deriveR {
      name = "r-${aname}-${version}";
      src = fetchgit {
        url    = if gitLocal
                   then "git://127.0.0.1/"
                   else "https://github.nrel.gov/InsightCenter/iplot.git";
        rev    = "74c4daa6772a54dce97a5258fd3b37afc0fd9c0e";
        sha256 ="008za795lldfn29qlb6wagcz3y9qkhrh0ykygavhlnniv3rw3pz5";
      };
      postPatch = ''
      '';
      buildInputs = [
        openssl
        zlib
        rPackages.codetools
        rPackages.Rcpp
        rPackages.jsonlite
      ];
    }
