{ ... }: {
	flake.nixosModules.networking = { ... }: {
		services.byedpi = {
			enable = true;
			extraArgs = [
				"--disorder" "1"
				"--fake" "1"
			];
		};
	};
}
