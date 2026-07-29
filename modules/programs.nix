{ pkgs, ... }:
{
	environment.systemPackages = with pkgs; [
		# services
		dash
		tk
		vips
		xwayland-satellite
		adw-gtk3
		git
		killall
		librsvg
		gdk-pixbuf
		# apps
		woomer
		xdg-desktop-portal-wlr
		proton-vpn
		eza
		slurp
		grim
		swappy
		gamemode
		localsend
		openssl
		equibop
		wlr-randr
		nodejs
		wl-clipboard
		luajit
		gnumake
		clang
		mpvpaper
		pywalfox-native
		thokr
		rhythmbox
		upscayl
		libreoffice
		losslesscut-bin
		gpu-screen-recorder
		obsidian
		qimgv
		kitty
		krita
		protontricks
		lutgen
		helix
		spotify
		mesa-demos
		typst
		btop
		lshw
		foot
		mpv
		feh
		fastfetch
		ps_mem
		obs-studio
		pandoc
		wget
		emacs-gtk
		pcmanfm
		engrampa
		unzip
	];
	programs.mango.enable = true;
	programs.xwayland.enable = true;
	programs.firefox.enable = true;
	programs.steam.enable = true;
	programs.steam.extraCompatPackages = with pkgs; [
		proton-ge-bin
	];
	programs.noctalia-greeter.enable = true;
	programs.npm.enable = true;
	# Enable Fcitx5
	i18n.inputMethod = {
		enable = true;
		type = "fcitx5";
		fcitx5.addons = with pkgs; [
			fcitx5-gtk
			kdePackages.fcitx5-configtool # GUI Config Tool
			# Addons for your specific language:
			# fcitx5-chinese-addons  # For Pinyin/Table input
			# fcitx5-mozc            # For Japanese
			qt6Packages.fcitx5-unikey # For Vietnamese
			# fcitx5-rime            # For Rime
		];
	};
}
