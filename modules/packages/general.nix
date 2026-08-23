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
		];
		programs.niri.enable = false;
		programs.firefox.enable = true;
		programs.steam.enable = true;
		programs.steam.extraCompatPackages = with pkgs; [
		];
		programs.zoxide = {
			enable = true;
			enableFishIntegration = true;
			flags = [
				"--cmd"
				"cd"
			];
		};
		services.xserver.windowManager.icewm.enable = true;
	};
}
