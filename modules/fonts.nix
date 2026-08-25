{ ... }: {
	flake.nixosModules.fonts = { pkgs, ... }: {
		fonts.enableDefaultPackages = true;
		fonts.fontDir.enable = true;
		fonts.packages = with pkgs; [
			nerd-fonts.symbols-only
			lilex
			noto-fonts-cjk-sans
			source-code-pro
		];
	};
}
