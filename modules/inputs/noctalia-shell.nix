{ ... }: {
	flake.nixosModules.inputs-noctalia = { ... }: {
		# settings for noctalia
		networking.networkmanager.enable = true;
		hardware.bluetooth.enable = true;
		services.power-profiles-daemon.enable = true;
		services.upower.enable = true;
		programs.noctalia.enable = true;
	};
}
