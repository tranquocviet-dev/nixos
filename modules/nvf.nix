{ pkgs, lib, ... }:
{
	programs.nvf = {
		enable = true;
		settings.vim = {
            options = {
                signcolumn = "no";
                shiftwidth = 4;
                tabstop = 4;
            };
			theme = {
				enable = true;
				name = "gruvbox";
				style = "dark";
			};
			languages = {
				enableTreesitter = true;
				nix.enable = true;
                clang.enable = true;
				python = {
                    enable = true;
                    lsp.servers = [
                        "ty"
                        "ruff"
                    ];
                };
				html.enable = true;
                css.enable = true;
			};
            mini = {
                pairs.enable = true;
                icons.enable = true;
                statusline.enable = true;
                pick.enable = true;
            };
            lsp.enable = true;
            autocomplete.nvim-cmp = {
                enable = true;
                setupOpts.completion.completeopt = "menu,menuone,noinsert,noselect";
            };
            globals.mapleader = " ";
            keymaps = [
                {
                    key = "<leader>s";
                    mode = [
                        "n"
                        "v"
                    ];
                    action = ":w<CR>";
                    silent = true;
                }
                {
                    key = "<leader>/";
                    mode = [
                        "n"
                        "v"
                    ];
                    action = ":Pick grep_live<CR>";
                    silent = true;
                }
                {
                    key = "<leader>e";
                    mode = [
                        "n"
                        "v"
                    ];
                    action = ":Pick files<CR>";
                    silent = true;
                }

            ];
		};
	};
}
