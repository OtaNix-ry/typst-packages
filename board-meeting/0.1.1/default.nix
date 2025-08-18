{
  sources ? import ../../npins,
  system ? builtins.currentSystem,
  pkgs ? import sources.nixpkgs {
    inherit system;
    config = { };
    overlays = [ ];
  },
  typix ? import sources.typix {
    inherit system;
  },
}@inputs:
let
  FONTCONFIG_FILE = pkgs.makeFontsConf { fontDirectories = with pkgs; [ fira ]; };

  src = pkgs.nix-gitignore.gitignoreSourcePure [
    ../../.gitignore
    ".envrc"
    "*.nix"
  ] ./.;

  commonArgs = {
    typstSource = "example.typ";

    # TODO expose these font paths to those who use the library
    fontPaths = [
      "${pkgs.atkinson-hyperlegible}/share/fonts/opentype"
    ];
  };
in
rec {
  default = typix.lib.mkTypstDerivation {
    inherit src;
    buildPhaseTypstCommand = ''
      cp -r $src $out
    '';
  };

  build-script = typix.lib.buildTypstProjectLocal (commonArgs // { inherit src; });

  watch-script = typix.lib.watchTypstProject commonArgs;

  shell = (import ../../default.nix inputs).shell.overrideAttrs (prev: {
    env = {
      inherit FONTCONFIG_FILE;
    };
    packages = prev.packages ++ [
      build-script
      watch-script
    ];
  });
}
