{ inputs, self, lib, ... }: let
	system = "x86_64-linux";
	user = "dice";
	recursiveImport = import ../../lib/recursive_import.nix { inherit lib; };
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
			
			self.nixosModules.nh
			self.nixosModules.nvf
			self.nixosModules.nvidia
			self.nixosModules.fish
			self.nixosModules.fonts
			self.nixosModules.nix-ld
			self.nixosModules.nixsettings
			self.nixosModules.polkit
			self.nixosModules.portal
			self.nixosModules.services-otd
			self.nixosModules.services-sudo
			self.nixosModules.services-general
			self.nixosModules.services-ai
			self.nixosModules.inputs-noctalia
			self.nixosModules.inputs-noctalia-greeter
			self.nixosModules.inputs-osu
			self.nixosModules.packages-general
			self.nixosModules.packages-fcitx
			self.nixosModules.packages-nautilus
			self.nixosModules.packages-misc
				
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
		] ++ recursiveImport [
			../../modules
		];
	};
}
