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
			libX11
			libXrandr
			libXext
			libGL
			libGLU
			freeglut
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
		services.xserver.displayManager.lightdm.enable = false;
		services.xserver.displayManager.setupCommands = "${pkgs.xrandr}/bin/xrandr --output DP-2 --mode 1920x1080 --rate 144 --dpi 96 ";
		# Enable Ly display manager
		services.displayManager.ly = {
			enable = true;
			settings = {
				# Optional Ly configuration tweaks
				animation = "none"; # Options: "matrix", "colormix", "doom", "none"
				hide_borders = true;
				save = true; # Save last logged-in user and session
			};
		};
	};
}
