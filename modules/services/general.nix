{ ... }: {
	flake.nixosModules.services-general = { pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			dash
			tk
			vips
			xwayland-satellite
			adw-gtk3
			git
			killall
			librsvg
			gdk-pixbuf
			xdg-desktop-portal-wlr
			glib
			gsettings-desktop-schemas
			yad
			xdotool
			xxd
			xwininfo
			jq
		];
		services.tailscale.enable = true;
		programs.xwayland.enable = true;
		programs.npm.enable = true;
		services.displayManager.noctalia-greeter.enable = true;
	};
}
