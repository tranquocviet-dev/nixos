{ pkgs, system, freesmlauncher, ... }:
{
	environment.systemPackages = [
		freesmlauncher.packages.${system}.freesmlauncher
	];
}
