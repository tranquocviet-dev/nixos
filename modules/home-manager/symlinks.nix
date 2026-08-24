{ ... }:
{
	flake.homeManagerModules.symlinks = { config, ... }:
		let
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
		in {
			home.file = {
				".config/niri" = symlink "niri";
				".config/mango" = symlink "mango";
				".config/helix" = symlink "helix";
				".config/icewm" = symlink "icewm";
				".config/bspwm" = symlink "bspwm";
				".config/sxhkd" = symlink "sxhkd";
				".config/scripts" = symlink "scripts";
				".config/starship.toml" = symlink "starship.toml";
				".config/fastfetch" = symlink "fastfetch";
			} // (if useDoom then doomEmacsFiles else vanillaEmacsFiles);
		};
}
