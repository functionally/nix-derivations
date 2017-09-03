{ stdenv, fetchurl, gtk3, dbus_glib, xorg, makeDesktopItem }:

let

  name = "zotero-${version}";
  version = "5.0.17";

in

  stdenv.mkDerivation rec {

    inherit name;

    src = fetchurl {
      name = "Zotero-${version}_linux-x86_64.tar.bz2";
      url = https://download.zotero.org/client/release/5.0.17/Zotero-5.0.17_linux-x86_64.tar.bz2;
      sha256 = "6e2a3dfd2cf72f0fc2686b1358ce2c87abc48a558ad3fce10752fc36ac7e91cd";
    };

    libPath = stdenv.lib.makeLibraryPath [
      stdenv.cc.cc gtk3 dbus_glib xorg.libXt
    ];

    installPhase = ''
      mkdir -p $out/share/Zotero $out/bin
      cp -r . $out/share/Zotero
      patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 $out/share/Zotero/zotero-bin
      patchelf --set-rpath $(pwd):$libPath                                $out/share/Zotero/zotero-bin
      patchelf --set-rpath $(pwd):$libPath                                $out/share/Zotero/libmozgtk.so
      patchelf --set-rpath $(pwd):$libPath                                $out/share/Zotero/libxul.so
      sed -e "s@^CALLDIR=.*@CALLDIR=$out/share/Zotero@" zotero          > $out/bin/zotero
      chmod +x $out/bin/zotero
      mkdir $out/share/applications
      sed -e "s@#out#@$out@" ${desktopItem}/share/applications/zotero.desktop > $out/share/applications/zotero.desktop
    '';

    desktopItem = makeDesktopItem {
      name = "zotero";
      exec = "zotero -url %U";
      desktopName = "Zotero";
      genericName = meta.description;
      categories = "Office;";
      type = "Application";
      mimeType = "text/plain";
      terminal = "false";
      icon = "#out#/share/Zotero/chrome/icons/default/main-window.ico";
    };

    meta = {
      homepage = https://www.zotero.org/;
      description = "Zotero [zoh-TAIR-oh] is a free, easy-to-use tool to help you collect, organize, cite, and share your research sources.";
      longDescription = ''
        Zotero is the only research tool that automatically senses content in your web browser, allowing you to add it to your personal library with a single click. Whether you're searching for a preprint on arXiv.org, a journal article from JSTOR, a news story from the New York Times, or a book from your university library catalog, Zotero has you covered with support for thousands of sites.
      '';
      platforms = stdenv.lib.platforms.linux;
      license = stdenv.lib.licenses.agpl3;
    };

  }
