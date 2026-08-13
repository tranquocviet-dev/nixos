{
	description = "NixOS configuration with Noctalia";
	outputs = args @ { self, ... }: let
		# tack inputs
		inputs = import ./.tack {
			overrides = args.tackOverrides or {};
		};
	in inputs.flake-parts.lib.mkFlake ( args // { inherit inputs; } ) {
		systems = [ "x86_64-linux" ];
		
		imports = [
			./host/nixos
		];
		
		flake = {
			
		};
		
		perSystem = {
			
		};
	};
}
