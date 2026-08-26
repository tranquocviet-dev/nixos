{ ... }: {
	flake.nixosModules.packages-misc = { pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			# apps
			eza
			slurp
			grim
			swappy
			gamemode
			openssl
			wl-clipboard
			luajit
			gnumake
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
			unrar
			unzip
			ripgrep
			fd
			# emacs stuff
			clang-tools
			nixd
			nixfmt
			ruff
			python3Packages.python-lsp-server
		];
	};
}
