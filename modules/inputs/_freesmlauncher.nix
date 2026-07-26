{ pkgs, inputs, system, ... }:
{
	environment.systemPackages = [
		inputs.freesmlauncher.packages.${system}.freesmlauncher
	];
}
