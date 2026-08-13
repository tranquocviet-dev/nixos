{ ... }: {
	flake.nixosModules.otd = { ... }: {
		hardware.opentabletdriver = {
			enable = true;
			daemon.enable = true;
		};
	};
}
