{ ... }:
{
	flake.homeManagerModules.gtk-qt =
		{ pkgs, ... }:
		let
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
		in
		{
			home.packages = with pkgs; [
				mizuki-cursor
				adwaita-icon-theme
				papirus-icon-theme
				gsettings-desktop-schemas
				glib # provides gsettings
			];
			home.pointerCursor = {
				enable = true;
				gtk.enable = true;
				x11.enable = true;
				name = "mizuki-psekai-cursor"; # Name of the folder containing index.theme & cursors/
				package = mizuki-cursor;
				size = 24;
			};
			fonts.fontconfig = {
				enable = true;
				defaultFonts = {
					serif = [
						"JetBrains Mono"
						"Noto Sans Mono CJK SC"
						"Symbols Nerd Font Mono"
					];
					sansSerif = [
						"JetBrains Mono"
						"Noto Sans Mono CJK SC"
						"Symbols Nerd Font Mono"
					];
					monospace = [
						"JetBrains Mono"
						"Noto Sans Mono CJK SC"
						"Symbols Nerd Font Mono"
					];
				};
			};
			services.xsettingsd = {
				enable = true;
				settings = {
					"Net/ThemeName" = "adw-gtk3";
					"Net/IconThemeName" = "Papirus";
					"Gtl/ColorScheme" = "prefer-light";
					"Gtk/ApplicationPreferDarkTheme" = 0;
				};
			};
			gtk = {
				enable = true;
				theme = {
					name = "adw-gtk3";
					package = pkgs.adw-gtk3;
				};
				iconTheme = {
					name = "Papirus-Dark";
					package = pkgs.papirus-icon-theme;
				};
				font = {
					name = "Sans-Serif";
					size = 16;
				};
				gtk3.extraConfig = {
					gtk-application-prefer-dark-theme = 0;
				};
				gtk4.extraConfig = {
					gtk-application-prefer-dark-theme = 0;
				};
				colorScheme = "light";
			};
			qt = {
				enable = true;
				platformTheme.name = "gtk3";
				style = {
					name = "breeze";
					package = pkgs.kdePackages.breeze;
				};
				qt5ctSettings = {
					Fonts = {
						fixed = "Sans-Serif, 16";
						general = "Sans-Serif, 16";
					};
				};
				qt6ctSettings = {
					Fonts = {
						fixed = "Sans-Serif, 16";
						general = "Sans-Serif, 16";
					};
				};
			};
		};
}
