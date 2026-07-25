{ ... }:
{
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
                        "pyrefly"
                    ];
                };
				html.enable = true;
                css.enable = true;
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
					findFiles = "<leader>f";
					buffers = "<leader>b";
					liveGrep = "<leader>/";
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
            globals.mapleader = " ";
            keymaps = [
                {
                    key = "<leader>e";
                    mode = [
                        "n"
                        "v"
                    ];
                    action = ":Oil<CR>";
                    silent = true;
                }
                {
                    key = "<leader>s";
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
}
