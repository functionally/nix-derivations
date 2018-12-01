{
  pkgs
, unstable
}:

pkgs.buildEnv {
  name = "env-julia";
  # Basic Julia environment.
  paths = with unstable; [
    julia_10
  ];
}
