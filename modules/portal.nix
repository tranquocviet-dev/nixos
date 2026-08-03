{ pkgs, ... }:
{
	xdg.portal = {
		enable = true;
		extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
		config = {
			common = {
				default = [ "gtk" ];
			};
		};
	};
	
	# Force dconf preference
	programs.dconf.enable = true;
}
