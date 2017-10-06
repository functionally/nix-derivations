{ stdenv, fetchgit, boost, qt5, gcc, cmake, git }:
stdenv.mkDerivation rec {
  name = "rivet";
  buildInputs = [
    boost
    qt5.full
    qt5.qtbase
    gcc
    cmake
    git
  ];
  libPath = stdenv.lib.makeLibraryPath [
    qt5.full
    qt5.qtbase
    boost
    gcc.cc
  ];
  src = fetchgit {
    url = "https://github.com/rivetTDA/rivet.git";
    rev = "c08c09355bd27d70cada5a5b2410628f6c7408a3";
    sha256 = "07s808ckbnb9zq3vl37icbxjzmk24g0dx03bj1snlbis0hlyfaqz";
    fetchSubmodules = true;
  };
  docopt_src = fetchgit {
    url = "https://github.com/docopt/docopt.cpp";
    rev = "a4177ccf1a6e36ebe268972732ddd456a3574f6d";
    sha256 = "1ylb6kq2zwkyw8qcjrvw53hnsn52dqmdkzjr743g2ygmy4bsv6r1";
    fetchSubmodules = true;
  };
  preConfigure = ''
    qmakeFlags="$qmakeFlags LIBDIR=$out/lib CMAKE_CONFIG_PATH=$out/lib/cmake"
    sed -i -e 's@https://github.com/docopt/docopt.cpp@${docopt_src}@' CMakeLists.txt
  '';
  installPhase = ''
    cd ..
    qmake
    make
    mkdir -p $out/bin $out/lib $out/share/rivet/data
    cp    RIVET build/rivet_console                        $out/bin/
    cp    build/docopt/src/docopt_project-build/libdocopt* $out/lib/
    cp -r data/*                                           $out/share/rivet/
    patchelf --set-rpath $out/lib:${libPath} $out/bin/RIVET
  '';
}
