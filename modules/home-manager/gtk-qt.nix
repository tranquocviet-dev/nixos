{ ... }:
{
	flake.homeManagerModules.gtk-qt = { pkgs, ... }:
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
		in {
			home.packages = with pkgs; [
				mizuki-cursor
				adwaita-icon-theme
				papirus-icon-theme
			];
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
		};
}
