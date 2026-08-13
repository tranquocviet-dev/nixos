{
	description = "NixOS configuration with Noctalia";
	outputs = args @ { self, ... }: let
		# tack inputs
		inputs = import ./.tack {
			overrides = args.tackOverrides or {};
		};
		inherit (inputs.nixpkgs) lib; # to use for recursiveImport below
		recursiveImport = import ./lib/recursive_import.nix { inherit lib; };
		specialArgs = {
			# passing inputs and self for general use
			# passing down recursiveImport in case a file wants that
			inherit inputs self recursiveImport;
		};
		commonModules = [
			# eljanfus' approach to passing down common modules
			# not used much by me but looks useful so ill leave them there
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
								users.${user} = (./. + "/home_manager/${user}.nix");
							};
							
						}
					] ++ recursiveImport [
						./host/${hostname}
						./modules
					];
			};
	in inputs.flake-parts.lib.mkFlake { inherit inputs; } {
		systems = [ "x86_64-linux" ];
		
		flake = {
			nixosConfigurations = {
				nixos = mkSystem "nixos" "x86_64-linux" "dice";
			};
		};
		
		perSystem = {
			
		};
	};
}
