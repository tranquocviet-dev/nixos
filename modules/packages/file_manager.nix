{ pkgs, ... }:
{
	programs.dconf.enable = true;
	services.gvfs.enable = true;
	services.udisks2.enable = true;
	environment.systemPackages = with pkgs; [
		nautilus
		file-roller
		gdk-pixbuf
		viewnior
		kdePackages.gwenview
		kdePackages.kimageformats
	];
}
