{ pkgs, lib, ... }:
{
	programs.nvf = {
		enable = true;
		settings.vim = {
            options = {
                signcolumn =  "no";
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
            };
			autocomplete.blink-cmp.enable = true;
            lsp.enable = true;
		};
	};
}
