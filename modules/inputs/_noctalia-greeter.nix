{inputs, pkgs, ...}: {
	imports = [
		inputs.noctalia-greeter.nixosModules.default
	];
}
