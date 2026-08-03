{
	description = "NixOS configuration with Noctalia";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		import-tree.url = "github:denful/import-tree";

		noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		noctalia.url = "github:noctalia-dev/noctalia/cachix";

		nix-gaming.url = "github:fufexan/nix-gaming";

		osu-stable.url = "path:./pkgs/osu-stable";
		osu-lazer-bin.url = "path:./pkgs/osu-lazer-bin";

		nvf.url = "github:notashelf/nvf";
	};

	outputs = { self, nixpkgs, home-manager, nvf, ... }@inputs: {
		nixosConfigurations = let
			mkSystem = hostname:
			{
				system ? "x86_64-linux",
				user ? "dice",
			}:
				nixpkgs.lib.nixosSystem {
					system = system;
					modules = let
						recursive_import = import ./lib/recursively_import.nix { lib = inputs.nixpkgs.lib; }; 
					in [
						{ networking.hostName = hostname; }
						recursive_import ./host/${hostname}
						recursive_import ./modules
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
