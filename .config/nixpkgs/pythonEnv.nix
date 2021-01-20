{
  pkgs
}:

let

  python =
    let
      packageOverrides = self: super: {
        scikitlearn = super.scikitlearn.overridePythonAttrs(old: {doCheck = false;});
      };
    in
      pkgs.python37.override {inherit packageOverrides;};

in

  pkgs.buildEnv {
    name = "env-python";
    # Custom Python environment.
    paths = [
      (python.withPackages (ps: with ps; [
        async-timeout
      # bokeh
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
        plotly
        protobuf
        psycopg2
        pydot
        pydotplus
        pyomo
      # pytorch
        rasterio
        recommonmark
      # SALib
        scikitlearn
        scipy
      # scrapy
        seaborn
      # snakes
      # spacy
      # spark-deep-learning
        sphinx
        statsmodels
        sympy
        tensorflow
      # tensorflow_hub
      # tensorflowjs
        Theano
        websockets
        xgboost
      ]))
    ];
  }
