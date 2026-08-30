{ ... }: {
	flake.nixosModules.portal = { pkgs, ... }: {
		xdg.portal = {
			enable = true;
			xdgOpenUsePortal = true;
			extraPortals = [
				pkgs.xdg-desktop-portal-gtk
				pkgs.xdg-desktop-portal-gnome
				pkgs.xdg-desktop-portal-umbriel
			];
			config = {
				common = {
					default = "gtk";
				};
				bspwm = {
					default = "gtk";
				};
			};
		};
		
		# Force dconf preference
		programs.dconf.enable = true;
	};
}
