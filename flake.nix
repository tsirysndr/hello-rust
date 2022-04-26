{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.capacitor.url = "github:flox/capacitor/ysndr";

  outputs = { self, nixpkgs, capacitor }:
    let
      flake-utils = capacitor.inputs.nix-eval-jobs.inputs.flake-utils;
      flake = flake-utils.lib.eachDefaultSystem (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in
        with pkgs;
        rec {
          packages = flake-utils.lib.flattenTree {
            hello = rustPlatform.buildRustPackage rec {
              name = "flake-info";
              src = ./.;
              cargoLock.lockFile = ./Cargo.lock;
              nativeBuildInputs = [ pkg-config ];
              buildInputs = [ openssl openssl.dev ]
                ++ lib.optional pkgs.stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];
            };
          };
          defaultPackage = packages.hello;
        }
      );
  in capacitor.lib.capacitate flake;
}
