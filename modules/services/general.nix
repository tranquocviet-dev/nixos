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
		services.emacs = {
			enable = true;
			package = (pkgs.emacs.override { withGTK3 = false; });
		};
		programs.xwayland.enable = true;
		programs.npm.enable = true;
		services.displayManager.noctalia-greeter.enable = false;
		services.xserver.displayManager.lightdm.enable = true;
		services.xserver.displayManager.setupCommands = ''
				${pkgs.xrandr}/bin/xrandr --output DP-2 --mode 1920x1080 --rate 144 --dpi 96
		'';
	};
}
