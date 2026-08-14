{ ... }: {
	flake.nixosModules.portal = { pkgs, ... }: {
		xdg.portal = {
			enable = true;
			xdgOpenUsePortal = true;
			wlr.enable = true;
			extraPortals = [ 
				pkgs.xdg-desktop-portal-gtk
				pkgs.xdg-desktop-portal-wlr
				pkgs.xdg-desktop-portal-gnome
			];
			config = {
				common = {
					default = "*";
				};
				niri = {
					default = "gnome;gtk";
				};
			};
		};
		
		# Force dconf preference
		programs.dconf.enable = true;
	};
}
