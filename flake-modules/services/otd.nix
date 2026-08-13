{ ... }: {
	flake.nixosModules.services-otd = { ... }: {
		hardware.opentabletdriver = {
			enable = true;
			daemon.enable = true;
		};
	};
}
