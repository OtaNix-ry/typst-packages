{
  description = "OtaNix typst example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";

    typix = {
      url = "github:xhalo32/typix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    typst-packages = {
      url = "github:typst/packages";
      flake = false;
    };
    otanix-typst-packages = {
      url = "github:OtaNix-ry/typst-packages";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      systems,
      typix,
      ...
    }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);

      variablesFor = system: rec {
        pkgs = nixpkgs.legacyPackages.${system};

        typixLib = typix.lib.${system};

        src = pkgs.nix-gitignore.gitignoreSourcePure [
          # ./.gitignore # Uncomment to ignore gitignored files
          ".envrc"
          "*.nix"
        ] ./.;

        commonArgs = typstSource: {
          inherit typstSource;

          fontPaths = [
            # Add paths to fonts here
            "${pkgs.atkinson-hyperlegible}/share/fonts/opentype"
          ];

          XDG_CACHE_HOME = typstPackagesCache;
        };

        typstPackagesSrc = pkgs.symlinkJoin {
          name = "typst-packages-src";
          paths = [
            "${inputs.typst-packages}/packages"
            inputs.otanix-typst-packages.packages.${system}.default
          ];
        };

        typstPackagesCache = pkgs.stdenv.mkDerivation {
          name = "typst-packages-cache";
          src = typstPackagesSrc;
          dontBuild = true;
          installPhase = ''
            mkdir -p "$out/typst/packages"
            cp -LR --reflink=auto --no-preserve=mode -t "$out/typst/packages" "$src"/*
          '';
        };

        build-drv = typixLib.buildTypstProject (commonArgs "example.typ" // { inherit src; });
        build-script = typixLib.buildTypstProjectLocal (commonArgs "example.typ" // { inherit src; });
        watch-script = typixLib.watchTypstProject (commonArgs "example.typ");
      };
    in
    {
      packages = eachSystem (
        system: with variablesFor system; {
          inherit
            build-drv
            build-script
            watch-script
            ;
        }
      );
    };
}
