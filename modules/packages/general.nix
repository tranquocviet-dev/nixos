{ ... }: {
	flake.nixosModules.packages-general = { pkgs, inputs, ... }: {
		environment.systemPackages = with pkgs; [
			spotify
			imv
			krita
			protontricks
			(pkgs.emacs.override {
				withGTK3 = true;
				withNativeCompilation = true;
			})
			kitty
			localsend
			equibop
			proton-vpn
			mpv
			feh
			protonplus
			mangohud
			r2modman
			direnv
			tack
			lollypop
			opencode
			rofi
			xwallpaper
			zenity
			xsetroot
			conky
			sxhkd
			fzf
			dmenu
			j4-dmenu-desktop
			bemenu
			tigervnc
			codeium
			(pkgs.callPackage ../../pkgs/boomer { })
			(pkgs.callPackage ../../pkgs/siclone { })
		];
		programs.niri.enable = true;
		imports = [ inputs.umbriel.nixosModules.default ];
		programs.umbriel = {
			enable = true;
			portalPackage = pkgs.xdg-desktop-portal-umbriel;
		};
		programs.firefox.enable = true;
		programs.steam.enable = true;
		programs.zoxide = {
			enable = true;
			enableFishIntegration = true;
			flags = [
				"--cmd"
				"cd"
			];
		};
		services.xserver.windowManager.bspwm.enable = true;
	};
}
