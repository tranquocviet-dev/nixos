{ pkgs }:
{
	environment.systemPackages = with pkgs; [
		file-roller
		p7zip-rar
		nemo
		nemo-fileroller
		nemo-with-extensions
		webp-pixbuf-loader
	];
}
