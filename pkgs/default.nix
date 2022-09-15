{rustPlatform}:
rustPlatform.buildRustPackage rec {
  name = "hello-rust";
  src = ../.;
  cargoLock.lockFile = ../Cargo.lock;
}
