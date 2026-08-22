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
			glib
			gsettings-desktop-schemas
			yad
			xdotool
			xxd
			xwininfo
			jq
			dunst
			xclip
			libnotify
			maim
			slop
		];
		services.tailscale.enable = true;
		services.emacs = {
			enable = true;
			package = (
				pkgs.emacs.override {
					withGTK3 = false;
					withNativeCompilation = true;
				}
			);
		};
		services.displayManager.noctalia-greeter.enable = false;
		services.xserver.displayManager.lightdm.enable = true;
		services.xserver.displayManager.setupCommands = "${pkgs.xrandr}/bin/xrandr --output DP-2 --mode 1920x1080 --rate 144 --dpi 96 ";
	};
}
