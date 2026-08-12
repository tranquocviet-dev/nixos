{
	description = "NixOS configuration with Noctalia";
	outputs = args @ { self, ... }: let
		inputs = import ./.tack {
			overrides = args.tackOverrides or {};
		};
		inherit (inputs.nixpkgs) lib;
		recursiveImport = import ./lib/recursive_import.nix { inherit lib; };
		specialArgs = {
			inherit inputs self recursiveImport;
		};
		commonModules = [
			{
				home-manager.extraSpecialArgs = {inherit recursiveImport;};
				home-manager.sharedModules = [inputs.nvf.homeManagerModules.default];
			}
		];
		mkSystem = hostname: system: user:
			lib.nixosSystem {
				specialArgs = specialArgs // {
					inherit hostname system user;
				};
				modules =
					commonModules
					++ [
						{nixpkgs.hostPlatform = system;}
						inputs.home-manager.nixosModules.home-manager
						inputs.nvf.nixosModules.default
						{
							home-manager = {
								useUserPackages = true;
								useGlobalPkgs = true;
								extraSpecialArgs = { inherit inputs hostname user; };
								users.dice = (./. + "/home_manager/dice.nix");
							};
							
						}
					] ++ recursiveImport [
						./host/${hostname}
						./modules
					];
			};
	in {
		nixosConfigurations = {
			nixos = mkSystem "nixos" "x86_64-linux" "dice";
		};
	};
}
