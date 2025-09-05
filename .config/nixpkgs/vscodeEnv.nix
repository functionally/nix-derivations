{
  pkgs ? import <nixpkgs> {}
, lib ? pkgs.lib
}:

let

  vscodePkgs = with pkgs; vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions; [
      bbenoist.nix
      ms-python.python
      ms-vscode-remote.remote-ssh
      haskell.haskell
      justusadam.language-haskell
      rust-lang.rust-analyzer
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "lean4";
        publisher = "leanprover";
        version = "0.0.127";
        sha256 = "1zijpxal6h8c1rc4hpis2ysdp6pjj0a0vcvvffi4vhkkf6gqwa7d";
      }
      {
        name = "agda-mode";
        publisher = "banacorn";
        version = "0.4.7";
        sha256 = "0kb35hs2830nihxwk91kq9fhibmr2gl6mihv0ll7lgx5bsgvgml0";
      }
    ];
  };

  ghc = pkgs.haskellPackages.ghcWithPackages (p: with p; [ ieee754 ]);
  haskellPkgs = with pkgs.haskellPackages; [
    ghc
    cabal-install
    haskell-language-server
  ];

  agda-stdlib = pkgs.agdaPackages.standard-library.overrideAttrs (oldAtts: rec {
    version = "2.0";
    src = pkgs.fetchFromGitHub {
      repo = "agda-stdlib";
      owner = "agda";
      rev = "v${version}";
      sha256 = "sha256-TjGvY3eqpF+DDwatT7A78flyPcTkcLHQ1xcg+MKgCoE=";
    };
    preConfigure = ''
      runhaskell GenerateEverything.hs
      # We will only build/consider Everything.agda, in particular we don't want Everything*.agda
      # do be copied to the store.
      rm EverythingSafe.agda
    '';
  });

  agda2hs-src = pkgs.fetchFromGitHub {
    repo = "agda2hs";
    owner = "agda";
    rev = "b269164e15da03b74cf43b51c522f4f052b4af80";
    sha256 = "sha256-19NGyK7qbsQ+EBX6lygNFOXRyDm/48KlBf8ixBU7PUw=";
  };

  agda2hs-lib = pkgs.agdaPackages.mkDerivation
    { pname = "agda2hs";
      src = agda2hs-src;
      meta = {};
      version = "1.2";
      preBuild = ''
        echo "{-# OPTIONS --sized-types #-}" > Everything.agda
        echo "module Everything where" >> Everything.agda
        find lib -name '*.agda' | sed -e 's/lib\///;s/\//./g;s/\.agda$//;s/^/import /' >> Everything.agda
      '';
    };

  agda2hs-pkg = options:
    pkgs.haskellPackages.haskellSrc2nix {
      name = "agda2hs";
      src = agda2hs-src;
      extraCabal2nixOptions = options;
  };

  agda2hs-hs = pkgs.haskellPackages.callPackage (agda2hs-pkg "--jailbreak") {};

  agda2hs-expr = {stdenv, lib, runCommandNoCC, makeWrapper, writeText, mkShell}:
    with lib.strings;
    let
      pkgs' = [ agda-stdlib ];
      library-file = writeText "libraries" ''
        ${(concatMapStringsSep "\n" (p: "${p}/${p.libraryFile}") pkgs')}
      '';
      pname = "agda2hsWithPackages";
      version = agda2hs-hs.version;
    in
      runCommandNoCC "${pname}-${version}" {
        inherit pname version;
        nativeBuildInputs = [ makeWrapper ];
        passthru.unwrapped = agda2hs-hs;
      } ''
        mkdir -p $out/bin
        makeWrapper ${agda2hs-hs}/bin/agda2hs $out/bin/agda2hs \
          --add-flags "--with-compiler=${ghc}/bin/ghc" \
          --add-flags "--library-file=${library-file}" \
          --add-flags "--local-interfaces"
        '';

  agda2hs = pkgs.callPackage agda2hs-expr { };

  agdaPkgs = [
    (pkgs.agda.withPackages (ps: [
      agda-stdlib
      agda2hs-lib
    ]))
    agda2hs
  ];

  leanPkgs = with pkgs; [
    lean4
  ];

  rustPkgs = with pkgs; [
    rustc
    cargo
  # rust-analyzer
  ];

in 

  pkgs.buildEnv {
    name = "env-vscode";
    paths =
      [ vscodePkgs ]
    # ++ agdaPkgs
    # ++ haskellPkgs
      ++ leanPkgs
      ++ rustPkgs
    ;
  }
