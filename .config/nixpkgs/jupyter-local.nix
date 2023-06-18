with import <nixpkgs> {};

let

  dependencies = rec {

    IRdisplay = stdenv.mkDerivation rec {
      name = "IRdisplay";
      buildInputs = [ R ];
      src = fetchgit {
        url = "https://github.com/IRkernel/IRdisplay";
        rev = "6f2757549d8902f3928e1e2eacadf1c65e3931a8";
        sha256 = "179safd480g2s60fp6kca9sxgsgf925rf852pc6lz0qr1ggkwc7d";
        fetchSubmodules = true;
      };
      buildPhase = ":";
      installPhase = ''
        mkdir -p $out
        export R_LIBS=$out
        ${R}/bin/R CMD INSTALL .
      '';
    };
  
    IRkernel = stdenv.mkDerivation rec {
      name = "IRkernel";
      buildInputs = [ R IRdisplay ];
      src = fetchgit {
        url ="https://github.com/IRkernel/IRkernel";
        rev ="39456a0596bbe39257f60b1567d6029c5497961e";
        sha256 = "1zwgahkz7678y1hrd7wmc13dy4zwwihawp3nxkdd1a365hqjvbin";
        fetchSubmodules= false;
      };
      buildPhase = ":";
      installPhase = ''
        mkdir -p $out
        export R_LIBS=$out:${IRdisplay}
        ${R}/bin/R CMD INSTALL .
      '';
    };
  
    R = rWrapper.override {
      packages = with rPackages; [
        # Kernel
        crayon
        digest
        evaluate
        jsonlite
        pbdZMQ
        repr
        uuid
        # Custom packages
        abind
        arm
        BH
        bnlearn
        caTools
        causaleffect
        circlize
        codetools
        crayon
        dagitty
        data_table
        deSolve
        DBI
        deSolve
        devtools
        digest
      # dplr
        evaluate
        fitdistrplus
        FNN
        GGally
        ggdendro
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
        PerMallows
        plotrix
        quantmod
        quantreg
        randtoolbox
        Rcpp
        RcppEigen
        Rgraphviz
        RPostgreSQL
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
    };
  
    sparql-kernel = python37.pkgs.buildPythonPackage {
      name = "sparqlkernel-1.0.5";
      buildInputs = [ python37Packages.notebook python37Packages.SPARQLWrapper python37Packages.rdflib ];
      src = fetchgit {
        url = "https://github.com/paulovn/sparql-kernel";
        rev = "f91d56a029ebb2a8517181a124437e02c1e226c7";
        sha256 = "0lr5zybl7rg4xv9qxrc03sn7zx79fp0qgxkzghfrk8vwci9xhlq9";
        fetchSubmodules = true;
      };
      meta = {
        homepage = https://github.com/paulovn/sparql-kernel/;
        description = "A Jupyter kernel to launch queries against SPARQL endpoints.";
        license = stdenv.lib.licenses.bsd3;
      };
    };
  
    jupyter_config_dir = stdenv.mkDerivation {
      name = "jupyter-config";
      buildInputs = [
        python37Packages.jupyter
        IRkernel
        sparql-kernel python37Packages.notebook python37Packages.SPARQLWrapper python37Packages.rdflib graphviz
      ];
      ir_json = builtins.toJSON {
        argv = [ "${R}/bin/R"
                 "--slave" "-e" "IRkernel::main()"
                 "--args" "{connection_file}" ];
        env = { "R_LIBS_USER" = ".R:${IRkernel}:${IRdisplay}"; };
        display_name = "R";
        language = "R";
      };
      builder = writeText "builder.sh" ''
        source $stdenv/setup
        mkdir -p $out/share/jupyter/kernels/ir
        echo $out
        echo $R_SITE_LIBS
        cat > $out/share/jupyter/kernels/ir/kernel.json << EOF
        $ir_json
        EOF
        HOME=$out jupyter sparqlkernel install --user
        mv $out/{.local/,}share/jupyter/kernels/sparql
      '';
    };

  };

  python =
    let
      packageOverrides = self: super: {
        scikitlearn = super.scikitlearn.overridePythonAttrs(old: {doCheck = false;});
      };
    in
      pkgs.python37.override {inherit packageOverrides;};

in

  with dependencies;
  stdenv.mkDerivation rec {
    name = "jupyter-local";
    buildInputs = [
      jupyter_config_dir

      (python.withPackages (ps: with ps; [
        async-timeout
      # asyncio
        bokeh
        bootstrapped-pip
      # catboost
      # cufflinks
      # dist-keras
      # elephas
      # eli5
        fiona
      # flask
        gensim
        geopandas
      # ggplot
      # GUDHI
        h5py
      # json
        jupyter
        Keras
        lightgbm
        matplotlib
        networkx
        nltk
        numpy
        pandas
        pip
      # pipenv
        plotly
        protobuf
        psycopg2
        pydot
        pydotplus
        pyomo
#       pytorch
        rasterio
      # SALib
        scikitlearn
        scipy
      # scrapy
        seaborn
      # snakes
      # spacy
      # spark-deep-learning
        statsmodels
        sympy
        tensorflow
      # tensorflow_hub
      # tensorflowjs
        Theano
        websockets
        xgboost
      ]))
      cbc glpk ipopt
      sparql-kernel python37Packages.notebook python37Packages.SPARQLWrapper python37Packages.rdflib graphviz
      gmp mpfr
    ];
    shellHook = ''
      mkdir -p $PWD/.R
      export HOME=$PWD
      export JUPYTER_PATH=${jupyter_config_dir}/share/jupyter
      export JUPYTER_CONFIG_DIR=${jupyter_config_dir}/share/jupyter
#     jupyter notebook --no-browser
#     exit
    '';
  }
