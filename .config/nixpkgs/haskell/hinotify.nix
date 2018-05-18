{ mkDerivation, async, base, containers, directory, stdenv, unix }:
mkDerivation {
  pname = "hinotify";
  version = "0.3.9";
  sha256 = "16fzql0s34my9k1ib4rdjf9fhhijkmmbrvi148f865m51160wj7j";
  revision = "1";
  editedCabalFile = "0df5pak0586626k3ryzg2lb26ys562l3i94jr9vpa0krs8iia209";
  libraryHaskellDepends = [ async base containers directory unix ];
  testHaskellDepends = [ base directory ];
  homepage = "https://github.com/kolmodin/hinotify.git";
  description = "Haskell binding to inotify";
  license = stdenv.lib.licenses.bsd3;
  doCheck = false;
}
