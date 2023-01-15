{
  description = "A little foundation around indexed interfaces for functor, applicative, and monad.";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    idris2 = {
      url = "github:idris-lang/Idris2/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, idris2 }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
          stdenv = pkgs.stdenv;
      in {
        packages.default = stdenv.mkDerivation {
          name = "idris-indexed";
          version = "0.0.9";
          src = ./.;
          buildInputs = [ idris2.defaultPackage.${system} ];
          buildPhase = ''
            make clean
            make build
          '';
          installPhase = ''
            export IDRIS2_PREFIX="$out"
            make install
          '';
        };
      }
    );
}
