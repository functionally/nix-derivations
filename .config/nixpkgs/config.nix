{

  allowUnfree = true;

# chromium = {
#   enablePepperFlash = true;
#   enablePepperPDF = true;
# };

  packageOverrides = super:
    let
      self = super.pkgs;
      unstable = import <nixos-unstable>{};
    in
      with self; rec {
 
        lemur = with pkgs; buildEnv {
          name = "lemur";
          paths =
            [
              # Command-line
              ffmpeg
              imagemagick
              librdf_raptor2
              librdf_rasqal
              # Graphical
              blender
              gephi
              ggobi
              graphviz
              guvcview
              inkscape
              libreoffice
              meshlab
              pandoc
              paraview
              qgis
              rstudio
              scid
#             (import <nixos-unstable> {}).google-chrome
              unstable.google-chrome
              # Communication
#             discord
              gajim
              skype
              slack
              tigervnc
              # Xfce
              xfce.mousepad
              xfce.parole
              # Programming
              jre
              python3
              R
              # Services
              awscli
              google-cloud-sdk
            ];
        };

    };

}
