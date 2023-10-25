{
  description = "Tket Quantum SDK";
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import ./nix-support/libs.nix)
            (import ./nix-support/symengine.nix)
            (import ./nix-support/tket.nix)
            (import ./nix-support/third-party-python-packages.nix)
            (import ./nix-support/pytket.nix)
            (import ./nix-support/pytket-extensions.nix)
          ];
        };
      in {
        packages = {
          tket = pkgs.tket;
          pytket = pkgs.pytket;
        };
        devShells = {
          default = pkgs.mkShell { buildInputs = [ pkgs.tket pkgs.pytket ]; };
          quantinuum = pkgs.mkShell {
            buildInputs = [
              (pkgs.pytketWithExtensions (p: [p.quantinuum]))
            ];
          };
          aqt = pkgs.mkShell {
            buildInputs = [
              (pkgs.pytketWithExtensions (p: [p.aqt]))
            ];
          };
          braket = pkgs.mkShell {
            buildInputs = [
              (pkgs.pytketWithExtensions (p: [p.braket]))
            ];
          };
          cirq = pkgs.mkShell {
            buildInputs = [
              (pkgs.pytketWithExtensions (p: [p.cirq]))
            ];
          };
          iqm = pkgs.mkShell {
            buildInputs = [
              (pkgs.pytketWithExtensions (p: [p.iqm]))
            ];
          };
          pennylane = pkgs.mkShell {
            buildInputs = [
              (pkgs.pytketWithExtensions (p: [p.pennylane]))
            ];
          };
          qiskit = pkgs.mkShell {
            buildInputs = [
              (pkgs.pytketWithExtensions (p: [p.qiskit]))
            ];
          };

          # For Later. See discussion in ./nix-support/third-party-python-packages.nix
          # cutensornet = pkgs.mkShell {
          #   buildInputs = [
          #     (pkgs.pytketWithExtensions (p: [p.cutensornet]))
          #   ];
          # };
        };
        checks = {
          tket-tests = pkgs.run-tket-tests;
          pytket-tests = pkgs.pytket;
        };
      });
}
