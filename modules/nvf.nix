{ ... }: {
	flake.nixosModules.nvf = { ... }: {
		programs.nvf = {
			enableManpages = true;
			enable = true;
			settings.vim = {
				visuals = {
					indent-blankline.enable = true;
					nvim-web-devicons.enable = true;
				};
				options = {
					winborder = "rounded";
					completeopt = ["menu" "menuone" "noselect" "noinsert"];
					signcolumn = "no";
					expandtab = false;
					softtabstop = 4;
					shiftwidth = 4;
					tabstop = 4;
				};
				theme = {
					enable = true;
					name = "base16";
					style = "auto";
					base16-colors.base00 = "1d1f21";
					base16-colors.base01 = "282a2e";
					base16-colors.base02 = "373b41";
					base16-colors.base03 = "969896";
					base16-colors.base04 = "b4b7b4";
					base16-colors.base05 = "c5c8c6";
					base16-colors.base06 = "e0e0e0";
					base16-colors.base07 = "ffffff";
					base16-colors.base08 = "cc6666";
					base16-colors.base09 = "de935f";
					base16-colors.base0A = "f0c674";
					base16-colors.base0B = "b5bd68";
					base16-colors.base0C = "8abeb7";
					base16-colors.base0D = "81a2be";
					base16-colors.base0E = "b294bb";
					base16-colors.base0F = "a3685a";
				};
				languages = {
					enableTreesitter = true;
					nix = {
						enable = true;
						lsp = {
							enable = true;
							servers = [ "nixd" ];
						};
					};
					clang.enable = true;
					python = {
						enable = true;
						lsp.servers = [ "ruff" ];
					};
					html = {
						enable = true;
						lsp.servers = [ "emmet-ls" ];
					};
					css = {
						enable = true;
						lsp.servers = [ "emmet-ls" ];
					};
					typescript = {
						enable = true;
						lsp.servers = [ "emmet-ls" ];
					};
				};
				statusline.lualine = {
					enable = true;
				};
				utility = {
					oil-nvim ={
						enable = true;
						setupOpts = {
							columns = [
								"permissions"
								"mtime"
								"icon"
							];
							view_options = {
								show_hidden = true;
							};
						};
					};
				};
				mini = {
					pairs.enable = true;
					icons.enable = true;
				};
				telescope = {
					enable = true;
					mappings = {
						findFiles = "<C-x><C-f>";
						buffers = "<C-x><C-b>";
						liveGrep = "<C-x><C-/>";
					};
				};
				lsp.enable = true;
				autocomplete.blink-cmp = {
					enable = true;
					setupOpts = {
						completion = {
							list = {
								selection = {
									preselect = false;
									auto_insert = true;
								};
							};
							menu = {
								auto_show = true;
							};
						};
					};
				};
				keymaps = [
					{
						key = "<C-S-Space>";
						mode = [ "n" ];
						action = "V";
						silent = true;
					}
					{
						key = "<C-Space>";
						mode = [ "n" ];
						action = "v";
						silent = true;
					}
					{
						key = "<A-w>";
						mode = [ "v" ];
						action = "\"+y";
						silent = true;
					}
					{
						key = "<C-w>";
						mode = [ "v" ];
						action = "\"+d";
						silent = true;
					}
					{
						key = "<C-y>";
						mode = [ "i" ];
						action = "<C-o>\"+p";
						silent = true;
					}
					{
						key = "<C-y>";
						mode = [ "n" ];
						action = "\"+p";
						silent = true;
					}
					{
						key = "<C-x><C-q>";
						mode = [
							"n"
							"v"
						];
						action = ":q<CR>";
						silent = true;
					}
					{
						key = "<C-x><C-e>";
						mode = [
							"n"
							"v"
						];
						action = ":Oil<CR>";
						silent = true;
					}
					{
						key = "<C-x><Right>";
						mode = [
							"i"
							"n"
						];
						action = ":bn<CR>";
						silent = true;
					}
					{
						key = "<C-x><Left>";
						mode = [
							"i"
							"n"
						];
						action = ":b #<CR>";
						silent = true;
					}
					{
						key = "<C-Backspace>";
						mode = [
							"i"
						];
						action = "<C-o>db";
						silent = true;
					}
					{
						key = "<C-x><C-s>";
						mode = [
							"n"
							"v"
						];
						action = ":w<CR>";
						silent = true;
					}
				];
			};
		};
	};
}
