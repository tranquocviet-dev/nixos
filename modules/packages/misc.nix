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
			# emacs lsp
			nixd
			emmet-ls
			ruff
			python3Packages.jedi-language-server

			# treesitter
			tree-sitter-grammars.tree-sitter-python
			tree-sitter-grammars.tree-sitter-nix
			tree-sitter-grammars.tree-sitter-html
			tree-sitter-grammars.tree-sitter-css
			tree-sitter-grammars.tree-sitter-javascript
		];
	};
}
