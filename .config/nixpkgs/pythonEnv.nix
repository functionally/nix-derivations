{
  pkgs
}:

pkgs.buildEnv {
  name = "env-python";
  # Custom Python environment.
  paths = [
    pkgs.atom
    pkgs.pipenv
    pkgs.spyder
    (pkgs.python36.withPackages (ps: with ps; [
      async-timeout
    # asyncio
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
      pydot
      pydotplus
      pyomo
      pytorch
      rasterio
      scikitlearn
      scipy
      scrapy
      seaborn
    # snakes
#     spacy
    # spark-deep-learning
      statsmodels
      tensorflow
    # tensorflow_hub
    # tensorflowjs
      Theano
      websockets
      xgboost
    ]))
  ];
}
