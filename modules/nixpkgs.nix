{ ... }: {
	flake.nixosModules.nixsettings = { ... }: {
		nixpkgs.config.permittedInsecurePackages = [
			"electron-40.10.5"
		];
	};
}
