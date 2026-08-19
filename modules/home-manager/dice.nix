{ ... }:
{
	flake.homeManagerModules.dice = { config, pkgs, user, ... }: let
		useDoom = true; # Set to true for Doom Emacs, false for Vanilla
	
		symlink = path: {
			source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos/symlinkfiles/${path}";
			force = true;
		};
	
		vanillaEmacsFiles = {
			".config/emacs/init.el" = symlink "emacs/init.el";
			".config/emacs/autoload" = symlink "emacs/autoload";
			".config/emacs/themes" = symlink "emacs/themes";
		};

		doomEmacsFiles = {
			# Doom's core framework runs as the main Emacs directory
			".config/emacs" = {
				source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/doomemacs";
				force = true;
			};
			# Doom private user config
			".config/doom" = symlink "doom";
		};
		mizuki-cursor = pkgs.stdenv.mkDerivation {
			pname = "mizuki-icons";
			version = "1.0.0";
		
			# Point directly to your local file (placed next to home.nix)
			src = ./mizuki-psekai-cursor.tar.xz;

			dontBuild = true;

			installPhase = ''
						 runHook preInstall

						 # Create the exact directory expected by Home Manager
						 mkdir -p $out/share/icons/mizuki-psekai-cursor

						 # If the archive extracts into a subfolder, copy its contents:
						 if [ -d "mizuki-psekai-cursor" ]; then
						 	cp -r mizuki-psekai-cursor/* $out/share/icons/mizuki-psekai-cursor/
						 else
						 	cp -r * $out/share/icons/mizuki-psekai-cursor/
						 fi

						 runHook postInstall
						 '';
		};
	in {
		home.username = "${user}";
		home.homeDirectory = "/home/${user}";
		home.stateVersion = "26.05";
		# 1. Importing my nix files
		home.packages = with pkgs; [
			mizuki-cursor
			adwaita-icon-theme
			papirus-icon-theme
		];
		programs.ghostty = {
			enable = true;
		};
		xdg.configFile."systemd/user/graphical-session.target.wants/app-com.mitchellh.ghostty.service".source = "${pkgs.ghostty}/share/systemd/user/app-com.mitchellh.ghostty.service";
		home.pointerCursor = {
			enable = true;
			gtk.enable = true;
			x11.enable = true;
			name = "mizuki-psekai-cursor"; # Name of the folder containing index.theme & cursors/
			package = mizuki-cursor;
			size = 24;
		};
		gtk = {
			enable = true;
			theme = {
				name = "adw-gtk3-dark";
				package = pkgs.adw-gtk3;
			};
			iconTheme = {
				name = "Papirus-Dark";
				package = pkgs.papirus-icon-theme;
			};
			font = {
				name = "NotoMono NF";
				size = 16;
			};
			gtk3.extraConfig = {
				gtk-application-prefer-dark-theme = 1;
			};
			gtk4.extraConfig = {
				gtk-application-prefer-dark-theme = 1;
			};
			colorScheme = "dark";
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
			".config/niri" = symlink "niri";
			".config/mango" = symlink "mango";
			".config/helix" = symlink "helix";
			".config/starship.toml" = symlink "starship.toml";
			".config/fastfetch" = symlink "fastfetch";
		} // (if useDoom then doomEmacsFiles else vanillaEmacsFiles);
	};
}
