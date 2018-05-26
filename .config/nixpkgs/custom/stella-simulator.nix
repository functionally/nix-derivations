{ stdenv, fetchgit }:

let

  aname = "stella-simulator";
  name = "${aname}-${version}";
  version = "1.3.1";
  target = "$out/share/${aname}";

in

  stdenv.mkDerivation rec {
    inherit name;
    src = fetchgit {
      url    = "git://127.0.0.1/";
      rev    = "2efebdefb51e10aca2b14736ad1c3c1d817bec54";
      sha256 = "0bg4xr4cr6z3cqdicqqqlmw1cdp2i53qvhv86p1szdxhh4hj7i4r";
    };
    buildPhase = ''
      :
    '';
    installPhase = ''
      mkdir -p ${target} $out/bin
      cp -r . ${target}
      ln -s ${target}/stella_simulator $out/bin/
    '';
    meta = {
      homepage = "https://www.iseesystems.com/store/products/stella-simulator.aspx";
      description = "Command-line version of STELLA system dynamics simulator.";
      longDescription = ''
        Stella Simulator is a stand-alone, XMILE-compatible simulation engine based on isee systems’ well-known STEAM engine that can be used for server or High Performance Computing (HPC) applications, or embedded in desktop applications. Available for Windows, Macintosh, and Linux, it allows full control over parameters at each step of the model run.
      '';
      platforms = stdenv.lib.platforms.linux;
    };
  }
