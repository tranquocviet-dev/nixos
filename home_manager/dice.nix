{ system, inputs, pkgs, config, user, ... }: {
	home.username = "${user}";
	home.homeDirectory = "/home/${user}";
	home.stateVersion = "26.05";
	# 1. Importing my nix files
	home.packages = with pkgs; [
		devenv
		adwaita-icon-theme
		papirus-icon-theme
		nwg-look
	];
	qt = {
		enable = true;
		platformTheme.name = "gtk3";
		style = {
			name = "breeze-dark";
			package = pkgs.kdePackages.breeze;
		};
		qt5ctSettings = {
			Fonts = {
				fixed = "NotoMono NF, 16";
				general = "NotoMono NF, 16";
			};
		};
		qt6ctSettings = {
			Fonts = {
				fixed = "NotoMono NF, 16";
				general = "NotoMono NF, 16";
			};
		};
	};
	xdg.mimeApps = {
		enable = true;
		defaultApplications = let
			imageViewer = "imv.desktop";
			videoViewer = "mpv.desktop";
			fileViewer = "org.gnome.Nautilus.desktop";
			browser = "firefox.desktop";
			editor = "emacsclient.desktop";
		in {
			"image/gif" = imageViewer;
			"image/png" = imageViewer;
			"image/jpg" = imageViewer;
			"image/jpeg" = imageViewer;
			"video/mp4" = videoViewer;
			"video/webm" = videoViewer;
			"inode/directory" = fileViewer;
			"application/x-gnome-saved-search" = fileViewer;
			"application/pdf" = browser;
			"text/plain"=editor;
			"text/x-python"=editor;
			"text/x-shellscript"=editor;
			"text/markdown"=editor;
			"application/x-zerosize"=editor;
		};
	};
	home.file = {
		".config/niri" = {
			source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/niri";
			force = true;
		};
		".config/mango" = {
			source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/mango";
			force = true;
		};
		".config/helix" = {
			source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/helix";
		};
		".config/emacs/init.el" = {
			source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/emacs/init.el";
		};
		".config/starship.toml" = {
			source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/starship.toml";
		};
		".config/emacs/autoload" = {
			source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/emacs/autoload";
		};
		".config/emacs/themes" = {
			source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/emacs/themes";
		};
		".config/fastfetch" = {
			source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/fastfetch";
		};
	};
}
