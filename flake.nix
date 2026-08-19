{
	description = "NixOS configuration with Noctalia";
	outputs = args @ { self, ... }: let
		# tack inputs
		inputs = import ./.tack {
			overrides = args.tackOverrides or { };
		};
		# npins inputs
		#sources = import ./npins;
		#inputs = sources // {
		#	osu-stable = ./pkgs/osu-stable;
		#	osu-lazer-bin = ./pkgs/osu-lazer-bin;
		#};
		# 2. Instantiate recursiveImport using nixpkgs lib
		recursiveImport = import ./lib/recursive_import.nix {
			inherit (inputs.nixpkgs) lib;
		};
	in inputs.flake-parts.lib.mkFlake ( args // { inherit inputs; } ) {
		systems = [ "x86_64-linux" ];
		imports = [
			# even though theres only 1 entry i leave this on a new line for easier time adding more hosts later
			./host/nixos
		] ++ recursiveImport [ ./modules ];
		flake = { };
		perSystem = { };
	};
}
