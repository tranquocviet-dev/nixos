{ inputs, self, ... }: let
	system = "x86_64-linux";
	user = "dice";
in {
	flake.nixosConfigurations.server = inputs.nixpkgs.lib.nixosSystem {
		specialArgs = {
			inherit inputs self system user;
		};
		modules = [
			# 1. Host-specific hardware / config
			./configuration.nix
			./hardware-configuration.nix
			# Host settings
			({ ... }: {
				nixpkgs.hostPlatform = "x86_64-linux";
				networking.hostName = "nixos";
			})
		];
	};
}
