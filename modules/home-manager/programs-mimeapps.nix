{ ... }:
{
	flake.homeManagerModules.programs-mimeapps = { pkgs, ... }:
		let
			imageViewer = "imv.desktop";
			videoViewer = "mpv.desktop";
			fileViewer = "thunar.desktop";
			browser = "firefox.desktop";
			editor = "emacsclient.desktop";
		in {
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
		};
}
