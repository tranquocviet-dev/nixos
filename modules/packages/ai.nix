{ pkgs, ... }:
{
	services.sillytavern = {
		enable = true;
		port = 8000;
	};
	services.ollama = {
		enable = true;
		package = pkgs.ollama-cuda;
	};
	environment.systemPackages = [
		pkgs.koboldcpp
	];
}
