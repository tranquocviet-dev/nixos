{ ... }: {
	flake.nixosModules.fish = { specialArgs, pkgs, ... }: {
		programs.fish = {
			enable = true;
			shellAliases = {
				ls = "eza";
				am = "emacsclient -c";
				larp = "cd ~/SillyTavern && ./start.sh";
			};
		};
		# Set fish as the default shell for your user
		users.users.${specialArgs.user} = {
			shell = pkgs.fish;
		};
		programs.starship.enable = true;
	};
}
