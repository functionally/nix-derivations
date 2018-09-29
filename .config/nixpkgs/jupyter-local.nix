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
        data_table
      # DBI
      # dplr
        FNN
        ggplot2
        GGally
      # highr
        Hmisc
      # httr
        igraph
        kernlab
      # knitr
        lubridate
      # quantmod
        RcppEigen
      # reshape2
      # shiny
      # SPARQL
      # sqldf
        stringr
      # TDA
        tidyr
      # yaml
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
  
    mbedtls = stdenv.mkDerivation rec {
      name = "mbedtls-2.1.1";
      buildInputs = [ cmake perl ];
      src = fetchurl {
        url = "https://cache.julialang.org/https://tls.mbed.org/download/mbedtls-2.1.1-apache.tgz";
        sha256 = "0mx7740vrdbbi81ggraz0cj96vcjaljb0n6c3glq2l5favqvc9cg";
      };
      installPhase = ''
        mkdir -p $out
        cp -r .  $out/
      '';
    };
    zmq = stdenv.mkDerivation rec {
      name = "zeromq-3.2.5";
      buildInputs = [ ];
      src = fetchurl {
        url = "https://github.com/zeromq/zeromq3-x/releases/download/v3.2.5/zeromq-3.2.5.tar.gz";
        sha256 = "0911r7q4i1x9gnfinj39vx08fnz59mf05vl75zdkws36lib3wr89";
      };
      installPhase = ''
        mkdir -p $out
        cp -r .  $out/
      '';
    };
    src_METADATA = fetchgit {
      url = "https://github.com/JuliaLang/METADATA.jl.git";
      rev = "87047e227c95ff1331978dd9dc9ce8ff0fc676d0";
      sha256 = "11n0yj98kidcmn3nn1m645vixn41fia85pdxw7s2p3crfjx7q2k2";
      fetchSubmodules = true;
      leaveDotGit = true;
    };
    src_BinDeps = fetchgit {
      url = "https://github.com/JuliaLang/BinDeps.jl.git";
      rev = "264e086062f3c39adba7997f187bd54bc0e6b218";
      sha256 = "04r05p4mj4hdy8djp3qpn97cf83l9yiq6n1cafi7gpn9h408rsd1";
      fetchSubmodules = true;
      leaveDotGit = true;
    };
    src_Compat = fetchgit {
      url = "https://github.com/JuliaLang/Compat.jl.git";
      rev = "956b34b719347e6ebaec9b920bfeca7b4d42d593";
      sha256 = "19r8vblajs8y1ibhhgaib8xsa5lcbk80jkbq7fvrhn6dzlmmcc0a";
      fetchSubmodules = true;
      leaveDotGit = true;
    };
    src_Conda = fetchgit {
      url = "https://github.com/JuliaPy/Conda.jl.git";
      rev = "f7a05aa054d653cf40feb62084305fc84136bfd1";
      sha256 = "0wsrf8wlw58xacvsd73fnavpkhlgv3j3zfb325xmfiyzdcgh1nh1";
      fetchSubmodules = true;
      leaveDotGit = true;
    };
    src_IJulia = fetchgit {
      url = "https://github.com/JuliaLang/IJulia.jl.git";
      rev = "70d1b9022bbb6c403f36c1143d2f716ce7c51a00";
      sha256 = "1f76615a459xb88nzfhgvll465v3s18l9ars4gwb492s4f50ijiy";
      fetchSubmodules = true;
      leaveDotGit = true;
    };
    src_JSON = fetchgit {
      url = "https://github.com/JuliaIO/JSON.jl.git";
      rev = "565fa448a345c62591c007916255ffd4c235fc09";
      sha256 = "10qd1avq4xm8wap6l7ba879a0jd2j27nmhg74rdsx4hprmdiya04";
      fetchSubmodules = true;
      leaveDotGit = true;
    };
    src_MbedTLS = fetchgit {
      url = "https://github.com/JuliaWeb/MbedTLS.jl.git";
      rev = "173250ee12dc581fa8f22d8ab5173a89e528497e";
      sha256 = "1489bn3x2li1mxwwf6f134mvc6xxwq96zmgrhmc7xa380g7wqizc";
      fetchSubmodules = true;
      leaveDotGit = true;
    };
    src_SHA = fetchgit {
      url = "https://github.com/staticfloat/SHA.jl.git";
      rev = "337a8f78f450c6a0a1dc50ed1a43eca00bc558e7";
      sha256 = "1d04w0lbw6vpnr01xdj7h0l88q5cd0v0la3ypnsnwgi5dx6h27vs";
      fetchSubmodules = true;
      leaveDotGit = true;
    };
    src_URIParser = fetchgit {
      url = "https://github.com/JuliaWeb/URIParser.jl.git";
      rev = "0ee051738dab941a467f1d49bead09b1d100a1c0";
      sha256 = "07i9vavsk22xhkl3x2h8zskpsnv0vss9aq377xz9hvawl9yvgbk8";
      fetchSubmodules = true;
      leaveDotGit = true;
    };
    src_ZMQ = fetchgit {
      url = "https://github.com/JuliaInterop/ZMQ.jl.git";
      rev = "581a9d6f1890973c168af89d87ebeeebc0d2881b";
      sha256 = "17jylc8pak5q5zca4xl0064xfhw61k5j53mffz6ws6vxw4r5rvgv";
      fetchSubmodules = true;
      leaveDotGit = true;
    };

    jupyter_config_dir = stdenv.mkDerivation {
      name = "jupyter-config";
      buildInputs = [
        python3Packages.jupyter
        haskellPackages.ihaskell
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
        HOME=$out ${haskellPackages.ihaskell}/bin/ihaskell install --prefix=$out
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
      python3Packages.bokeh
      python3Packages.bootstrapped-pip
      python3Packages.cachetools
      python3Packages.fiona
      python3Packages.flask
      python3Packages.geopandas
    # python3Packages.ggplot
      python3Packages.h5py
    # python3Packages.json
      python3Packages.Keras
      python3Packages.matplotlib
      python3Packages.numpy
      python3Packages.pandas
      python3Packages.plotly
      python3Packages.pydot
    # python3Packages.pytorch
      python3Packages.scikitlearn
      python3Packages.scipy
      python3Packages.scrapy
      python3Packages.seaborn
      python3Packages.shapely
      python3Packages.spyder
      python3Packages.statsmodels
      python3Packages.tensorflow
      python3Packages.Theano
      python3Packages.websockets
      python3Packages.xgboost
      sparql-kernel python3Packages.notebook python3Packages.SPARQLWrapper python3Packages.rdflib graphviz
      julia cmake gcc gfortran perl # clp blas liblapack glpk metis cbc
      gmp mpfr
    ];
    shellHook = ''
      mkdir -p $PWD/.R
      cp -nr ${jupyter_config_dir}/.jupyter  $PWD/
      cp -nr ${jupyter_config_dir}/.ihaskell $PWD/
      chmod -R u+w .R .jupyter .ihaskell
      export HOME=$PWD
      export JUPYTER_PATH=${jupyter_config_dir}/share/jupyter
      export JUPYTER_CONFIG_DIR=${jupyter_config_dir}/share/jupyter
#     jupyter notebook --no-browser
#     exit
    '';
  }
