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
        arm
        BH
        circlize
        codetools
        data_table
        DBI
      # dplr
        FNN
        GGally
        glmulti
        ggplot2
        highr
        Hmisc
        httr
        igraph
        InformationValue
      # iplot
        keras
        kernlab
        knitr
        kSamples
        lubridate
        magrittr
        memo
        plotrix
        quantmod
        quantreg
        Rcpp
        RcppEigen
        regclass
        reshape2
        rpart
        shiny
        shinyjs
        smbinning
        SPARQL
        sqldf
        stringr
      # TDA
        tensorflow
        tidyr
        yaml
      ];
    };
  
    sparql-kernel = python36.pkgs.buildPythonPackage {
      name = "sparqlkernel-1.0.5";
      buildInputs = [ python36Packages.notebook python36Packages.SPARQLWrapper python36Packages.rdflib ];
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
        python36Packages.jupyter
        IRkernel
        sparql-kernel python36Packages.notebook python36Packages.SPARQLWrapper python36Packages.rdflib graphviz
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

in

  with dependencies;
  stdenv.mkDerivation rec {
    name = "jupyter-local";
    buildInputs = [
      jupyter_config_dir
      python36Packages.async-timeout
    # python36Packages.asyncio
      python36Packages.bokeh
      python36Packages.bootstrapped-pip
    # python36Packages.catboost
      python36Packages.cufflinks
    # python36Packages.dist-keras
    # python36Packages.elephas
    # python36Packages.eli5
      python36Packages.fiona
      python36Packages.flask
      python36Packages.gensim
      python36Packages.geopandas
    # python36Packages.ggplot
      python36Packages.h5py
    # python36Packages.json
      python36Packages.jupyter
      python36Packages.Keras
      python36Packages.lightgbm
      python36Packages.matplotlib
      python36Packages.networkx
      python36Packages.nltk
      python36Packages.numpy
      python36Packages.pandas
      python36Packages.pip
    #                  pipenv
      python36Packages.plotly
      python36Packages.protobuf
      python36Packages.pydot
      python36Packages.pydotplus
      python36Packages.pyomo
      python36Packages.pytorch
      python36Packages.rasterio
      python36Packages.scikitlearn
      python36Packages.scipy
      python36Packages.scrapy
      python36Packages.seaborn
    # python36Packages.snakes
      python36Packages.spacy
    # python36Packages.spark-deep-learning
      python36Packages.statsmodels
      python36Packages.tensorflow
    # python36Packages.tensorflow_hub
    # python36Packages.tensorflowjs
      python36Packages.Theano
      python36Packages.websockets
      python36Packages.xgboost
      cbc glpk ipopt
      sparql-kernel python36Packages.notebook python36Packages.SPARQLWrapper python36Packages.rdflib graphviz
      gmp mpfr
    ];
    shellHook = ''
      mkdir -p $PWD/.R
      cp -nr ${jupyter_config_dir}/.jupyter  $PWD/
      chmod -R u+w .R .jupyter
      export HOME=$PWD
      export JUPYTER_PATH=${jupyter_config_dir}/share/jupyter
      export JUPYTER_CONFIG_DIR=${jupyter_config_dir}/share/jupyter
#     jupyter notebook --no-browser
#     exit
    '';
  }
