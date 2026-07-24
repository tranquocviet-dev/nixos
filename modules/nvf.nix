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
                indentscope.enable = true;
                statusline.enable = true;
                pick.enable = true;
                completion.enable = true;
            };
            lsp.enable = true;
            visuals.nvim-web-devicons.enable = true;
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
