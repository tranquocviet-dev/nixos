{ ... }: {
	flake.nixosModules.packages-misc = { pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			# apps
			woomer
			eza
			slurp
			grim
			swappy
			gamemode
			openssl
			wlr-randr
			nodejs
			wl-clipboard
			luajit
			gnumake
			clang
			mpvpaper
			pywalfox-native
			thokr
			lutgen
			mesa-demos
			typst
			btop
			lshw
			fastfetch
			ps_mem
			pandoc
			wget
			gimp
			unrar
			unzip
			ripgrep
			fd
			# emacs stuff
			nixd
			nixfmt
			ruff
			python3Packages.python-lsp-server
		];
	};
}
