{ ... }: {
	flake.nixosModules.packages-general = { pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			spotify
			imv
			krita
			protontricks
			(pkgs.emacs.override {
				withGTK3 = false;
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
			(pkgs.callPackage ../../pkgs/boomer { })
			(pkgs.callPackage ../../pkgs/siclone { })
		];
		programs.niri.enable = true;
		programs.umbriel.enable = true;
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
