{ stdenv, fetchurl, python2, glibc, tk, tcl, tcllib, which, makeDesktopItem }:

let

  aname = "globusconnectpersonal";
  name = "${aname}-${version}";
  version = "2.3.3";
  target = "$out/share/${aname}";

in

  stdenv.mkDerivation rec {

    inherit name;

    src = fetchurl {
      name = "globus-${version}_linux-x86_64.tar.bz2";
      url = "https://s3.amazonaws.com/connect.globusonline.org/linux/stable/${name}.tgz";
      sha256 = "2b8ea6880b3044f73cd5bc0b0368eb5bd5834b12d0c0dc645fb2f26f5db2ac60";
    };

    libPath = stdenv.lib.makeLibraryPath [
      stdenv.cc.cc
    ];

    installPhase = ''
      mkdir -p $out/share/applications $out/bin ${target}
      cp -r . ${target}
      rm -r ${target}/gt_i386
      find $out -name \*.py  -exec sed -i -e "1s@/usr@${python2}@" {} \;
      find $out \( -name \*.tcl -or -name globusconnectpersonal \) \
           -exec sed -i -e "1s@/usr/bin/wish@${tk}/bin/wish@"      \
                        -e "s@exec wish@exec ${tk}/bin/wish@"      \
                        -e "s@exec tclsh@${tcl}/bin/tclsh@"        \
                 {} \;
      sed -i -e "s@export TCLLIBPATH=@&${tcllib}/lib/ @"          \
             -e '/export TCLLIBPATH=/s/=/="/'                     \
             -e '/export TCLLIBPATH=/s/$/"/'                      \
             -e "s@which wish@${which}/bin/which ${tk}/bin/wish@" \
             -e "s@getconf@${glibc.bin}/bin/&@"                   \
             ${target}/globusconnectpersonal
      patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 \
               --set-rpath ${target}/gt_amd64/lib:$libPath                ${target}/gt_amd64/bin/relaytool
      patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 \
               --set-rpath ${target}/gt_amd64/lib:$libPath                ${target}/gt_amd64/bin/pdeath
      patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 \
               --set-rpath ${target}/gt_amd64/lib:$libPath                ${target}/gt_amd64/bin/ssh
      patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 \
               --set-rpath ${target}/gt_amd64/lib:$libPath                ${target}/gt_amd64/sbin/globus-gridftp-server
      ln -s ${target}/globusconnectpersonal $out/bin/globusconnectpersonal
      ln -s ${desktopItem}/share/applications/${aname}.desktop $out/share/applications/${aname}.desktop
    '';

    desktopItem = makeDesktopItem {
      name = aname;
      exec = "globusconnectpersonal";
      desktopName = "Global Personal Connect";
      genericName = meta.description;
      categories = "Internet;";
      type = "Application";
      terminal = "false";
    };

    meta = {
      homepage = https://www.globus.org/globus-connect-personal/;
      description = "Globus Connect Personal turns your laptop or other personal computer into a Globus endpoint with a just a few clicks.";
      longDescription = ''
        Globus Connect Personal turns your laptop or other personal computer into a Globus endpoint with a just a few clicks. With Globus Connect Personal you can share and transfer files to/from a local machine—campus server, desktop computer or laptop—even if it's behind a firewall and you don't have administrator privileges.
      '';
      platforms = stdenv.lib.platforms.linux;
      license = {
        name = "Globus Software License";
        url = https://www.globus.org/legal/software-license;
      };
    };

  }
