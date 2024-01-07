{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    demo-flake.url = "github:NixOS/patchelf";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} {
    systems = ["x86_64-linux"];
    perSystem = {pkgs, lib, config, system, ...}: {
      # Putting it in `packages` will make it fail CLI commands like `nix flake show`
      # because this is not derivation but a function that returns a derivation.
      legacyPackages.flake-closure = pkgs.callPackage ./flake-closure.nix {};
      packages.demo-closure = config.legacyPackages.flake-closure {
	flake = inputs.demo-flake;
      };
      apps.default.program = pkgs.writeShellApplication {
	name = "show-flake-closure";
	runtimeInputs = [];
	text = ''
          cat ${config.packages.demo-closure}
        '';
      };
    };
  };
}
