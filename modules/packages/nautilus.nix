{ ... }: {
	flake.nixosModules.packages-file-manager = { pkgs, ... }: {
		programs.dconf.enable = true;
		services.gvfs.enable = true;
		services.udisks2.enable = true;
		#environment.systemPackages = with pkgs; [
		#	nautilus
		#	nautilus-open-any-terminal
		#	nautilus-python
		#
		#	file-roller
		#	p7zip
		#	unrar
		#	unzip
		#	zip
		#
		#	imagemagick
		#];
		# 1. Enable Thunar and its native archive management plugin
		programs.thunar = {
			enable = true;
			plugins = with pkgs; [
				thunar-archive-plugin
				thunar-volman
			];
		};

		# 2. Xfconf (required to save Thunar preferences outside XFCE desktop)
		programs.xfconf.enable = true;

		# 3. Essential filesystem daemons (Trash, removable mounts, and image thumbnails)
		services.tumbler.enable = true;

		# 4. CLI compression utilities, backend GUI archive manager, and image tools
		environment.systemPackages = with pkgs; [
			file-roller # Frontend engine for thunar-archive-plugin (Extract here, Create archive)
			p7zip
			unrar
			unzip
			zip
			imagemagick
		];
	};
}
