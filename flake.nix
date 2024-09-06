{
  description = "OtaNix ry typst-packages";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.systems.url = "github:nix-systems/default";
  outputs =
    { nixpkgs, systems, ... }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      overlays.default = _final: _prev: { };

      packages = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = (import ./. { inherit system pkgs; }).default;
        }
      );

      templates = rec {
        default = quick-start;
        quick-start = {
          description = "OtaNix typst example";
          path = ./examples/quick-start;
        };
      };
    };
}
