{ ... }:
{
	flake.homeManagerModules.programs-mimeapps =
		{ pkgs, ... }:
		let
			imageViewer = "imv.desktop";
			videoViewer = "mpv.desktop";
			fileViewer = "thunar.desktop";
			browser = "firefox.desktop";
			editor = "emacsclient.desktop";
		in
		{
			xdg.mimeApps = {
				enable = true;
				defaultApplications = {
					"image/gif" = imageViewer;
					"image/png" = imageViewer;
					"image/jpg" = imageViewer;
					"image/jpeg" = imageViewer;
					"video/mp4" = videoViewer;
					"video/webm" = videoViewer;
					"inode/directory" = fileViewer;
					"application/x-gnome-saved-search" = fileViewer;
					"application/pdf" = browser;
					"text/plain" = editor;
					"text/x-python" = editor;
					"text/x-shellscript" = editor;
					"text/markdown" = editor;
					"application/x-zerosize" = editor;
				};
			};
			services.dunst = {
				enable = true;
				settings = {
					global = {
						# Font & Text size (Format: "<family> <size>")
						font = "sans-serif 12";

						# Popup Dimensions (Width min, max; Height max)
						width = "(300, 450)";
						height = "200";
						offset = "0x0"; # Offset from screen edge (X x Y)
						origin = "top-right"; # Options: top-left, top-right, bottom-left, bottom-right, top-center, etc.

						# Styling & Borders
						frame_width = 2;
						frame_color = "#000000";
						corner_radius = 0; # Set > 0 for rounded corners (requires a compositor like picom)
						padding = 12; # Vertical padding inside notification
						horizontal_padding = 14; # Horizontal padding inside notification
						gap_size = 6; # Space between multiple stacked notifications

						# Progress Bar (for volume/brightness indicators)
						progress_bar = true;
						progress_bar_height = 6;
						progress_bar_frame_width = 1;
						mouse_left_click = "do_action, close_current";
						mouse_middle_click = "context";
						mouse_right_click = "close_current";
					};

					urgency_low = {
						background = "#c0c0c0";
						foreground = "#000000";
						timeout = 4;
					};

					urgency_normal = {
						background = "#c0c0c0";
						foreground = "#000000";
						timeout = 6;
					};

					urgency_critical = {
						background = "#c0c0c0";
						foreground = "#000000";
						frame_color = "#bf616a";
						timeout = 0; # 0 = sticky until dismissed
					};
				};
			};
			services.picom = {
				enable = true;
				backend = "glx"; # Or "egl" / "xrender"
				vSync = true;
				activeOpacity = 1.0;
				inactiveOpacity = 1.0;
				opacityRules = [
				];
			};
		};
}
