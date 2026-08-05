{ pkgs, ... }:
{
	xdg.portal = {
		enable = true;
		xdgOpenUsePortal = true;
		wlr.enable = true;
		extraPortals = [ 
			pkgs.xdg-desktop-portal-gtk
			pkgs.xdg-desktop-portal-wlr
		];
		config = {
			common = {
				default = "*";
			};
		};
	};
	
	# Force dconf preference
	programs.dconf.enable = true;
}
