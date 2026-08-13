{
	description = "NixOS configuration with Noctalia";
	outputs = args @ { self, ... }: let
		# tack inputs
		inputs = import ./.tack {
			overrides = args.tackOverrides or {};
		};
		# 2. Instantiate recursiveImport using nixpkgs lib
		recursiveImport = import ./lib/recursive_import.nix {
			inherit (inputs.nixpkgs) lib;
		};
	in inputs.flake-parts.lib.mkFlake ( args // { inherit inputs; } ) {
		systems = [ "x86_64-linux" ];
		
		imports = [
			./host/nixos
		] ++ recursiveImport [
			./flake-modules
		];
		
		flake = {
			
		};
		
		perSystem = {
			
		};
	};
}
