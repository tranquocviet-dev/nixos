{ inputs, self, ... }: let
	system = "x86_64-linux";
	user = "dice";
in {
	flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
		specialArgs = {
			inherit inputs self system user;
		};
		modules = [
			# 1. Host-specific hardware / config
			./boot.nix
			./configuration.nix
			./hardware-configuration.nix
			
			# 2. External modules from flake inputs
			inputs.home-manager.nixosModules.home-manager
			inputs.nvf.nixosModules.default
				
			# Host settings
			({ ... }: {
				nixpkgs.hostPlatform = "x86_64-linux";
				networking.hostName = "nixos";
					
				home-manager = {
					useUserPackages = true;
					useGlobalPkgs = true;
					extraSpecialArgs = {
						inherit inputs system user;
					};
					sharedModules = [ inputs.nvf.homeManagerModules.default ];
					users.${user} = import ../../home_manager/${user}.nix;
				};
			})
		] ++ (with self.nixosModules; [
			# groups
			group-base
			group-inputs
			group-packages
			group-services
			# individual, hardware or use case specific
			nvidia
			services-ai
		]);
	};
}
