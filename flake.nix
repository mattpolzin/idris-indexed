{
  description = "A little foundation around indexed interfaces for functor, applicative, and monad.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    idris2 = {
      url = "github:idris-lang/Idris2/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, idris2, ... }:
    let
      inherit (nixpkgs) lib;
      eachDefaultSystem = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      packages = eachDefaultSystem (
        system:
        let
          buildIdris = idris2.buildIdris.${system};
          indexedPkg = buildIdris {
            ipkgName = "indexed";
            version = "0.0.9";
            src = ./.;
            idrisLibraries = [ ];
          };
        in
        rec {
          indexed = indexedPkg.library { };
          indexedWithSource = indexedPkg.library { withSource = true; };
          default = indexed;
        }
      );
      formatter = eachDefaultSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
