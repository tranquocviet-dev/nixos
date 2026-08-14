{ ... }: {
	flake.nixosModules.inputs-noctalia-greeter = { inputs, ... }: {
		imports = [
			inputs.noctalia-greeter.nixosModules.default
		];
	};
}
