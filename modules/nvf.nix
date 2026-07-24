{ pkgs, lib, ... }:
{
	programs.nvf = {
		enable = true;
		settings.vim = {
            visuals = {
                indent-blankline.enable = true;
                nvim-web-devicons.enable = true;
            };
            options = {
                completeopt = ["menu" "menuone" "noselect" "noinsert"];
                signcolumn = "no";
                expandtab = false;
                softtabstop = 4;
                shiftwidth = 4;
                tabstop = 4;
            };
			theme = {
				enable = true;
				name = "catppuccin";
				style = "mocha";
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
