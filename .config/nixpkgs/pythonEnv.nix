{
  pkgs
, base
, excludeList
}:

let

  python =
    let
      packageOverrides = self: super: {
#       tensorFlow = pkgs.python3Packages.tensorflow;
      };
    in
      base.python36.override { inherit packageOverrides; };

in

  pkgs.buildEnv {
    name = "env-python";
    # Custom Python environment.
    paths = [
      pkgs.atom
      pkgs.spyder
      (python.withPackages (ps: with ps; [
        async-timeout
        asyncio
        bokeh
        bootstrapped-pip
      # catboost
        cufflinks
      # dist-keras
      # elephas
      # eli5
        fiona
        flask
        gensim
        geopandas
      # ggplot
        h5py
      # json
        jupyter
      # lightgbm
        matplotlib
        networkx
        nltk
        numpy
        pandas
        pip
        plotly
        protobuf
        pydot
        rasterio
        scikitlearn
        scipy
      # scrapy
        seaborn
      # snakes
      # spacy
      # spark-deep-learning
        statsmodels
      # tensorflow_hub
      # tensorflowjs
      # Theano
        websockets
        xgboost
      ]
      ++ excludeList [
        Keras
        pytorch
        tensorflow
      ]))
    ];
  }
