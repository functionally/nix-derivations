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
        BH
        circlize
        codetools
        data_table
        DBI
      # dplr
        FNN
        GGally
        ggplot2
        highr
        Hmisc
        httr
        igraph
      # iplot
        keras
        kernlab
        knitr
        kSamples
        lubridate
        memo
        plotrix
        quantmod
        Rcpp
        RcppEigen
        reshape2
        rpart
        shiny
        shinyjs
        SPARQL
        sqldf
        stringr
      # TDA
        tensorflow
        tidyr
        yaml
      ];
    };
  
    sparql-kernel = python3.pkgs.buildPythonPackage {
      name = "sparqlkernel-1.0.5";
      buildInputs = [ python3Packages.notebook python3Packages.SPARQLWrapper python3Packages.rdflib ];
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
        python3Packages.jupyter
        IRkernel
        sparql-kernel python3Packages.notebook python3Packages.SPARQLWrapper python3Packages.rdflib graphviz
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
      python3Packages.jupyter jupyter_config_dir
      python3Packages.async-timeout
      python3Packages.asyncio
      python3Packages.bokeh
      python3Packages.bootstrapped-pip
    # python3Packages.catboost
    # python3Packages.dist-keras
    # python3Packages.elephas
    # python3Packages.eli5
      python3Packages.fiona
      python3Packages.flask
      python3Packages.gensim
      python3Packages.geopandas
    # python3Packages.ggplot
      python3Packages.h5py
    # python3Packages.json
      python3Packages.jupyter
      python3Packages.Keras
    # python3Packages.lightgbm
      python3Packages.matplotlib
      python3Packages.nltk
      python3Packages.numpy
      python3Packages.pandas
      python3Packages.pip
    #                 pipenv
      python3Packages.plotly
      python3Packages.protobuf
      python3Packages.pydot
    # python3Packages.pytorch
    # python3Packages.rasterio
      python3Packages.scikitlearn
      python3Packages.scipy
      python3Packages.scrapy
      python3Packages.seaborn
      python3Packages.spacy
    # python3Packages.spark-deep-learning
    # python3Packages.spyder
    # python3Packages.statsmodels
      python3Packages.tensorflow
    # python3Packages.tensorflow_hub
    # python3Packages.tensorflowjs
    # python3Packages.Theano
      python3Packages.websockets
      python3Packages.xgboost
      sparql-kernel python3Packages.notebook python3Packages.SPARQLWrapper python3Packages.rdflib graphviz
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
