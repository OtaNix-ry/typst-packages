{
  sources ? import ./npins,
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
{
  default = typix.lib.mkTypstDerivation {
    name = "typst-packages";
    dontUnpack = true;

    # TODO merge all packages' typst derivations
    buildPhaseTypstCommand = ''
      mkdir -p $out/otanix/board-meeting/0.1.0
      cp -r ${(import ./board-meeting/0.1.0 inputs).default}/. $out/otanix/board-meeting/0.1.0
    '';
  };

  shell = pkgs.mkShellNoCC {
    packages = with pkgs; [
      npins
      typst
    ];
  };
}
