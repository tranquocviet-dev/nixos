{ ... }: {
	flake.nixosModules.fonts = { pkgs, ... }: {
		fonts.enableDefaultPackages = true;
		fonts.fontDir.enable = true;
		fonts.packages = with pkgs; [
			nerd-fonts.symbols-only
			ibm-plex
			noto-fonts-cjk-sans
		];
	};
}
