{
  pkgs
}:

  with pkgs;
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
        version = "1.1.0";
      in
        deriveR {
          name = "r-${aname}-${version}";
          src = fetchgit {
            url = "https://github.nrel.gov/InsightCenter/iplot.git";
            rev = "f9d6090bceabc83bda520452c8b0098610ad3d64";
            sha256="0ynrm3v68b2f20s8kc4x23hcxfnyzhzpn6ig9x47zs90yn5zdn9n";
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

    buildEnv {
      name = "env-r";
      # Custom R environment.
      paths = with rPackages; [
#   super.rstudioWrapper.override {
#     packages = with self.rPackages; [
        R
        abind
        arm
        BH
        bnlearn
        causaleffect
        circlize
        codetools
        crayon
        dagitty
        data_table
        DBI
        deSolve
        devtools
        digest
      # dplr
        evaluate
        fitdistrplus
        FNN
        GGally
        ggplot2
        glmulti
      # gRain
        graph
        GSAR
        highr
        Hmisc
        httr
        igraph
        InformationValue
      # iplot
        jsonlite
        keras
        kernlab
        knitr
        kSamples
        LaplacesDemon
        lavaan
        lhs
        lubridate
        magrittr
        MASS
        memo
        mlogit
        mnlogit
        modes
        multinomRob
        nnet
        np
        pbdZMQ
      # pcalg
        plotrix
        quantmod
        quantreg
        randtoolbox
        Rcpp
        RcppEigen
        Rgraphviz
        regclass
        repr
        reshape2
        rpart
        rTensor
        sensitivity
        shiny
        shinyjs
        smbinning
        SobolSequence
        SPARQL
        sqldf
        stringr
      # TDA
        tensorflow
        tidyr
        uuid
        yaml
      ];
    }
