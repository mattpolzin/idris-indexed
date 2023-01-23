{
  description = "A little foundation around indexed interfaces for functor, applicative, and monad.";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    idris2 = {
      url = "github:idris-lang/Idris2/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, idris2 }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
          stdenv = pkgs.stdenv;
          idris2' = idris2.defaultPackage.${system};
      in {
        packages.default = stdenv.mkDerivation rec {
          name = "idris-indexed";
          version = "0.0.9";
          src = ./.;
          idrisPackages = [];
          buildInputs = [ idris2' ] ++ idrisPackages;

          IDRIS2 = "${idris2'}/bin/idris2";
          IDRIS2_PREFIX = "${placeholder "out"}";
          IDRIS2_PACKAGE_PATH = builtins.concatStringsSep ":" (builtins.map (p: "${p}/idris2-${idris2'.version}") idrisPackages);

          buildPhase = ''
            make clean
            make build
          '';
          installPhase = ''
            make install
          '';
        };
      }
    );
}
