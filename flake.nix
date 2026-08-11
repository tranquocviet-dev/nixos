{
	description = "NixOS configuration with Noctalia";

	outputs = { self, ... }@args:
	let
		inputs = (import ./.tack) { overrides = args.tackOverrides or { }; };

		inherit (inputs) nixpkgs home-manager nvf;
	in {
		nixosConfigurations = let
			mkSystem = hostname:
				{
					system ? "x86_64-linux",
					user ? "dice",
				}:
				nixpkgs.lib.nixosSystem {
					system = system;
					modules = let
						recursive_import = import ./lib/recursive_import.nix { lib = inputs.nixpkgs.lib; };
					in [
						{ networking.hostName = hostname; }
						nvf.nixosModules.default
						home-manager.nixosModules.home-manager
						{
							home-manager = {
								useUserPackages = true;
								useGlobalPkgs = true;
								extraSpecialArgs = { inherit inputs user hostname; };
								users.${user} = (./. + "/home_manager/${user}.nix");
							};
						}
					] ++ recursive_import [
						./host/${hostname}
						./modules
					];
					specialArgs = {
						inherit inputs system user;
					};
				};
		in {
			nixos = mkSystem "nixos" { };
		};
	};
}
