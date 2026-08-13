{ pkgs, ... }:
{
	programs.dconf.enable = true;
	services.gvfs.enable = true;
	services.udisks2.enable = true;
	environment.systemPackages = with pkgs; [
		nautilus
		nautilus-open-any-terminal
		nautilus-python

		file-roller
		p7zip
		unrar
		unzip
		zip

		imagemagick
	];
}
