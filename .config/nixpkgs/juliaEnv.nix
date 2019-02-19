{
  pkgs
}:

pkgs.buildEnv {
  name = "env-julia";
  # Basic Julia environment.
  paths = with pkgs; [
    julia_10
  ];
}
