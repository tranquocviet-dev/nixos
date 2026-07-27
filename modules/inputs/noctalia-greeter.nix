{inputs, pkgs, ...}: {
	imports = [
		inputs.noctalia-greeter.nixosModules.default
	];

	services.greetd = {
		enable = true;
		settings.default_session = {
			command = "/run/current-system/sw/bin/noctalia-greeter-session -- --session sway --unsupported-gpu";
			user = "dice";
		};
	};

	programs.noctalia-greeter = {
		enable = true;
		package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
	};
}
