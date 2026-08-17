{ ... }: {
	flake.nixosModules.packages-general = { pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			spotify
			rhythmbox
			upscayl
			libreoffice
			losslesscut-bin
			imv
			krita
			protontricks
			emacs-pgtk
			gimp
			localsend
			equibop
			proton-vpn
			mpv
			feh
			protonplus
			gromit-mpx
			mangohud
			r2modman
			direnv
			ghostty
			tack
			audacity
		];
		programs.mango.enable = true;
		programs.niri.enable = true;
		programs.firefox.enable = true;
		programs.steam.enable = true;
		programs.steam.extraCompatPackages = with pkgs; [
			proton-ge-bin
		];
	};
}
