{ system, inputs, pkgs, config, user, ... }: {
	home.username = "${user}";
	home.homeDirectory = "/home/${user}";
	home.stateVersion = "26.05";
	# 1. Importing my nix files
	home.packages = [
		pkgs.devenv
		pkgs.adwaita-icon-theme
		pkgs.papirus-icon-theme
	];
	# 2. Configure GTK
	gtk = {
		enable = true;
		font.name = "Maple Mono NF";
		font.size = 16;
		# 3. Set the theme name (exact name of the theme folder)
		theme = {
			name = "adw-gtk3-dark";
			package = pkgs.adw-gtk3;
		};
		
		# Optional: Set your icons and cursors
		iconTheme = {
			name = "Papirus-Dark";
			package = pkgs.papirus-icon-theme;
		};
	};
	qt = {
		enable = true;
		platformTheme.name = "gtk3";
		style = {
			name = "breeze-dark";
			package = pkgs.kdePackages.breeze;
		};
		qt5ctSettings = {
			Fonts = {
				fixed = "Maple Mono NF, 16";
				general = "Maple Mono NF, 16";
			};
		};
		qt6ctSettings = {
			Fonts = {
				fixed = "Maple Mono NF,16";
				general = "Maple Mono NF, 16";
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
		in {
			"image/png" = imageViewer;
			"image/jpg" = imageViewer;
			"image/jpeg" = imageViewer;
			"video/mp4" = videoViewer;
			"video/webm" = videoViewer;
			"inode/directory" = fileViewer;
			"application/x-gnome-saved-search" = fileViewer;
			"application/pdf" = browser;
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
